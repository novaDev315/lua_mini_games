local json = { _VERSION = '1.0.0' }

local type = type
local tostring = tostring
local pairs = pairs
local ipairs = ipairs
local error = error
local pcall = pcall
local require = require
local rawset = rawset
local setmetatable = setmetatable
local getmetatable = getmetatable
local tonumber = tonumber
local string = string
local table = table

local encode_char_map = {
  ['\\'] = '\\',
  ['"'] = '"',
  ['\b'] = '\b',
  ['\f'] = '\f',
  ['\n'] = '\n',
  ['\r'] = '\r',
  ['\t'] = '\t'
}

local encode_char_pattern = '["\\\b\f\n\r\t]'

local function encode_char(c)
  return encode_char_map[c]
end

local function encode(val, prev_tables)
  local s = {}
  local typ = type(val)

  if typ == 'string' then
    return '"' .. val:gsub(encode_char_pattern, encode_char) .. '"'

  elseif typ == 'number' then
    -- Check if number is an integer or float
    if val == math.floor(val) then
      return tostring(val)
    else
      return string.format('%.14g', val)
    end

  elseif typ == 'boolean' then
    return tostring(val)

  elseif typ == 'table' then
    if prev_tables and prev_tables[val] then
      error('circular reference')
    end
    prev_tables = prev_tables or {}
    prev_tables[val] = true

    local is_array = true
    local len = #val
    for i = 1, len do
      if val[i] == nil then
        is_array = false
        break
      end
    end
    if is_array then
      for i = 1, len do
        s[i] = encode(val[i], prev_tables)
      end
      return '[' .. table.concat(s, ',') .. ']'
    else
      for k, v in pairs(val) do
        if type(k) ~= 'string' then
          error('non-string key: ' .. tostring(k))
        end
        s[#s + 1] = encode(k, prev_tables) .. ':' .. encode(v, prev_tables)
      end
      return '{' .. table.concat(s, ',') .. '}'
    end

  elseif typ == 'nil' then
    return 'null'

  else
    error('unsupported type: ' .. typ)
  end
end

local decode_char_map = {
  ['"'] = '"',
  ['\\'] = '\\',
  ['/'] = '/',
  ['b'] = '\b',
  ['f'] = '\f',
  ['n'] = '\n',
  ['r'] = '\r',
  ['t'] = '\t'
}

local function decode_string(str, pos)
  local s = {}
  local i = pos + 1
  local char = str:sub(i, i)

  while char ~= '"' do
    if char == '\\' then
      i = i + 1
      char = str:sub(i, i)
      if decode_char_map[char] then
        s[#s + 1] = decode_char_map[char]
      elseif char == 'u' then
        local hex = str:sub(i + 1, i + 4)
        local code = tonumber(hex, 16)
        if code then
          s[#s + 1] = string.char(code)
          i = i + 4
        else
          error('invalid unicode escape at ' .. i)
        end
      else
        error('invalid escape sequence at ' .. i)
      end
    else
      s[#s + 1] = char
    end
    i = i + 1
    char = str:sub(i, i)
  end
  return table.concat(s), i + 1
end

local function decode_number(str, pos)
  local i = pos
  local char = str:sub(i, i)
  local s = {}

  while char:match('[%d%.%+%-%Ee]') do
    s[#s + 1] = char
    i = i + 1
    char = str:sub(i, i)
  end
  return tonumber(table.concat(s)), i
end

local function decode_literal(str, pos, literal)
  local len = #literal
  if str:sub(pos, pos + len - 1) == literal then
    return true, pos + len
  else
    error('expected ' .. literal .. ' at ' .. pos)
  end
end

local function decode_table(str, pos)
  local t = {}
  local i = pos + 1
  local char = str:sub(i, i)

  -- Handle empty array case: []
  if str:sub(pos, pos + 1) == "[]" then
    return {}, pos + 2
  end

  while char ~= '}' do
    if char == '[' then -- array
      local val, next_pos = decode_table(str, i)
      table.insert(t, val)
      i = next_pos
    elseif char == '{' then -- object
      local key, next_pos = decode_string(str, i)
      i = next_pos
      char = str:sub(i, i)
      if char ~= ':' then
        error('expected : at ' .. i)
      end
      i = i + 1
      local val, next_pos = decode_value(str, i)
      t[key] = val
      i = next_pos
    elseif char == '"' then -- string
      local val, next_pos = decode_string(str, i)
      table.insert(t, val)
      i = next_pos
    elseif char:match('[%d%.%+%-%Ee]') then -- number
      local val, next_pos = decode_number(str, i)
      table.insert(t, val)
      i = next_pos
    elseif char == 't' then -- true
      local val, next_pos = decode_literal(str, i, 'true')
      table.insert(t, val)
      i = next_pos
    elseif char == 'f' then -- false
      local val, next_pos = decode_literal(str, i, 'false')
      table.insert(t, val)
      i = next_pos
    elseif char == 'n' then -- null
      local val, next_pos = decode_literal(str, i, 'null')
      table.insert(t, val)
      i = next_pos
    elseif char == ',' or char:match('%s') then
      i = i + 1
    else
      error('unexpected character at ' .. i .. ': ' .. char)
    end
    char = str:sub(i, i)
  end
  return t, i + 1
end

local function decode_value(str, pos)
  local i = pos
  local char = str:sub(i, i)

  while char:match('%s') do
    i = i + 1
    char = str:sub(i, i)
  end

  if char == '"' then
    return decode_string(str, i)
  elseif char == '[' or char == '{' then
    return decode_table(str, i)
  elseif char:match('[%d%.%+%-%Ee]') then
    return decode_number(str, i)
  elseif char == 't' then
    return decode_literal(str, i, 'true')
  elseif char == 'f' then
    return decode_literal(str, i, 'false')
  elseif char == 'n' then
    return decode_literal(str, i, 'null')
  else
    error('unexpected character at ' .. i .. ': ' .. char)
  end
end

function json.decode(str)
  local val, pos = decode_value(str, 1)
  if pos <= #str then
    error('trailing characters at ' .. pos)
  end
  return val
end

function json.encode(val)
  return encode(val)
end

return json