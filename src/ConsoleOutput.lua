local wxWidget = require("src.wxWidget")

local ConsoleOutput = wxWidget:extend("ConsoleOutput")

function ConsoleOutput:init(parent,id)

    self.widget = wx.wxTextCtrl(parent,id,"",wx.wxDefaultPosition,wx.wxSize(640,200))
    self.widget:SetEditable(false)

end

function ConsoleOutput:Print(...)
    local args = {...}
    self.widget:AppendText("\n")
    for _,arg in ipairs(args) do
        if (_ > 1) then self.widget:AppendText("\t") end
        self.widget:AppendText(tostring(arg))
    end
end

function ConsoleOutput:Clear()
    self.widget:SetValue("")
end

return ConsoleOutput