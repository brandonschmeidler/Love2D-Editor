local class = require("lib.30log")

local IdManager = class("IdManager")

function IdManager:init()
    self.IDCOUNTER = wx.wxID_HIGHEST

    self.ID = {}
end

function IdManager:NewId(name)
    self.IDCOUNTER = self.IDCOUNTER + 1

    self.ID[name] = self.IDCOUNTER
    return self.IDCOUNTER
end

function IdManager:GetId(name)

    return self.ID[name]

end


local IdManagerInstance = IdManager()

-- Prevent instantiation and extending 
function IdManager.new()
    error("Cannot instantiate IdManager. Use IdManager:Get() to get instance")
end

function IdManager.extend()
    error("Cannot extend IdManager.")
end

function IdManager.Get()
    return IdManagerInstance
end

return IdManager