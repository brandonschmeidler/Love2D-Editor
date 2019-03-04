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

function main()
    ID.Frame = NewID()
    frame = wx.wxFrame(wx.NULL, ID.Frame, "Love2D Editor",wx.wxDefaultPosition, wx.wxSize(640,480))

    auiManager = wxaui.wxAuiManager(frame)

    ID.EditorNotebook = NewID()
    editorNotebook = wxaui.wxAuiNotebook(frame, ID.EditorNotebook)

    ID.ContentBrowser = NewID()
    browse = ContentBrowser(frame,ID.ContentBrowser)
    browse:SetRoot(wx.wxStandardPaths.Get():GetDocumentsDir() .. "\\Love2DEditorTestingGrounds")

    auiManager:AddPane(editorNotebook, wxaui.wxAuiPaneInfo():Name("Editors"):CaptionVisible(false):Center())
    auiManager:AddPane(browse:GetWidget(),wxaui.wxAuiPaneInfo():Name("ContentBrowser"):Caption("Content"):Left())
    auiManager:Update()

    frame:Show(true)
end

main()