local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")
local CoreGui = game:GetService("CoreGui")
local ByteNet = ReplicatedStorage:WaitForChild("ByteNetReliable")

-- ==========================================
-- ⚙️ 1. ตั้งค่าระบบ Auto-Sell
-- ==========================================
getgenv().autoSellEnabled = false

local autoSellList = {
    ["Astofolo"] = true,
    ["Aqua"] = true,
    ["ZeroTwo"] = true,
    ["Miku"] = true
}

local function AutoSellBatch()
    local unitsGUI = PlayerGui:FindFirstChild("Units")
    if not unitsGUI then return end
    
    local success, interviewFolder = pcall(function()
        return unitsGUI._Frame.Usage.BODY.Useable.Interview
    end)
    if not success or not interviewFolder then return end

    local itemsToSell = {}
    for _, item in pairs(interviewFolder:GetChildren()) do
        if item:IsA("GuiObject") then
            local fullUnitName = item:GetAttribute("UnitName")
            if fullUnitName and type(fullUnitName) == "string" and string.find(fullUnitName, " %- ") then
                local baseName = string.split(fullUnitName, " - ")[1]
                if autoSellList[baseName] then
                    table.insert(itemsToSell, fullUnitName)
                end
            end
        end
    end

    local count = #itemsToSell
    if count == 0 then return end

    print("🔍 เจอตัวละครขยะ " .. count .. " ตัว! เตรียมขาย...")
    local batchSize = 50
    for i = 1, count, batchSize do
        if not getgenv().autoSellEnabled then break end 
        
        local batchCount = math.min(batchSize, count - i + 1)
        local payload = string.char(28, batchCount % 256, math.floor(batchCount / 256))

        for j = i, i + batchCount - 1 do
            local itemName = itemsToSell[j]
            local len = #itemName
            payload = payload .. string.char(len % 256, math.floor(len / 256)) .. itemName
        end

        ByteNet:FireServer(buffer.fromstring(payload))
        print("✅ ขายเรียบร้อย " .. batchCount .. " ตัว!")
        task.wait(0.2)
    end
end

task.spawn(function()
    while task.wait(5) do
        if getgenv().autoSellEnabled then pcall(AutoSellBatch) end
    end
end)

-- ==========================================
-- 🎨 2. สร้างหน้าต่าง UI ควบคุมรวม (Hub)
-- ==========================================
if CoreGui:FindFirstChild("AIO_Hub_UI") then CoreGui.AIO_Hub_UI:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AIO_Hub_UI"
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = localPlayer:WaitForChild("PlayerGui") end

-- กรอบหลัก
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0, 20, 0, 300)
frame.BackgroundColor3 = Color3.fromRGB(34, 47, 62)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
frame.Parent = gui

-- หัวข้อ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🛠️ Auto-Farm Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

-- 🟢 ปุ่ม Auto-Sell
local toggleSellBtn = Instance.new("TextButton")
toggleSellBtn.Size = UDim2.new(1, -20, 0, 35)
toggleSellBtn.Position = UDim2.new(0, 10, 0, 35)
toggleSellBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
toggleSellBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleSellBtn.Text = "🛑 Auto-Sell: ปิด"
toggleSellBtn.Font = Enum.Font.GothamBold
toggleSellBtn.TextSize = 13
Instance.new("UICorner", toggleSellBtn).CornerRadius = UDim.new(0, 6)
toggleSellBtn.Parent = frame

-- 🔢 ช่องใส่จำนวนสุ่ม
local amountInput = Instance.new("TextBox")
amountInput.Size = UDim2.new(0, 100, 0, 35)
amountInput.Position = UDim2.new(0, 10, 0, 80)
amountInput.BackgroundColor3 = Color3.fromRGB(200, 214, 229)
amountInput.TextColor3 = Color3.fromRGB(0, 0, 0)
amountInput.PlaceholderText = "จำนวนครั้ง (x10)"
amountInput.Font = Enum.Font.GothamBold
amountInput.TextSize = 12
Instance.new("UICorner", amountInput).CornerRadius = UDim.new(0, 6)
amountInput.Parent = frame

-- 🎰 ปุ่มเริ่มสุ่ม
local rollBtn = Instance.new("TextButton")
rollBtn.Size = UDim2.new(0, 90, 0, 35)
rollBtn.Position = UDim2.new(0, 120, 0, 80)
rollBtn.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
rollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rollBtn.Text = "สุ่มกาชา!"
rollBtn.Font = Enum.Font.GothamBold
rollBtn.TextSize = 13
Instance.new("UICorner", rollBtn).CornerRadius = UDim.new(0, 6)
rollBtn.Parent = frame

-- ข้อความสถานะ
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 120)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "รอคำสั่ง..."
statusLabel.TextColor3 = Color3.fromRGB(189, 195, 199)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = frame

-- ==========================================
-- ⚙️ 3. ระบบคลิกปุ่มต่างๆ
-- ==========================================
-- ระบบ Auto-Sell
toggleSellBtn.MouseButton1Click:Connect(function()
    getgenv().autoSellEnabled = not getgenv().autoSellEnabled
    if getgenv().autoSellEnabled then
        toggleSellBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        toggleSellBtn.Text = "✅ Auto-Sell: เปิด"
    else
        toggleSellBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        toggleSellBtn.Text = "🛑 Auto-Sell: ปิด"
    end
end)

-- ระบบสุ่มกาชา
local isRolling = false
rollBtn.MouseButton1Click:Connect(function()
    if isRolling then
        isRolling = false
        rollBtn.Text = "สุ่มกาชา!"
        rollBtn.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
        statusLabel.Text = "🛑 ยกเลิกการสุ่มแล้ว!"
        return
    end

    local rollCount = tonumber(amountInput.Text)
    if not rollCount or rollCount <= 0 then
        statusLabel.Text = "❌ โปรดใส่ตัวเลขรอบที่ต้องการ!"
        return
    end

    isRolling = true
    rollBtn.Text = "🛑 หยุด!"
    rollBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    
    local args = { "Dress up my waifu (x1)", 10 }
    local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Systems"):WaitForChild("Purchased")

    task.spawn(function()
        for i = 1, rollCount do
            if not isRolling then break end
            
            pcall(function()
                remote:FireServer(unpack(args))
            end)
            
            statusLabel.Text = "🎰 กำลังสุ่มรอบที่: " .. i .. " / " .. rollCount
            task.wait(0.2) -- หน่วงเวลา 0.2 วิ เพื่อความปลอดภัย
        end
        
        if isRolling then
            isRolling = false
            rollBtn.Text = "สุ่มกาชา!"
            rollBtn.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
            statusLabel.Text = "✅ สุ่มครบ " .. rollCount .. " ครั้งแล้ว!"
        end
    end)
end)

print("✅ Hub พร้อมใช้งาน! เปิด/ปิด Auto-Sell และสุ่มได้ในหน้าต่างเดียว!")
