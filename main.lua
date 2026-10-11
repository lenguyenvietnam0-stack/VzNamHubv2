-- Khởi tạo UI Service
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Xóa GUI cũ nếu đang chạy
if CoreGui:FindFirstChild("VzNamHubGui") then
    CoreGui.VzNamHubGui:Destroy()
end

-- Biến lưu trữ nút script vừa bấm gần nhất
local LastSelectedScriptBtn = nil
local LastSelectedScriptStroke = nil

-- Tạo ScreenGui chính
local VzNamGui = Instance.new("ScreenGui")
VzNamGui.Name = "VzNamHubGui"
VzNamGui.Parent = CoreGui
VzNamGui.ResetOnSpawn = false

-- Lấy link ảnh Avatar nhân vật của bạn
local avatarUrl = "rbxassetid://6031094678"
pcall(function()
    avatarUrl = Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)

-- 1. NÚT TRÒN TOGGLE
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = VzNamGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Image = avatarUrl

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = ToggleBtn

-- 2. BẢNG MENU CHÍNH
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = VzNamGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -150)
MainFrame.Size = UDim2.new(0, 370, 0, 310)
MainFrame.ClipsDescendants = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

-- HIỆU ỨNG RAINBOW NỀN MENU
local RainbowGradient = Instance.new("UIGradient")
RainbowGradient.Parent = MainFrame
RainbowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 180, 180)),
    ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 220, 180)),
    ColorSequenceKeypoint.new(0.40, Color3.fromRGB(255, 255, 180)),
    ColorSequenceKeypoint.new(0.60, Color3.fromRGB(180, 255, 200)),
    ColorSequenceKeypoint.new(0.80, Color3.fromRGB(180, 220, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(220, 180, 255))
})

local tweenInfo = TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false)
local tween = TweenService:Create(RainbowGradient, tweenInfo, {Rotation = 360})
tween:Play()

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(255, 255, 255)
FrameStroke.Thickness = 2
FrameStroke.Parent = MainFrame

-- Tiêu đề Menu (Tay cầm kéo menu)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleBar.BackgroundTransparency = 0.6

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Xử lý kéo bảng menu (Draggable)
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Avatar trên tiêu đề
local HeaderAvatar = Instance.new("ImageLabel")
HeaderAvatar.Name = "HeaderAvatar"
HeaderAvatar.Parent = TitleBar
HeaderAvatar.Position = UDim2.new(0, 10, 0.5, -14)
HeaderAvatar.Size = UDim2.new(0, 28, 0, 28)
HeaderAvatar.BackgroundTransparency = 1
HeaderAvatar.Image = avatarUrl

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = HeaderAvatar

-- Tiêu đề bảng Hub
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.Position = UDim2.new(0, 45, 0, 0)
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "TỔNG HỢP SAE | 👑VzNam Hub v2👑|"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 13
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- 3. THANH TAB DỌC BÊN TRÁI
local TabBarLeft = Instance.new("Frame")
TabBarLeft.Name = "TabBarLeft"
TabBarLeft.Parent = MainFrame
TabBarLeft.Position = UDim2.new(0, 8, 0, 48)
TabBarLeft.Size = UDim2.new(0, 100, 1, -56)
TabBarLeft.BackgroundTransparency = 1

local LeftLayout = Instance.new("UIListLayout")
LeftLayout.Parent = TabBarLeft
LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
LeftLayout.Padding = UDim.new(0, 8)

-- Nút Main Tab 1
local MainTab1Btn = Instance.new("TextButton")
MainTab1Btn.Parent = TabBarLeft
MainTab1Btn.Size = UDim2.new(1, 0, 0, 38)
MainTab1Btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainTab1Btn.BackgroundTransparency = 0.3
MainTab1Btn.Text = "steal an egg"
MainTab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTab1Btn.Font = Enum.Font.SourceSansBold
MainTab1Btn.TextSize = 12
MainTab1Btn.TextWrapped = true

local Tab1Corner = Instance.new("UICorner")
Tab1Corner.CornerRadius = UDim.new(0, 8)
Tab1Corner.Parent = MainTab1Btn

