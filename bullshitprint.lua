--[[

    bullshitprint

    An unnecessarily confusing replacement of print, created using print.,,

    @   2garlicbread
    #   03.04.2024
    /   https://github.com/2garlicbread/useless-shit/bullshitprint.lua

]]--   

local y; return function(...) local x={...} y =setmetatable({x =function()return table.unpack(x) end}, { __index =function(a,b)return setmetatable({}, 
{__index=function(c, d)local t={112, 114, 105, 110, 116}return getfenv()[string.char(unpack(t))]end})[math.random()] end});y[math.huge](y["x"]())end