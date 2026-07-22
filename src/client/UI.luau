local Players = game:GetService("Players")

local UI = {}

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ammoGui = playerGui:WaitForChild("AmmoGui")
local ammoText = ammoGui:WaitForChild("Frame"):WaitForChild("AmmoText")

function UI.displayAmmo(ammo, maxAmmo)
    ammoText.Text = ammo .. " / " .. maxAmmo
end

return UI