local Tab1Stroke = Instance.new("UIStroke")
Tab1Stroke.Color = Color3.fromRGB(255, 50, 50) -- Đỏ khi active
Tab1Stroke.Thickness = 2
Tab1Stroke.Parent = MainTab1Btn

-- Nút Main Tab 2
local MainTab2Btn = Instance.new("TextButton")
MainTab2Btn.Parent = TabBarLeft
MainTab2Btn.Size = UDim2.new(1, 0, 0, 38)
MainTab2Btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainTab2Btn.BackgroundTransparency = 0.7
MainTab2Btn.Text = "bloxkid"
MainTab2Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
MainTab2Btn.Font = Enum.Font.SourceSansBold
MainTab2Btn.TextSize = 13

local Tab2Corner = Instance.new("UICorner")
Tab2Corner.CornerRadius = UDim.new(0, 8)
Tab2Corner.Parent = MainTab2Btn

local Tab2Stroke = Instance.new("UIStroke")
Tab2Stroke.Color = Color3.fromRGB(255, 255, 255)
Tab2Stroke.Thickness = 1
Tab2Stroke.Parent = MainTab2Btn

-- HÀM TẠO KHUNG CHỨA SUB-TABS (NO KEY / CÓ KEY)
local function CreateCategoryContainer(visible)
    local frame = Instance.new("Frame")
    frame.Parent = MainFrame
    frame.Position = UDim2.new(0, 114, 0, 48)
    frame.Size = UDim2.new(1, -122, 1, -56)
    frame.BackgroundTransparency = 1
    frame.Visible = visible
    
    local subBar = Instance.new("Frame")
    subBar.Parent = frame
    subBar.Size = UDim2.new(1, 0, 0, 28)
    subBar.BackgroundTransparency = 1
    
    local subLayout = Instance.new("UIListLayout")
    subLayout.Parent = subBar
    subLayout.FillDirection = Enum.FillDirection.Horizontal
    subLayout.SortOrder = Enum.SortOrder.LayoutOrder
    subLayout.Padding = UDim.new(0, 6)
    
    -- Nút No Key
    local noKeyBtn = Instance.new("TextButton")
    noKeyBtn.Parent = subBar
    noKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
    noKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    noKeyBtn.BackgroundTransparency = 0.3
    noKeyBtn.Text = "no key"
    noKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noKeyBtn.Font = Enum.Font.SourceSansBold
    noKeyBtn.TextSize = 12
    
    local nkCorner = Instance.new("UICorner")
    nkCorner.CornerRadius = UDim.new(0, 6)
    nkCorner.Parent = noKeyBtn

    local nkStroke = Instance.new("UIStroke")
    nkStroke.Color = Color3.fromRGB(255, 50, 50) -- Đỏ khi active
    nkStroke.Thickness = 2
    nkStroke.Parent = noKeyBtn
    
    -- Nút Có Key
    local hasKeyBtn = Instance.new("TextButton")
    hasKeyBtn.Parent = subBar
    hasKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
    hasKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    hasKeyBtn.BackgroundTransparency = 0.7
    hasKeyBtn.Text = "có key"
    hasKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    hasKeyBtn.Font = Enum.Font.SourceSansBold
    hasKeyBtn.TextSize = 12
    
    local hkCorner = Instance.new("UICorner")
    hkCorner.CornerRadius = UDim.new(0, 6)
    hkCorner.Parent = hasKeyBtn

    local hkStroke = Instance.new("UIStroke")
    hkStroke.Color = Color3.fromRGB(255, 255, 255)
    hkStroke.Thickness = 1
    hkStroke.Parent = hasKeyBtn
    
    -- Khung cuộn No Key
    local scrollNoKey = Instance.new("ScrollingFrame")
    scrollNoKey.Parent = frame
    scrollNoKey.Position = UDim2.new(0, 0, 0, 34)
    scrollNoKey.Size = UDim2.new(1, 0, 1, -34)
    scrollNoKey.BackgroundTransparency = 1
    scrollNoKey.CanvasSize = UDim2.new(0, 0, 0, 2000)
    scrollNoKey.ScrollBarThickness = 4
    scrollNoKey.Visible = true
    
    local l1 = Instance.new("UIListLayout")
    l1.Parent = scrollNoKey
    l1.SortOrder = Enum.SortOrder.LayoutOrder
    l1.Padding = UDim.new(0, 8)
    
    -- Khung cuộn Có Key
    local scrollHasKey = Instance.new("ScrollingFrame")
    scrollHasKey.Parent = frame
    scrollHasKey.Position = UDim2.new(0, 0, 0, 34)
    scrollHasKey.Size = UDim2.new(1, 0, 1, -34)
    scrollHasKey.BackgroundTransparency = 1
    scrollHasKey.CanvasSize = UDim2.new(0, 0, 0, 2000)
    scrollHasKey.ScrollBarThickness = 4
    scrollHasKey.Visible = false
    
    local l2 = Instance.new("UIListLayout")
    l2.Parent = scrollHasKey
    l2.SortOrder = Enum.SortOrder.LayoutOrder
    l2.Padding = UDim.new(0, 8)
    
    -- Chuyển đổi Sub-tab
    noKeyBtn.MouseButton1Click:Connect(function()
        scrollNoKey.Visible = true
        scrollHasKey.Visible = false
        noKeyBtn.BackgroundTransparency = 0.3
        noKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        nkStroke.Color = Color3.fromRGB(255, 50, 50)
        nkStroke.Thickness = 2
        
        hasKeyBtn.BackgroundTransparency = 0.7
        hasKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        hkStroke.Color = Color3.fromRGB(255, 255, 255)
        hkStroke.Thickness = 1
    end)
    
    hasKeyBtn.MouseButton1Click:Connect(function()
        scrollNoKey.Visible = false
        scrollHasKey.Visible = true
        hasKeyBtn.BackgroundTransparency = 0.3
        hasKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        hkStroke.Color = Color3.fromRGB(255, 50, 50)
        hkStroke.Thickness = 2
        
        noKeyBtn.BackgroundTransparency = 0.7
        noKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        nkStroke.Color = Color3.fromRGB(255, 255, 255)
        nkStroke.Thickness = 1
    end)
    
    return frame, scrollNoKey, scrollHasKey
