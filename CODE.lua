local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Misc"):WaitForChild("CodesEvent")

-- 📝 รายชื่อโค้ดทั้งหมด (เพิ่ม/ลบ ในนี้ได้เลย)
local codeList = {
    "FIXFIXFIX",
    "UPDATE1BUGS",
    "SORRYFORDELAY2",
    "ATSSOCIETY",
    "SORRYFORDELAY1"
}

local selectedCode = codeList[1] -- ค่าเริ่มต้น (ตัวแรก)

-- ==========================================
-- 🎨 สร้างหน้าต่าง UI
-- ==========================================
if CoreGui:FindFirstChild("CodeDropdownUI") then
    CoreGui.CodeDropdownUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "CodeDropdownUI"
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

-- กรอบหลัก
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(34, 47, 62)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🎁 เครื่องยิงโค้ด (Drop-down)"
title.TextColor3 = Color3.fromRGB(241, 196, 15)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

-- 🔽 ปุ่มเปิด/ปิด Dropdown
local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(1, -20, 0, 30)
dropdownBtn.Position = UDim2.new(0, 10, 0, 35)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownBtn.Text = selectedCode .. " ▼"
dropdownBtn.Font = Enum.Font.GothamBold
dropdownBtn.TextSize = 12
Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 6)
dropdownBtn.Parent = frame

-- 🔢 ช่องใส่จำนวนสแปม
local amountInput = Instance.new("TextBox")
amountInput.Size = UDim2.new(1, -20, 0, 30)
amountInput.Position = UDim2.new(0, 10, 0, 75)
amountInput.BackgroundColor3 = Color3.fromRGB(200, 214, 229)
amountInput.TextColor3 = Color3.fromRGB(0, 0, 0)
amountInput.Text = "2500" -- จำนวนเริ่มต้น
amountInput.PlaceholderText = "จำนวนที่ต้องการยิง"
amountInput.Font = Enum.Font.GothamBold
amountInput.TextSize = 12
Instance.new("UICorner", amountInput).CornerRadius = UDim.new(0, 6)
amountInput.Parent = frame

-- 🚀 ปุ่มเริ่มยิง
local fireBtn = Instance.new("TextButton")
fireBtn.Size = UDim2.new(1, -20, 0, 35)
fireBtn.Position = UDim2.new(0, 10, 0, 115)
fireBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
fireBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fireBtn.Text = "เริ่มสแปมโค้ด!"
fireBtn.Font = Enum.Font.GothamBold
fireBtn.TextSize = 14
Instance.new("UICorner", fireBtn).CornerRadius = UDim.new(0, 6)
fireBtn.Parent = frame

-- 📜 กล่องรายการ Dropdown (ซ่อนไว้ตอนแรก)
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, -20, 0, 100)
listFrame.Position = UDim2.new(0, 10, 0, 70)
listFrame.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
listFrame.ZIndex = 10 -- ให้อยู่ด้านหน้าสุดบังปุ่มอื่นๆ
listFrame.Visible = false
listFrame.ScrollBarThickness = 4
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)
local listLayout = Instance.new("UIListLayout", listFrame)
listFrame.Parent = frame

-- สร้างปุ่มตัวเลือกใน Dropdown
for _, code in ipairs(codeList) do
    local optionBtn = Instance.new("TextButton")
    optionBtn.Size = UDim2.new(1, 0, 0, 25)
    optionBtn.BackgroundTransparency = 1
    optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    optionBtn.Text = code
    optionBtn.Font = Enum.Font.Gotham
    optionBtn.TextSize = 12
    optionBtn.ZIndex = 11
    optionBtn.Parent = listFrame
    
    -- เมื่อกดเลือกโค้ด
    optionBtn.MouseButton1Click:Connect(function()
        selectedCode = code
        dropdownBtn.Text = selectedCode .. " ▼"
        listFrame.Visible = false -- ซ่อนเมนูหลังเลือกเสร็จ
    end)
end
listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)

-- สลับการซ่อน/โชว์ Dropdown
dropdownBtn.MouseButton1Click:Connect(function()
    listFrame.Visible = not listFrame.Visible
end)

-- ==========================================
-- ⚙️ ระบบสแปมโค้ด
-- ==========================================
local isSpamming = false

fireBtn.MouseButton1Click:Connect(function()
    if isSpamming then
        isSpamming = false
        fireBtn.Text = "เริ่มสแปมโค้ด!"
        fireBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        return
    end

    local amount = tonumber(amountInput.Text)
    if not amount or amount <= 0 then
        fireBtn.Text = "❌ ใส่ตัวเลขให้ถูก!"
        task.delay(1, function() fireBtn.Text = "เริ่มสแปมโค้ด!" end)
        return
    end

    isSpamming = true
    fireBtn.Text = "🛑 หยุดสแปม!"
    fireBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)

    task.spawn(function()
        print("🚀 เริ่มสแปมโค้ด: " .. selectedCode .. " จำนวน " .. amount .. " ครั้ง!")
        for i = 1, amount do
            if not isSpamming then break end
            
            pcall(function()
                event:FireServer(selectedCode)
            end)
            
            -- 🛡️ ระบบกันจอค้าง: พัก 1 เฟรม ทุกๆ 500 ครั้ง (สำคัญมาก!)
            if i % 500 == 0 then task.wait() end 
        end
        
        if isSpamming then
            isSpamming = false
            fireBtn.Text = "เริ่มสแปมโค้ด!"
            fireBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            print("✅ ยิงโค้ดเสร็จสิ้น!")
        end
    end)
end)

print("✅ UI Drop-down พร้อมใช้งาน!")
