-----------------------------------------------------------------------------
-- Name:        minimal.wx.lua
-- Purpose:     'Minimal' wxLua sample
-- Author:      J Winwood
-- Modified by:
-- Created:     16/11/2001
-- RCS-ID:      $Id: veryminimal.wx.lua,v 1.7 2008/01/22 04:45:39 jrl1 Exp $
-- Copyright:   (c) 2001 J Winwood. All rights reserved.
-- Licence:     wxWidgets licence
-----------------------------------------------------------------------------

-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
require("wx")

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

    runningPID = wx.wxExecute("lovec", wx.wxEXEC_ASYNC, wx.wxProcess(frame))
    if (runningPID > 0) then
        print("Program started succesfully -- PID: " .. tostring(runningPID))
    end
end

function CreateMenuBar()
    local fileMenu = wx.wxMenu()
    fileMenu:Append(wx.wxID_EXIT, "Exit","Quit the program")

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
    frame = wx.wxFrame( wx.NULL, wx.wxID_ANY, "wxLua Very Minimal Demo",
                        wx.wxDefaultPosition, wx.wxSize(640,480),
                        wx.wxDEFAULT_FRAME_STYLE )
    
    frame:SetMenuBar(CreateMenuBar())
    
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
wx.wxGetApp():MainLoop()