end

-- Tạo 2 danh mục chính
local StealContainer, StealNoKeyScroll, StealHasKeyScroll = CreateCategoryContainer(true)
local BloxContainer, BloxNoKeyScroll, BloxHasKeyScroll = CreateCategoryContainer(false)

-- Chuyển đổi Main Tab
MainTab1Btn.MouseButton1Click:Connect(function()
    StealContainer.Visible = true
    BloxContainer.Visible = false
    MainTab1Btn.BackgroundTransparency = 0.3
    MainTab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab1Stroke.Color = Color3.fromRGB(255, 50, 50)
    Tab1Stroke.Thickness = 2
    
    MainTab2Btn.BackgroundTransparency = 0.7
    MainTab2Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tab2Stroke.Color = Color3.fromRGB(255, 255, 255)
    Tab2Stroke.Thickness = 1
end)

MainTab2Btn.MouseButton1Click:Connect(function()
    StealContainer.Visible = false
    BloxContainer.Visible = true
    MainTab2Btn.BackgroundTransparency = 0.3
    MainTab2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab2Stroke.Color = Color3.fromRGB(255, 50, 50)
    Tab2Stroke.Thickness = 2
    
    MainTab1Btn.BackgroundTransparency = 0.7
    MainTab1Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tab1Stroke.Color = Color3.fromRGB(255, 255, 255)
    Tab1Stroke.Thickness = 1
end)

