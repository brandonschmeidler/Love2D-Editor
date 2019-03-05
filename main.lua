-----------------------------------------------------------------------------
-- Name:       Love2D Editor
-- Purpose:    WSYIWYG Editor for Love2D
-- Author:     Brandon Schmeidler
-- Created:    2/28/2019
-- RCS-ID:     I don't know what this is
-- Copyright:  (c) 2019 Brandon Schmeidler. All rights reserved. I guess.
-- License:    wxWidgets license
-----------------------------------------------------------------------------

-- local IDCOUNTER = wx.wxID_HIGHEST
-- function IdManager.Get():NewID()
--     IDCOUNTER = IDCOUNTER + 1
--     return IDCOUNTER
-- end

--local ID = {}

local ContentBrowser = require("src.ContentBrowser")
local ConsoleOutput = require("src.ConsoleOutput")
local IdManager = require("src.IdManager").Get()

function main()
    frame = wx.wxFrame(wx.NULL, IdManager:NewId("Frame"), "Love2D Editor",wx.wxDefaultPosition, wx.wxSize(640,480))

    editorNotebook = wxaui.wxAuiNotebook(frame, IdManager:NewId("EditorNotebook"))
    browse = ContentBrowser(frame, IdManager:NewId("ContentBrowser"))
    output = ConsoleOutput(frame, IdManager:NewId("ConsoleOutput"))

    auiManager = wxaui.wxAuiManager(frame)
    auiManager:AddPane(editorNotebook, wxaui.wxAuiPaneInfo():Name("Editors"):CaptionVisible(false):Center())
    auiManager:AddPane(browse:GetWidget(), wxaui.wxAuiPaneInfo():Name("ContentBrowser"):Caption("Content"):Right())
    auiManager:AddPane(output:GetWidget(), wxaui.wxAuiPaneInfo():Name("ConsoleOutput"):Caption("Console"):Bottom())
    auiManager:Update()

    browse:SetRoot(wx.wxStandardPaths.Get():GetResourcesDir() .. "\\TestProject")
    output:Print("Love2D Editor Initialized")
    output:Print("")

    frame:Show(true)
end

main()