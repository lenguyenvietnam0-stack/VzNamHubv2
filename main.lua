-- Khoá và load thư viện Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo cửa sổ thông báo chính
local Window = Rayfield:CreateWindow({
   Name = "🌸 THÔNG BÁO CẬP NHẬT 🌸",
   LoadingTitle = "Đang tải giao diện...",
   LoadingSubtitle = "Delta X Executor",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- Tạo Tab thông báo
local Tab = Window:CreateTab("Thông Báo", 4483362458)

-- Nội dung thông báo
Tab:CreateSection("🌸 ĐÃ CÓ BẢN CẬP NHẬT MỚI 🌸")

Tab:CreateLabel("JOIN DISCORD ĐỂ LẤY V3 VÀ V4")

-- Nút sao chép Link Discord
Tab:CreateButton({
   Name = "📋 Sao chép link Discord",
   Callback = function()
      local discordLink = "https://discord.gg/6TG7krbsU"
      
      -- Tự động sao chép vào Clipboard (hỗ trợ Delta X)
      if setclipboard then
         setclipboard(discordLink)
      elseif toclipboard then
         toclipboard(discordLink)
      end
      
      -- Hiển thị thông báo nhỏ khi sao chép thành công
      Rayfield:Notify({
         Title = "Thành công!",
         Content = "Đã sao chép link Discord vào bộ nhớ tạm!",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})
