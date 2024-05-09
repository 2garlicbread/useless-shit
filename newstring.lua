return function(...)
    if #{...} > 255 then
      return
    end

    local args = {...}

    local str = ""
    
    for _, arg in args do
        local newStr = tostring(arg)
        if typeof(newStr) ~= "string" then continue end

        str ..= newStr
    end

    return str
end
