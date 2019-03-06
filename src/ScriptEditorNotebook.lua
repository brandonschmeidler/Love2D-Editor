local wxWidget = require("src.wxWidget")

local ScriptEditorNotebook = wxWidget:extend("ScriptEditorNotebook")

function ScriptEditorNotebook:init(parent,id)

    self.widget = wxaui.wxAuiNotebook(parent,id)

end

function ScriptEditorNotebook:AddPage(filepath)
    
    local function fileExt (filename) return filename:match("(%.%w+)$") or "" end
    if (wx.wxFileExists(filepath) and fileExt(filepath) == ".lua") then
        local newEditor = wxstc.wxStyledTextCtrl(self.widget,wx.wxID_ANY)
        newEditor:LoadFile(filepath)
        self.widget:AddPage(newEditor,wx.wxFileName.FileName(filepath):GetName())
    end

end

return ScriptEditorNotebook