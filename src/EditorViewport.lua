local wxWidget = require("src.wxWidget")
local common = require("lib.common")

--local EditorViewportItem = class("EditorViewportItem")
local function EditorViewportItem(type,params)
   return { type = type, params = params }
end


local EditorViewport = wxWidget:extend("EditorViewport", {
    ItemType = {
        Circle = 1,
        Line = 2,
        Polygon = 3
    }
})

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

    self.widget:Connect(wx.wxEVT_MIDDLE_DOWN, function(e) self:OnMiddleDown() end)

    self.widget:Connect(wx.wxEVT_MIDDLE_UP, function(e) self:OnMiddleUp() end)

    self.widget:Connect(wx.wxEVT_MOTION, function(e) self:OnMotion() end)

    self.widget:Connect(wx.wxEVT_PAINT, function(e) self:OnPaint() end)
end

function EditorViewport:AddItem(name,type,params)
    local item = EditorViewportItem(type,params)
    self.items[name] = item
end

function EditorViewport:RemoveItem(name)
    self.items[name] = nil
end

function EditorViewport:HasItem(name)
    return self.items[name] ~= nil
end

function EditorViewport:OnMiddleDown()
    local mx,my = self.widget:ScreenToClient(wx.wxGetMousePosition()):GetXY()
    self.mouseGrabX = mx+self.scrollX
    self.mouseGrabY = my+self.scrollY
    self.scrolling = true
    self.widget:CaptureMouse()
end

function EditorViewport:OnMiddleUp()
    if (self.scrolling) then
        self.scrolling = false
        self.widget:ReleaseMouse()
    end
end

function EditorViewport:OnMotion()
    if (self.scrolling) then
        local mx,my = self.widget:ScreenToClient(wx.wxGetMousePosition()):GetXY()
        local size = self.widget:GetClientSize()
        local ww = size:GetWidth()
        local wh = size:GetHeight()
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
    local dc = wx.wxAutoBufferedPaintDC(self.widget)
    local size = self.widget:GetClientSize()
    local ww = size:GetWidth()
    local wh = size:GetHeight()
    dc:Clear()

    dc:SetBrush(wx.wxTRANSPARENT_BRUSH)

    --local mx,my = self.widget:ScreenToClient(wx.wxGetMousePosition()):GetXY()
    --dc:DrawText(tostring(mx - self.scrollX) .. "," .. tostring(my - self.scrollY),1,1)

    for _,item in pairs(self.items) do
        local type = item.type
        if (type == EditorViewport.ItemType.Circle) then
            dc:DrawCircle(item.params.x - self.scrollX, item.params.y - self.scrollY, item.params.radius)
        elseif (type == EditorViewport.ItemType.Line) then
            dc:DrawLine(item.params.x1 - self.scrollX, item.params.y1 - self.scrollY, item.params.x2 - self.scrollX, item.params.y2 - self.scrollY)
        else -- if polygon
            local points = {}
            for i,point in ipairs(item.params.points) do
                points[i] = {point[1] - self.scrollX, point[2] - self.scrollY}
            end
            dc:DrawPolygon(points)
        end
    end

    -- for i=1,20 do
    --     for j=1,20 do
    --         local r = 20
    --         local p = 5
    --         local x = i * (r * 2) - self.scrollX
    --         local y = j * (r * 2) - self.scrollY
    --         if (x >= 0 and y >= 0 and ww >= x and wh >= y) then
    --             dc:DrawCircle(x,y,r)
    --         end
    --     end
    -- end

    dc:delete()
end


return EditorViewport