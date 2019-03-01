-----------------------------------------------------------------------------
-- Name:        Love2D Editor
-- Purpose:    WSYIWYG Editor for Love2D
-- Author:      Brandon Schmeidler
-- Modified by:
-- Created:     2/28/2019
-- RCS-ID:     I don't know what this is
-- Copyright:   (c) 2019 B Schmeidler. All rights reserved.I guess.
-- Licence:     wxWidgets licence
-----------------------------------------------------------------------------

-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
--package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
--require("wx")
--local Project = require("Project")

frame = nil
runningPID = 0

function ProgramStopped()
    print("Program stopped successfully -- PID: " .. tostring(runningPID))
end

function StopProgram()
    if (wx.wxProcess.Exists(runningPID)) then 
        local killRet = wx.wxKill(runningPID, wx.wxSIGKILL)
    else
        print("No Program Running")
    end
end

function RunProgram()
    if (wx.wxProcess.Exists(runningPID)) then
        StopProgram()
    end

    runningPID = wx.wxExecute("love", wx.wxEXEC_ASYNC, wx.wxProcess(frame))
    if (runningPID > 0) then
        print("Program started succesfully -- PID: " .. tostring(runningPID))
    else
        print("Something went wrong. Make sure you have Love2D installed on your system and added to PATH")
    end
end

function CreateMenuBar()
    local fileMenu = wx.wxMenu()
    fileMenu:Append(wx.wxID_NEW, "New", "Start a new project")
    fileMenu:Append(wx.wxID_EXIT, "&Exit\tAlt+F4","Quit the program")

    local projectMenu = wx.wxMenu()
    projectMenu:Append(69, "Run","Run the program")
    projectMenu:Append(70, "Stop","Stop the program")

    local menuBar = wx.wxMenuBar()
    menuBar:Append(fileMenu,"File")
    menuBar:Append(projectMenu,"Project")

    return menuBar
end

function main()
    
    -- create the frame window
    frame = wx.wxFrame( wx.NULL, wx.wxID_ANY, "Love2D Editor",
                        wx.wxDefaultPosition, wx.wxSize(640,480),
                        wx.wxDEFAULT_FRAME_STYLE )
    
    frame:SetMenuBar(CreateMenuBar())

    local auiManager = wxaui.wxAuiManager(frame)

    local text1 = wx.wxTextCtrl(frame, -1, "Pane 1 - sample text", wx.wxDefaultPosition, wx.wxSize(200,150), bit32.bor(wx.wxNO_BORDER,wx.wxTE_MULTILINE))
    local text2 = wx.wxTextCtrl(frame, -1, "Pane 2 - sample text", wx.wxDefaultPosition, wx.wxSize(200,150), bit32.bor(wx.wxNO_BORDER,wx.wxTE_MULTILINE))
    local text3 = wx.wxTextCtrl(frame, -1, "Main content window", wx.wxDefaultPosition, wx.wxSize(200,150), bit32.bor(wx.wxNO_BORDER,wx.wxTE_MULTILINE))

    auiManager:AddPane(text1, wx.wxLEFT, "Pane Number One")
    auiManager:AddPane(text2, wx.wxBOTTOM, "Pane Number Two")
    auiManager:AddPane(text3, wx.wxCENTER)

    auiManager:Update()
    
    frame:Connect(wx.wxID_EXIT, wx.wxEVT_COMMAND_MENU_SELECTED, function(e) frame:Close(true) end)
    frame:Connect(69, wx.wxEVT_COMMAND_MENU_SELECTED, RunProgram)
    frame:Connect(70, wx.wxEVT_COMMAND_MENU_SELECTED, StopProgram)
    frame:Connect(wx.wxEVT_END_PROCESS, ProgramStopped)
    -- show the frame window
    frame:Show(true)
end

main()

-- Call wx.wxGetApp():MainLoop() last to start the wxWidgets event loop,
-- otherwise the wxLua program will exit immediately.
-- Does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit since the
-- MainLoop is already running or will be started by the C++ program.
--wx.wxGetApp():MainLoop()
