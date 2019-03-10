local common = {}

function common.equal_floats(a,b)
    local thresh = 1 / 8192
    return math.abs(a - b) < thresh
end

function common.clamp(x,min,max)
    if (x < min) then
        return min
    elseif(max < x) then
        return max
    else
        return x
    end
end

return common