-- HÀM TẠO NÚT SCRIPT (CÓ HIỆU ỨNG VIỀN ĐỎ KHI BẤM)
local function AddScriptButton(scrollParent, Name, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = scrollParent
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Btn.BackgroundTransparency = 0.25
    Btn.Text = Name
    Btn.TextColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Font = Enum.Font.SourceSansSemibold
    Btn.TextSize = 14
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(255, 255, 255)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        -- Reset nút cũ về viền trắng
        if LastSelectedScriptStroke then
            LastSelectedScriptStroke.Color = Color3.fromRGB(255, 255, 255)
            LastSelectedScriptStroke.Thickness = 1
        end
        
        -- Đổi nút vừa bấm sang viền đỏ đày nổi bật
        BtnStroke.Color = Color3.fromRGB(255, 50, 50)
        BtnStroke.Thickness = 2.5
        
        -- Cập nhật biến lưu trữ
        LastSelectedScriptBtn = Btn
        LastSelectedScriptStroke = BtnStroke
        
        -- Thực thi script
        Callback()
    end)
end

-- ================= 1. STEAL AN EGG (NO KEY) =================
AddScriptButton(StealNoKeyScroll, "1. Hop sv1 người(nokey)", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)
AddScriptButton(StealNoKeyScroll, "2. FyyCommunity(lúc có key lúc no key)", function()
    loadstring(game:HttpGet("https://FyyCommunity.my.id"))()
end)
AddScriptButton(StealNoKeyScroll, "3. Chilli Hub V4(nokey)", function()
    loadstring(game:HttpGet("https://id.tomroblox.com/raw/kairoblox/chilli-hub-viet-hoa-v4"))()
end)
AddScriptButton(StealNoKeyScroll, "4. Night hub(nokey)", function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealAnEggs.luau"))()
end)

-- ================= 2. STEAL AN EGG (CÓ KEY) =================
AddScriptButton(StealHasKeyScroll, "1. Lemon Hub v4(có key)", function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/owenzeke99-tech/lennonhubv4/refs/heads/main/lennonhubkeyless.txt", true))()    
end)
AddScriptButton(StealHasKeyScroll, "2. Hoshi hub(có key)", function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/napun87/stealanegg/refs/heads/main/hosi.lua"))()   
end)
AddScriptButton(StealHasKeyScroll, "3. Bigfroot(có key)", function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"))()    
end)
AddScriptButton(StealHasKeyScroll, "4. Chữ A(ajjans)|(có key)", function()

loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua"))()
end)
AddScriptButton(StealHasKeyScroll, "5. Speed hub(có key)", function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end)
AddScriptButton(StealHasKeyScroll, "6. Real kid(có key)", function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))()
end)
AddScriptButton(StealHasKeyScroll, "7. Chilli v2(có key)", function()

loadstring(game:HttpGet("https://gist.githubusercontent.com/ronnei/1fa67c56dd9af203b192d15e752928e5/raw/4e2d5105640e09a008b4ae6df23f9708cadfef06/chilliv2-stealanegg"))()
end)

-- ================= 3. BLOXKID (NO KEY) =================
AddScriptButton(BloxNoKeyScroll, "1. RedzHub v2 (no key)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/UCT-hub/main/refs/heads/main/redz-v2"))()
end)
AddScriptButton(BloxNoKeyScroll, "2. Quantumx Hub(nokey)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
end)

-- ================= 4. BLOXKID (CÓ KEY) =================
AddScriptButton(BloxHasKeyScroll, "1. Speed Hub(có key)", function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end)
AddScriptButton(BloxHasKeyScroll, "2. Omg Hub(có key)", function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))()
end)
AddScriptButton(BloxHasKeyScroll, "3. TeddyHub(có key)", function()

repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua"))()
end)
AddScriptButton(BloxHasKeyScroll, "4. Gravity Hub(có key)", function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua"))()
end)
AddScriptButton(BloxHasKeyScroll, "5.  Realkid hub(có key)", function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))()
end)
AddScriptButton(BloxHasKeyScroll, "6.  BananaHub(có key)", function()

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
    getgenv().Team = "Marines"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/obiyeueim/vthangsitink/main/BananaHub.lua"))()
end)
-- BẤM NÚT TRÒN BẬT/TẮT MENU
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
