local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestBannerSummon")

-- 🟢 ตัวแปรควบคุมระบบออโต้
getgenv().autoJujutsu = false
getgenv().autoSpecial = false

-- ==========================================
-- 🎨 สร้างหน้าต่าง UI เมนูกาชาแบบ Ultimate
-- ==========================================
if CoreGui:FindFirstChild("CustomSummonUI") then
    CoreGui.CustomSummonUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "CustomSummonUI"
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 290) -- ขยายความสูงเผื่อปุ่มออโต้
frame.Position = UDim2.new(0, 50, 0, 250)
frame.BackgroundColor3 = Color3.fromRGB(34, 47, 62)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "🎰 กาชา Ultimate V.2"
title.TextColor3 = Color3.fromRGB(0, 216, 214)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

-- ==========================================
-- 🔮 โซนตู้ Jujutsu
-- ==========================================
local inputJujutsu = Instance.new("TextBox")
inputJujutsu.Size = UDim2.new(1, -20, 0, 30)
inputJujutsu.Position = UDim2.new(0, 10, 0, 40)
inputJujutsu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
inputJujutsu.TextColor3 = Color3.fromRGB(0, 0, 0)
inputJujutsu.PlaceholderText = "ใส่จำนวน"
inputJujutsu.Text = "10"
inputJujutsu.Font = Enum.Font.GothamBold
inputJujutsu.TextSize = 12
Instance.new("UICorner", inputJujutsu).CornerRadius = UDim.new(0, 6)
inputJujutsu.Parent = frame

local btnJujutsu = Instance.new("TextButton")
btnJujutsu.Size = UDim2.new(0.5, -15, 0, 35)
btnJujutsu.Position = UDim2.new(0, 10, 0, 75)
btnJujutsu.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
btnJujutsu.TextColor3 = Color3.fromRGB(255, 255, 255)
btnJujutsu.Text = "🔮 สุ่ม 1 ที"
btnJujutsu.Font = Enum.Font.GothamBold
btnJujutsu.TextSize = 12
Instance.new("UICorner", btnJujutsu).CornerRadius = UDim.new(0, 6)
btnJujutsu.Parent = frame

local btnJujutsuInf = Instance.new("TextButton")
btnJujutsuInf.Size = UDim2.new(0.5, -15, 0, 35)
btnJujutsuInf.Position = UDim2.new(0.5, 5, 0, 75)
btnJujutsuInf.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
btnJujutsuInf.TextColor3 = Color3.fromRGB(255, 255, 255)
btnJujutsuInf.Text = "☠️ NaN"
btnJujutsuInf.Font = Enum.Font.GothamBold
btnJujutsuInf.TextSize = 12
Instance.new("UICorner", btnJujutsuInf).CornerRadius = UDim.new(0, 6)
btnJujutsuInf.Parent = frame

local btnJujutsuAuto = Instance.new("TextButton")
btnJujutsuAuto.Size = UDim2.new(1, -20, 0, 30)
btnJujutsuAuto.Position = UDim2.new(0, 10, 0, 115)
btnJujutsuAuto.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- สีเขียว
btnJujutsuAuto.TextColor3 = Color3.fromRGB(255, 255, 255)
btnJujutsuAuto.Text = "▶️ ออโต้ Jujutsu"
btnJujutsuAuto.Font = Enum.Font.GothamBold
btnJujutsuAuto.TextSize = 12
Instance.new("UICorner", btnJujutsuAuto).CornerRadius = UDim.new(0, 6)
btnJujutsuAuto.Parent = frame

-- ==========================================
-- 🌟 โซนตู้ Special
-- ==========================================
local inputSpecial = Instance.new("TextBox")
inputSpecial.Size = UDim2.new(1, -20, 0, 30)
inputSpecial.Position = UDim2.new(0, 10, 0, 160)
inputSpecial.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
inputSpecial.TextColor3 = Color3.fromRGB(0, 0, 0)
inputSpecial.PlaceholderText = "ใส่จำนวน"
inputSpecial.Text = "10"
inputSpecial.Font = Enum.Font.GothamBold
inputSpecial.TextSize = 12
Instance.new("UICorner", inputSpecial).CornerRadius = UDim.new(0, 6)
inputSpecial.Parent = frame

