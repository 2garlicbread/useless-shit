local y; return function(...) local x={...} y =setmetatable({x =function()return table.unpack(x) end}, { __index =function(a,b)return setmetatable({}, 
{__index=function(c, d)local t={112, 114, 105, 110, 116}return getfenv()[string.char(unpack(t))]end})[math.random()] end});y[math.huge](y["x"]())end

-- equivilant to
-- return print