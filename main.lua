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

-- Lấy link ảnh Avatar nhân vật
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

-- Tiêu đề Menu
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleBar.BackgroundTransparency = 0.6

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Xử lý kéo bảng menu
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
TitleText.Text = "TỔNG HỢP | 👑VzNam Hub v2👑|"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 13
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- 3. THANH TAB DỌC BÊN TRÁI (10 TAB)
local TabBarLeftScroll = Instance.new("ScrollingFrame")
TabBarLeftScroll.Name = "TabBarLeftScroll"
TabBarLeftScroll.Parent = MainFrame
TabBarLeftScroll.Position = UDim2.new(0, 8, 0, 48)
TabBarLeftScroll.Size = UDim2.new(0, 100, 1, -56)
TabBarLeftScroll.BackgroundTransparency = 1
TabBarLeftScroll.CanvasSize = UDim2.new(0, 0, 0, 480)
TabBarLeftScroll.ScrollBarThickness = 3

local LeftLayout = Instance.new("UIListLayout")
LeftLayout.Parent = TabBarLeftScroll
LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
LeftLayout.Padding = UDim.new(0, 8)

-- HÀM TẠO KHUNG CHỨA SUB-TABS
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
    nkStroke.Color = Color3.fromRGB(255, 50, 50)
    nkStroke.Thickness = 2
    nkStroke.Parent = noKeyBtn
    
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

local tabContainers = {}
local mainTabButtons = {}

-- =========================================================================
-- ĐỔI TÊN 10 TAB CHÍNH Ở ĐÂY:
-- =========================================================================
local tabNames = {
    "steal an egg",
    "blox kid",
    "chưa có",
    "chưa có",
    "chưa có",
    "chưa có",
    "chưa có",
    "chưa có",
    "chưa có",
    "chưa có"
}

for i = 1, 10 do
    local isFirst = (i == 1)
    local container, noKeyScroll, hasKeyScroll = CreateCategoryContainer(isFirst)
    
    tabContainers[i] = {
        Container = container,
        NoKeyScroll = noKeyScroll,
        HasKeyScroll = hasKeyScroll
    }
    
    local btn = Instance.new("TextButton")
    btn.Parent = TabBarLeftScroll
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = isFirst and 0.3 or 0.7
    btn.Text = tabNames[i]
    btn.TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.TextWrapped = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = isFirst and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = isFirst and 2 or 1
    stroke.Parent = btn
    
    mainTabButtons[i] = {Button = btn, Stroke = stroke}
    
    btn.MouseButton1Click:Connect(function()
        for j = 1, 10 do
            local active = (i == j)
            tabContainers[j].Container.Visible = active
            mainTabButtons[j].Button.BackgroundTransparency = active and 0.3 or 0.7
            mainTabButtons[j].Button.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
            mainTabButtons[j].Stroke.Color = active and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
            mainTabButtons[j].Stroke.Thickness = active and 2 or 1
        end
    end)
end

-- HÀM TẠO NÚT SCRIPT
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
        if LastSelectedScriptStroke then
            LastSelectedScriptStroke.Color = Color3.fromRGB(255, 255, 255)
            LastSelectedScriptStroke.Thickness = 1
        end
        
        BtnStroke.Color = Color3.fromRGB(255, 50, 50)
        BtnStroke.Thickness = 2.5
        
        LastSelectedScriptBtn = Btn
        LastSelectedScriptStroke = BtnStroke
        
        Callback()
    end)
end

-- =========================================================================
-- ĐOẠN THÊM SCRIPT CHO TỪNG TAB (TỪ TAB 1 ĐẾN TAB 10):
-- =========================================================================

-- ----------------- TAB 1: STEAL AN EGG -----------------
-- NO KEY:
AddScriptButton(tabContainers[1].NoKeyScroll, "1. Hop sv1 người(nokey)", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)
AddScriptButton(tabContainers[1].NoKeyScroll, "2. FyyCommunity(lúc có key lúc no key)", function()
    loadstring(game:HttpGet("https://FyyCommunity.my.id"))()
end)
AddScriptButton(tabContainers[1].NoKeyScroll, "3. Chilli Hub V4(nokey)", function()
    loadstring(game:HttpGet("https://id.tomroblox.com/raw/kairoblox/chilli-hub-viet-hoa-v4"))()
end)
AddScriptButton(tabContainers[1].NoKeyScroll, "4. Night hub(nokey)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealAnEggs.luau"))()
end)

