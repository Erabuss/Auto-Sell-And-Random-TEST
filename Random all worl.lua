local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Summoners"):WaitForChild("RemoteEvent")

-- 📝 รายชื่อด่านทั้งหมด (เพิ่มชื่อด่านใหม่ๆ ในนี้ได้เลย)
local bannerList = {
    "Reaper Society",
    "Demon Forest",
    "Colosseum Kingdom",
    "Namex Planet"
}

local selectedBanner = bannerList[1] -- ค่าเริ่มต้น (ตัวแรก)
getgenv().autoSummonBanner = false

-- ==========================================
-- 🎨 สร้างหน้าต่าง UI
-- ==========================================
if CoreGui:FindFirstChild("SelectSummonUI") then
    CoreGui.SelectSummonUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "SelectSummonUI"
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

-- กรอบหลัก
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 130)
frame.Position = UDim2.new(0, 20, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(34, 47, 62)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
frame.Parent = gui

-- หัวข้อ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🎰 เลือกด่านสุ่มกาชา"
title.TextColor3 = Color3.fromRGB(241, 196, 15)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

-- 🔽 ปุ่มเปิด/ปิด Dropdown
local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(1, -20, 0, 30)
dropdownBtn.Position = UDim2.new(0, 10, 0, 40)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownBtn.Text = selectedBanner .. " ▼"
dropdownBtn.Font = Enum.Font.GothamBold
dropdownBtn.TextSize = 12
Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 6)
dropdownBtn.Parent = frame

-- 🚀 ปุ่มเปิด/ปิด ออโต้สุ่ม
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -20, 0, 35)
toggleBtn.Position = UDim2.new(0, 10, 0, 80)
toggleBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "🛑 ปิดออโต้สุ่ม"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)
toggleBtn.Parent = frame

-- 📜 กล่องรายการ Dropdown (ซ่อนไว้ตอนแรก)
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, -20, 0, 100)
listFrame.Position = UDim2.new(0, 10, 0, 75)
listFrame.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
listFrame.ZIndex = 10 -- ให้อยู่ด้านหน้าสุด
listFrame.Visible = false
listFrame.ScrollBarThickness = 4
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)
local listLayout = Instance.new("UIListLayout", listFrame)
listFrame.Parent = frame

-- สร้างตัวเลือกใน Dropdown
for _, banner in ipairs(bannerList) do
    local optionBtn = Instance.new("TextButton")
    optionBtn.Size = UDim2.new(1, 0, 0, 25)
    optionBtn.BackgroundTransparency = 1
    optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    optionBtn.Text = banner
    optionBtn.Font = Enum.Font.Gotham
    optionBtn.TextSize = 12
    optionBtn.ZIndex = 11
    optionBtn.Parent = listFrame
    
    -- เมื่อกดเลือกด่าน
    optionBtn.MouseButton1Click:Connect(function()
        selectedBanner = banner
        dropdownBtn.Text = selectedBanner .. " ▼"
        listFrame.Visible = false -- ซ่อนเมนู
    end)
end
listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)

-- สลับการซ่อน/โชว์ Dropdown
dropdownBtn.MouseButton1Click:Connect(function()
    listFrame.Visible = not listFrame.Visible
end)

-- ==========================================
-- ⚙️ ระบบทำงาน (เปิด/ปิด)
-- ==========================================
toggleBtn.MouseButton1Click:Connect(function()
    getgenv().autoSummonBanner = not getgenv().autoSummonBanner
    
    if getgenv().autoSummonBanner then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        toggleBtn.Text = "✅ กำลังสุ่ม: " .. selectedBanner
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        toggleBtn.Text = "🛑 ปิดออโต้สุ่ม"
    end
end)

-- ลูปสุ่มกาชา
task.spawn(function()
    while task.wait(0.2) do -- ดีเลย์กันหลุด
        if getgenv().autoSummonBanner then
            pcall(function()
                local args = { selectedBanner, "Multi" }
                remote:FireServer(unpack(args))
            end)
        end
    end
end)
