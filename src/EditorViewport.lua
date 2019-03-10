local wxWidget = require("src.wxWidget")
local common = require("lib.common")

local EditorViewport = wxWidget:extend("EditorViewport")

local function bool_to_axis(bool)
    if (bool) then return 1 end
    return -1
end

function EditorViewport:init(frame,id)
    self.widget = wx.wxPanel(frame,id)
    self.scrolling = false
    self.scrollX = 0
    self.scrollY = 0

    self.mouseGrabX = 0
    self.mouseGrabY = 0

    self.items = {}


    self.widget:Connect(wx.wxEVT_MIDDLE_DOWN, function(e) print(self.scrollX,self.scrollY) self:OnMiddleDown() end)

    self.widget:Connect(wx.wxEVT_MIDDLE_UP, function(e) self:OnMiddleUp() end)

    self.widget:Connect(wx.wxEVT_MOTION, function(e) self:OnMotion() end)

    self.widget:Connect(wx.wxEVT_PAINT, function(e) self:OnPaint() end)
end

function EditorViewport:OnMiddleDown()
    local mx,my = self.widget:ScreenToClient(wx.wxGetMousePosition()):GetXY()
    self.mouseGrabX = mx+self.scrollX
    self.mouseGrabY = my+self.scrollY

    print("MOUSE DOWN",self.mouseGrabX,self.mouseGrabY)
    self.scrolling = true
    self.widget:CaptureMouse()
end

function EditorViewport:OnMiddleUp()
    if (self.scrolling) then
        self.scrolling = false
        self.widget:ReleaseMouse()
    end
end

-- function EditorViewport:OnLeaveWindow()
--     if (self.scrolling) then
--         --self.scrolling = false
--         local mx,my = self.widget:ScreenToClient(wx.wxGetMousePosition()):GetXY()
--         local size = self.widget:GetClientSize()
--         local ww = size:GetWidth()
--         local wh = size:GetHeight()
--         print(mx,my,ww,wh)
--         if (mx < 0 or mx > ww) then
--             local axis = bool_to_axis(mx < 0)
--             local offset = axis * ww
--             mx = mx + offset
--             self.mouseGrabX = self.mouseGrabX + offset
--             self.widget:WarpPointer(mx,my)
--         end

--         if (my < 0 or my > wh) then
--             local axis = bool_to_axis(my < 0)
--             local offset = axis * wh
--             my = my + offset
--             self.mouseGrabY = self.mouseGrabY + offset
--             self.widget:WarpPointer(mx,my)
--         end
--     end
-- end

function EditorViewport:OnMotion()
    if (self.scrolling) then
        local mx,my = self.widget:ScreenToClient(wx.wxGetMousePosition()):GetXY()
        local size = self.widget:GetClientSize()
        local ww = size:GetWidth()
        local wh = size:GetHeight()
        print(mx,my,ww,wh)
        if (mx < 0 or mx > ww) then
            local axis = bool_to_axis(mx < 0)
            local offset = axis * ww
            mx = mx + offset
            self.mouseGrabX = self.mouseGrabX + offset
            self.widget:WarpPointer(mx,my)
        end

        if (my < 0 or my > wh) then
            local axis = bool_to_axis(my < 0)
            local offset = axis * wh
            my = my + offset
            self.mouseGrabY = self.mouseGrabY + offset
            self.widget:WarpPointer(mx,my)
        end
        self.scrollX = self.mouseGrabX - mx
        self.scrollY = self.mouseGrabY - my
        self.widget:Refresh()
    end
end

function EditorViewport:OnPaint()
    local dc = wx.wxBufferedPaintDC(self.widget)
    local size = self.widget:GetClientSize()
    local ww = size:GetWidth()
    local wh = size:GetHeight()
    dc:Clear()

    for i=1,20 do
        for j=1,20 do
            local r = 20
            local p = 5
            local x = i * (r * 2) - self.scrollX
            local y = j * (r * 2) - self.scrollY
            if (x >= 0 and y >= 0 and ww >= x and wh >= y) then
                dc:DrawCircle(x,y,r)
            end
        end
    end

    dc:delete()
end


return EditorViewport