-- CÓ KEY:
AddScriptButton(tabContainers[1].HasKeyScroll, "1. Lemon Hub v4(có key)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/owenzeke99-tech/lennonhubv4/refs/heads/main/lennonhubkeyless.txt", true))()    
end)
AddScriptButton(tabContainers[1].HasKeyScroll, "2. Hoshi hub(có key)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/napun87/stealanegg/refs/heads/main/hosi.lua"))()   
end)
AddScriptButton(tabContainers[1].HasKeyScroll, "3. Bigfroot(có key)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"))()    
end)
AddScriptButton(tabContainers[1].HasKeyScroll, "4. Chữ A(ajjans)|(có key)", function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua"))()
end)
AddScriptButton(tabContainers[1].HasKeyScroll, "5. Speed hub(có key)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end)
AddScriptButton(tabContainers[1].HasKeyScroll, "6. Real kid(có key)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))()
end)
AddScriptButton(tabContainers[1].HasKeyScroll, "7. Chilli v2(có key)", function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/ronnei/1fa67c56dd9af203b192d15e752928e5/raw/4e2d5105640e09a008b4ae6df23f9708cadfef06/chilliv2-stealanegg"))()
end)


-- ----------------- TAB 2: BLOXKID -----------------
-- NO KEY:
AddScriptButton(tabContainers[2].NoKeyScroll, "1. RedzHub v2 (no key)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/UCT-hub/main/refs/heads/main/redz-v2"))()
end)
AddScriptButton(tabContainers[2].NoKeyScroll, "2. Quantumx Hub(nokey)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
end)

-- CÓ KEY:
AddScriptButton(tabContainers[2].HasKeyScroll, "1. Speed Hub(có key)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end)
AddScriptButton(tabContainers[2].HasKeyScroll, "2. Omg Hub(có key)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))()
end)
AddScriptButton(tabContainers[2].HasKeyScroll, "3. TeddyHub(có key)", function()
    repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua"))()
end)
AddScriptButton(tabContainers[2].HasKeyScroll, "4. Gravity Hub(có key)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua"))()
end)
AddScriptButton(tabContainers[2].HasKeyScroll, "5. Realkid hub(có key)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))()
end)
AddScriptButton(tabContainers[2].HasKeyScroll, "6. BananaHub(có key)", function()
    repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
    getgenv().Team = "Marines"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/obiyeueim/vthangsitink/main/BananaHub.lua"))()
end)


-- ----------------- TAB 3 -----------------
-- NO KEY:
AddScriptButton(tabContainers[3].NoKeyScroll, "1. Tên Script No Key (Tab 3)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)

-- CÓ KEY:
AddScriptButton(tabContainers[3].HasKeyScroll, "1. Tên Script Có Key (Tab 3)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)


-- ----------------- TAB 4 -----------------
-- NO KEY:
AddScriptButton(tabContainers[4].NoKeyScroll, "1. Tên Script No Key (Tab 4)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)

-- CÓ KEY:
AddScriptButton(tabContainers[4].HasKeyScroll, "1. Tên Script Có Key (Tab 4)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)


-- ----------------- TAB 5 -----------------
-- NO KEY:
AddScriptButton(tabContainers[5].NoKeyScroll, "1. Tên Script No Key (Tab 5)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)

-- CÓ KEY:
AddScriptButton(tabContainers[5].HasKeyScroll, "1. Tên Script Có Key (Tab 5)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)


-- ----------------- TAB 6 -----------------
-- NO KEY:
AddScriptButton(tabContainers[6].NoKeyScroll, "1. Tên Script No Key (Tab 6)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)

-- CÓ KEY:
AddScriptButton(tabContainers[6].HasKeyScroll, "1. Tên Script Có Key (Tab 6)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)


-- ----------------- TAB 7 -----------------
-- NO KEY:
AddScriptButton(tabContainers[7].NoKeyScroll, "1. Tên Script No Key (Tab 7)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)

-- CÓ KEY:
AddScriptButton(tabContainers[7].HasKeyScroll, "1. Tên Script Có Key (Tab 7)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)


-- ----------------- TAB 8 -----------------
-- NO KEY:
AddScriptButton(tabContainers[8].NoKeyScroll, "1. Tên Script No Key (Tab 8)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)

-- CÓ KEY:
AddScriptButton(tabContainers[8].HasKeyScroll, "1. Tên Script Có Key (Tab 8)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)


-- ----------------- TAB 9 -----------------
-- NO KEY:
AddScriptButton(tabContainers[9].NoKeyScroll, "1. Tên Script No Key (Tab 9)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)

-- CÓ KEY:
AddScriptButton(tabContainers[9].HasKeyScroll, "1. Tên Script Có Key (Tab 9)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)


-- ----------------- TAB 10 -----------------
-- NO KEY:
AddScriptButton(tabContainers[10].NoKeyScroll, "1. Tên Script No Key (Tab 10)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)

-- CÓ KEY:
AddScriptButton(tabContainers[10].HasKeyScroll, "1. Tên Script Có Key (Tab 10)", function()
    -- DÁN SCRIPT VÀO ĐÂY
end)
-- BẤM NÚT TRÒN BẬT/TẮT MENU
ToggleBtn.MouseButton1Click:Connect(function()
