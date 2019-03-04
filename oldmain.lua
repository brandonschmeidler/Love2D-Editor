-----------------------------------------------------------------------------
-- Name:       Love2D Editor
-- Purpose:    WSYIWYG Editor for Love2D
-- Author:     Brandon Schmeidler
-- Created:    2/28/2019
-- RCS-ID:     I don't know what this is
-- Copyright:  (c) 2019 Brandon Schmeidler. All rights reserved. I guess.
-- License:    wxWidgets license
-----------------------------------------------------------------------------

-- This file is only for reference while I refactor all this shit

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
            -- File menu
            New = wx.wxID_NEW,
            Exit = wx.wxID_EXIT,

            -- Project Menu
            Run = NewID(),
            Stop = NewID(),

            -- View Menu
            ToggleConsole = NewID(),
            ToggleResourceTree = NewID(),

            -- AUI Managed Widgets
            Console = NewID(),
            EditorNotebook = NewID(),
            ResourceTree = NewID()
        },
        Pane = {
            Console = nil,
            EditorNotebook = nil,
            ResourceTree = nil
        },
        RunningPID = 0
    }

    function App:OutputLog(msg)
        self.Pane.Console:AppendText("\n"..tostring(msg))
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
        -- If we're already running a Love2D game process then shut it down
        if (wx.wxProcess.Exists(self.RunningPID)) then
            self:StopProgram()
        end
    
        -- Startup Love2D or print out an error because Love2D isn't installed on the system
        self.RunningPID = wx.wxExecute("love", wx.wxEXEC_ASYNC, wx.wxProcess(self.Frame))
        if (self.RunningPID > 0) then
            self:OutputLog("Program started succesfully -- PID: " .. tostring(self.RunningPID))
        else
            self:OutputLog("Something went wrong. Make sure you have Love2D installed on your system and added to PATH")
        end
    end

    function App:ToggleAuiPane(name)
        local pane = self.AuiManager:GetPane(name)
        if (pane:IsOk()) then
            pane:Show(not pane:IsShown())
            self.AuiManager:Update()
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

            local viewMenu = wx.wxMenu()
            viewMenu:Append(self.ID.ToggleConsole, "Console", "Toggle the console output window")
            viewMenu:Append(self.ID.ToggleResourceTree, "Resource Tree", "Toggle the resource tree window")

            local menuBar = wx.wxMenuBar()
            menuBar:Append(fileMenu,"File")
            menuBar:Append(projectMenu,"Project")
            menuBar:Append(viewMenu,"View")

            return menuBar
        end)())

        self.AuiManager = wxaui.wxAuiManager(self.Frame)

        -- This will be the center of the IDE where all editors will be managed
        self.Pane.EditorNotebook = wxaui.wxAuiNotebook(self.Frame, self.ID.EditorNotebook)
        -- local testPage1 = wxstc.wxStyledTextCtrl(self.Frame,NewID())
        -- self.Pane.EditorNotebook:AddPage(testPage1,"unnamed",true)
        
        self.Pane.Console = wx.wxTextCtrl(self.Frame, self.ID.Console, "Love2D Editor <VERSION>", wx.wxDefaultPosition, wx.wxDefaultSize, bit32.bor(wx.wxNO_BORDER,wx.wxTE_MULTILINE))
        self.Pane.Console:SetEditable(false)

        -- This makes a full blown system file explorer so keep that in mind 
        -- But for projects I need a local project directory
        --self.Pane.ResourceTree = wx.wxGenericDirCtrl(self.Frame, self.ID.ResourceTree)
        self.Pane.ResourceTree = wx.wxTreeCtrl(self.Frame, self.ID.ResourceTree)
        self:OutputLog(wx.wxStandardPaths.Get():GetDocumentsDir())

        -- Setup initial PaneInfo for each Aui Pane and pass it to manager
        local paneInfo = {
            Console = wxaui.wxAuiPaneInfo(),
            EditorNotebook = wxaui.wxAuiPaneInfo(),
            ResourceTree = wxaui.wxAuiPaneInfo()
        }
        paneInfo.Console:Name("Console")
        paneInfo.Console:Caption("Output")
        paneInfo.Console:Bottom()
        paneInfo.Console:FloatingSize(640,200)

        paneInfo.EditorNotebook:Name("EditorNotebook")
        paneInfo.EditorNotebook:CaptionVisible(false)
        paneInfo.EditorNotebook:Center()

        paneInfo.ResourceTree:Name("Resource Tree")
        paneInfo.ResourceTree:Caption("Resource Tree")
        paneInfo.ResourceTree:Right()
        paneInfo.ResourceTree:FloatingSize(200,500)

        self.AuiManager:AddPane(self.Pane.EditorNotebook, paneInfo.EditorNotebook)
        self.AuiManager:AddPane(self.Pane.Console, paneInfo.Console)
        self.AuiManager:AddPane(self.Pane.ResourceTree, paneInfo.ResourceTree)

        self.AuiManager:Update()

        self.Frame:Connect(self.ID.Exit, wx.wxEVT_COMMAND_MENU_SELECTED, function(e) self:Shutdown() end)
        self.Frame:Connect(self.ID.Run, wx.wxEVT_COMMAND_MENU_SELECTED, function(e) self:RunProgram() end)
        self.Frame:Connect(self.ID.Stop, wx.wxEVT_COMMAND_MENU_SELECTED, function(e) self:StopProgram() end)
        self.Frame:Connect(self.ID.ToggleConsole, wx.wxEVT_COMMAND_MENU_SELECTED, function(e) self:ToggleAuiPane("Console") end)
        self.Frame:Connect(self.ID.ToggleResourceTree, wx.wxEVT_COMMAND_MENU_SELECTED, function(e) self:ToggleAuiPane("Resource Tree") end)
        self.Frame:Connect(wx.wxEVT_END_PROCESS, function(e) self:OnProgramStop() end)

        self.Frame:Show(true)
    end

    function App:Shutdown()
        self:OutputLog("Love2D Editor Shutting down")
        self.Frame:Close(true)
    end

    return App
end

function main()
    EditorApp = NewApp()
    EditorApp:Run()
end

main()