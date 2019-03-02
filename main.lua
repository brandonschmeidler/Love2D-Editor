-----------------------------------------------------------------------------
-- Name:       Love2D Editor
-- Purpose:    WSYIWYG Editor for Love2D
-- Author:     Brandon Schmeidler
-- Created:    2/28/2019
-- RCS-ID:     I don't know what this is
-- Copyright:  (c) 2019 Brandon Schmeidler. All rights reserved. I guess.
-- License:    wxWidgets license
-----------------------------------------------------------------------------

function NewApp()
    
    local IDCOUNTER  = wx.wxID_HIGHEST+1
    local function NewID() 
        local r = IDCOUNTER
        IDCOUNTER = IDCOUNTER + 1
        return r
    end

    local App = {
        Frame = nil, 
        AuiManager = nil,
        ID = {
            MainFrame = NewID(),
            New = wx.wxID_NEW,
            Exit = wx.wxID_EXIT,
            Run = NewID(),
            Stop = NewID(),
            Console = NewID(),
            TextEditor = NewID(),
            ResourceTree = NewID()
        },
        Pane = {
            Console = nil,
            TextEditor = nil,
            ResourceTree = nil
        },
        PaneInfo = {
            Console = wxaui.wxAuiPaneInfo(),
            TextEditor = wxaui.wxAuiPaneInfo(),
            ResourceTree = wxaui.wxAuiPaneInfo()
        },
        RunningPID = 0
    }

    App.PaneInfo.Console:Name("Console")
    App.PaneInfo.Console:Caption("Output")
    App.PaneInfo.Console:Bottom()

    App.PaneInfo.TextEditor:Name("Text Editor")
    App.PaneInfo.TextEditor:Caption("Text Editor")
    App.PaneInfo.TextEditor:Center()

    App.PaneInfo.ResourceTree:Name("Resource Tree")
    App.PaneInfo.ResourceTree:Caption("Resource Tree")
    App.PaneInfo.ResourceTree:Right()

    function App:OutputLog(msg)
        self.Pane.Console:AppendText("\n"..msg)
    end

    function App:OnProgramStop()
        self:OutputLog("Program stopped successfully -- PID: " .. tostring(self.RunningPID))
    end

    function App:StopProgram()
        if (wx.wxProcess.Exists(self.RunningPID)) then 
            local killRet = wx.wxKill(self.RunningPID, wx.wxSIGKILL)
        else
            self:OutputLog("No Program Running")
        end
    end

    function App:RunProgram()
        if (wx.wxProcess.Exists(self.RunningPID)) then
            self:StopProgram()
        end
    
        self.RunningPID = wx.wxExecute("love", wx.wxEXEC_ASYNC, wx.wxProcess(self.Frame))
        if (self.RunningPID > 0) then
            self:OutputLog("Program started succesfully -- PID: " .. tostring(self.RunningPID))
        else
            self:OutputLog("Something went wrong. Make sure you have Love2D installed on your system and added to PATH")
        end
    end

    function App:Run()
        self.Frame = wx.wxFrame( wx.NULL, self.ID.MainFrame, "Love2D Editor", wx.wxDefaultPosition, wx.wxSize(640,480), wx.wxDEFAULT_FRAME_STYLE )
        
        self.Frame:SetMenuBar((function()
            local fileMenu = wx.wxMenu()
            fileMenu:Append(self.ID.New, "New", "Start a new project")
            fileMenu:Append(self.ID.Exit, "&Exit\tAlt+F4","Quit the program")

            local projectMenu = wx.wxMenu()
            projectMenu:Append(self.ID.Run, "Run","Run the program")
            projectMenu:Append(self.ID.Stop, "Stop","Stop the program")

            local menuBar = wx.wxMenuBar()
            menuBar:Append(fileMenu,"File")
            menuBar:Append(projectMenu,"Project")

            return menuBar
        end)())

        self.AuiManager = wxaui.wxAuiManager(self.Frame)

        self.Pane.TextEditor = wx.wxTextCtrl(self.Frame, self.ID.TextEditor, "", wx.wxDefaultPosition, wx.wxSize(640,480), bit32.bor(wx.wxNO_BORDER,wx.wxTE_MULTILINE))
        
        self.Pane.Console = wx.wxTextCtrl(self.Frame, self.ID.Console, "Love2D Editor <VERSION>", wx.wxDefaultPosition, wx.wxSize(640,480), bit32.bor(wx.wxNO_BORDER,wx.wxTE_MULTILINE))
        self.Pane.Console:SetEditable(false)

        self.Pane.ResourceTree = wx.wxGenericDirCtrl(self.Frame, self.ID.ResourceTree)

        self.AuiManager:AddPane(self.Pane.TextEditor, self.PaneInfo.TextEditor)
        self.AuiManager:AddPane(self.Pane.Console, self.PaneInfo.Console)
        self.AuiManager:AddPane(self.Pane.ResourceTree, self.PaneInfo.ResourceTree)

        self.AuiManager:Update()

        self.Frame:Connect(self.ID.Exit, wx.wxEVT_COMMAND_MENU_SELECTED, function(e) self:Shutdown() end)
        self.Frame:Connect(self.ID.Run, wx.wxEVT_COMMAND_MENU_SELECTED, function(e) self:RunProgram() end)
        self.Frame:Connect(self.ID.Stop, wx.wxEVT_COMMAND_MENU_SELECTED, function(e) self:StopProgram() end)
        self.Frame:Connect(wx.wxEVT_END_PROCESS, function(e) self:OnProgramStop() end)

        self.Frame:Show(true)
    end

    function App:Shutdown()
        self:OutputLog("Love2D Shutting down")
        self.Frame:Close(true)
    end

    return App
end

function main()
    EditorApp = NewApp()
    EditorApp:Run()
end

main()