local btnSpecial = Instance.new("TextButton")
btnSpecial.Size = UDim2.new(0.5, -15, 0, 35)
btnSpecial.Position = UDim2.new(0, 10, 0, 195)
btnSpecial.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
btnSpecial.TextColor3 = Color3.fromRGB(45, 52, 54)
btnSpecial.Text = "🌟 สุ่ม 1 ที"
btnSpecial.Font = Enum.Font.GothamBold
btnSpecial.TextSize = 12
Instance.new("UICorner", btnSpecial).CornerRadius = UDim.new(0, 6)
btnSpecial.Parent = frame

local btnSpecialInf = Instance.new("TextButton")
btnSpecialInf.Size = UDim2.new(0.5, -15, 0, 35)
btnSpecialInf.Position = UDim2.new(0.5, 5, 0, 195)
btnSpecialInf.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
btnSpecialInf.TextColor3 = Color3.fromRGB(255, 255, 255)
btnSpecialInf.Text = "☠️ NaN"
btnSpecialInf.Font = Enum.Font.GothamBold
btnSpecialInf.TextSize = 12
Instance.new("UICorner", btnSpecialInf).CornerRadius = UDim.new(0, 6)
btnSpecialInf.Parent = frame

local btnSpecialAuto = Instance.new("TextButton")
btnSpecialAuto.Size = UDim2.new(1, -20, 0, 30)
btnSpecialAuto.Position = UDim2.new(0, 10, 0, 235)
btnSpecialAuto.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- สีเขียว
btnSpecialAuto.TextColor3 = Color3.fromRGB(255, 255, 255)
btnSpecialAuto.Text = "▶️ ออโต้ Special"
btnSpecialAuto.Font = Enum.Font.GothamBold
btnSpecialAuto.TextSize = 12
Instance.new("UICorner", btnSpecialAuto).CornerRadius = UDim.new(0, 6)
btnSpecialAuto.Parent = frame

-- ==========================================
-- ⚙️ ฟังก์ชันยิงคำสั่งปกติ
-- ==========================================
local function summonOnce(bannerName, amount)
    task.spawn(function()
        local args = { bannerName, amount }
        pcall(function() remote:InvokeServer(unpack(args)) end)
    end)
end

btnJujutsu.MouseButton1Click:Connect(function() summonOnce("Jujutsu", tonumber(inputJujutsu.Text) or 1) end)
btnJujutsuInf.MouseButton1Click:Connect(function() summonOnce("Jujutsu", 0/0) end)
btnSpecial.MouseButton1Click:Connect(function() summonOnce("Special", tonumber(inputSpecial.Text) or 1) end)
btnSpecialInf.MouseButton1Click:Connect(function() summonOnce("Special", 0/0) end)

-- ==========================================
-- 🚀 ระบบปุ่มออโต้สุ่ม (วนลูป)
-- ==========================================
btnJujutsuAuto.MouseButton1Click:Connect(function()
    getgenv().autoJujutsu = not getgenv().autoJujutsu
    if getgenv().autoJujutsu then
        btnJujutsuAuto.Text = "🛑 หยุดออโต้ Jujutsu"
        btnJujutsuAuto.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        
        task.spawn(function()
            while getgenv().autoJujutsu do
                local amount = tonumber(inputJujutsu.Text) or 1
                local args = { "Jujutsu", amount }
                pcall(function() remote:InvokeServer(unpack(args)) end)
                task.wait(0.2) -- ⚠️ หน่วงเวลา 0.2 วิกันเกมหลุด
            end
        end)
    else
        btnJujutsuAuto.Text = "▶️ ออโต้ Jujutsu"
        btnJujutsuAuto.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    end
end)

btnSpecialAuto.MouseButton1Click:Connect(function()
    getgenv().autoSpecial = not getgenv().autoSpecial
    if getgenv().autoSpecial then
        btnSpecialAuto.Text = "🛑 หยุดออโต้ Special"
        btnSpecialAuto.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        
        task.spawn(function()
            while getgenv().autoSpecial do
                local amount = tonumber(inputSpecial.Text) or 1
                local args = { "Special", amount }
                pcall(function() remote:InvokeServer(unpack(args)) end)
                task.wait(0.2) -- ⚠️ หน่วงเวลา 0.2 วิกันเกมหลุด
            end
        end)
    else
        btnSpecialAuto.Text = "▶️ ออโต้ Special"
        btnSpecialAuto.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    end
end)

print("🎯 โหลดเมนูกาชา Ultimate สำเร็จ!")
