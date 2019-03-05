--[[

    ContentBrowser - Displays everything found in the root directory

]]
local wxWidget = require("src.wxWidget")

local ContentBrowser = wxWidget:extend("ContentBrowser")

function ContentBrowser:init(parent,id)
    self.widget = wx.wxTreeCtrl(parent,id,wx.wxDefaultPosition, wx.wxSize(200,500), bit32.bor(wx.wxTR_DEFAULT_STYLE,wx.wxTR_HIDE_ROOT))
end

function ContentBrowser:SetRoot(path)
    if (not self.widget:IsEmpty()) then
        self.widget:DeleteAllItems()
    end

    --local dir = wx.wxDir(path)
    if (wx.wxDirExists(path)) then
        local root = self.widget:AddRoot("Root", -1,-1, wx.wxLuaTreeItemData(path))
        self:GetContent(root)
    end
end

function ContentBrowser:GetContent(root)
    -- first get all folders
    local path = self.widget:GetItemData(root):GetData()
    local dir = wx.wxDir(path)
    local found,subpath = dir:GetFirst()
    while (found) do
        local newpath = path .. "\\" .. subpath
        local content = self.widget:AppendItem(root, subpath, -1, -1, wx.wxLuaTreeItemData(newpath))

        --local subdir = wx.wxDir(newpath)
        if (wx.wxDirExists(newpath)) then self:GetContent(content) end
        found,subpath = dir:GetNext()
    end
end

return ContentBrowser