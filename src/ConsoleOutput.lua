local wxWidget = require("src.wxWidget")

local ConsoleOutput = wxWidget:extend("ConsoleOutput")

function ConsoleOutput:init(parent,id)

    self.widget = wx.wxTextCtrl(parent,id,"",wx.wxDefaultPosition,wx.wxSize(640,200),wx.wxTE_MULTILINE)
    self.widget:SetEditable(false)

    self.widget:Connect(wx.wxEVT_CONTEXT_MENU, function(e)
        local menu = wx.wxMenu()
        menu:Append(self.widget:GetId()+1,"Clear")

        self.widget:PopupMenu(menu)
    end)
    
    self.widget:Connect(wx.wxEVT_COMMAND_MENU_SELECTED, function(e)
        if (e:GetId() == self.widget:GetId()+1) then self:Clear() end
    end)

end

function ConsoleOutput:Print(...)
    local args = {...}
    for _,arg in ipairs(args) do
        if (_ > 1) then self.widget:AppendText("\t") end
        self.widget:AppendText(tostring(arg))
    end
    self.widget:AppendText("\n")
end

function ConsoleOutput:Clear()
    self.widget:SetValue("")
end

return ConsoleOutput