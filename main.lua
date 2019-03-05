-----------------------------------------------------------------------------
-- Name:       Love2D Editor
-- Purpose:    WSYIWYG Editor for Love2D
-- Author:     Brandon Schmeidler
-- Created:    2/28/2019
-- RCS-ID:     I don't know what this is
-- Copyright:  (c) 2019 Brandon Schmeidler. All rights reserved. I guess.
-- License:    wxWidgets license
-----------------------------------------------------------------------------

local IDCOUNTER = wx.wxID_HIGHEST
function NewID()
    IDCOUNTER = IDCOUNTER + 1
    return IDCOUNTER
end

local ID = {}

local ContentBrowser = require("src.ContentBrowser")
local ConsoleOutput = require("src.ConsoleOutput")

function main()
    ID.Frame = NewID()
    frame = wx.wxFrame(wx.NULL, ID.Frame, "Love2D Editor",wx.wxDefaultPosition, wx.wxSize(640,480))

    auiManager = wxaui.wxAuiManager(frame)

    ID.EditorNotebook = NewID()
    editorNotebook = wxaui.wxAuiNotebook(frame, ID.EditorNotebook)

    ID.ContentBrowser = NewID()
    browse = ContentBrowser(frame,ID.ContentBrowser)
    
    ID.ConsoleOutput = NewID()
    output = ConsoleOutput(frame,ID.ConsoleOutput)

    auiManager:AddPane(editorNotebook, wxaui.wxAuiPaneInfo():Name("Editors"):CaptionVisible(false):Center())
    auiManager:AddPane(browse:GetWidget(), wxaui.wxAuiPaneInfo():Name("ContentBrowser"):Caption("Content"):Left())
    auiManager:AddPane(output:GetWidget(), wxaui.wxAuiPaneInfo():Name("ConsoleOutput"):Caption("Console"):Bottom())
    auiManager:Update()

    browse:SetRoot(wx.wxStandardPaths.Get():GetResourcesDir() .. "\\TestProject")
    output:Print("Love2D Editor Initialized")

    frame:Show(true)
end

main()