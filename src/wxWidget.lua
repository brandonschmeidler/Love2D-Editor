local class = require("lib.30log")

local wxWidget = class("wxWidget", {widget = nil})

function wxWidget:GetWidget()
    return self.widget
end

return wxWidget