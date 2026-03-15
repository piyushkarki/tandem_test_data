
Cosine = {}

function Cosine:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end


function Cosine:mu(x, y, tag)
    local _tag = math.floor(tag)
    local _mu = 1.0
    if _tag == 1 then
      _mu = 1.0
    elseif _tag == 2 then
      _mu = 2.0
    elseif _tag == 3 then
      _mu = 3.0
    else
      _mu = 4.0
    end
    return _mu
end

function Cosine:lam(x, y)
    return 2.0
end

function Cosine:force(x, y)
    return 5.0*math.pi^2*math.cos(math.pi*x)*math.cos(math.pi*y),
          -3.0*math.pi^2*math.sin(math.pi*x)*math.sin(math.pi*y)
end

function Cosine:solution(x, y)
    return math.cos(math.pi * x) * math.cos(math.pi * y), 0
end

function Cosine:solution_jacobian(x, y)
    return -math.pi * math.sin(math.pi * x) * math.cos(math.pi * y),
           -math.pi * math.cos(math.pi * x) * math.sin(math.pi * y),
            0, 0
end

function Cosine:boundary(x, y)
    return self:solution(x, y)
end

cosine = Cosine:new()
