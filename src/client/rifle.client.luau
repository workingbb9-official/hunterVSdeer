local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local bulletFiredEvent = ReplicatedStorage:WaitForChild("BulletFiredEvent")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local scripts = player:WaitForChild("PlayerScripts")
local UI = require(scripts:WaitForChild("UI"))

local MAX_DISTANCE = 500
local BULLET_SPEED = 300

local MAX_AMMO = 5
local ammo = 5
UI.displayAmmo(ammo, MAX_AMMO)

local camera = workspace.CurrentCamera
local arms = camera:WaitForChild("FPS Arm")
local rifle = camera:WaitForChild("Hunting Rifle")
local barrel = rifle:WaitForChild("Bolt Action Rifle"):WaitForChild("Barrel")

local function shootVisualBullet(startPos, endPos)
    local distance = (endPos - startPos).Magnitude
    local duration = distance / BULLET_SPEED

    local bullet = Instance.new("Part")
    bullet.Size = Vector3.new(0.1, 0.1, 3)
    bullet.Material = Enum.Material.Neon
    bullet.Color = Color3.fromRGB(255, 215, 0)
    bullet.Anchored = true
    bullet.CanCollide = false
    bullet.CFrame = CFrame.lookAt(startPos, endPos)
    bullet.Parent = workspace

    local tween = TweenService:Create(bullet, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        CFrame = CFrame.lookAt(endPos, endPos + bullet.CFrame.LookVector)
    })

    tween:Play()
    Debris:AddItem(bullet, duration)
end

local function fireRifle(gunMuzzlePosition)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {
        player.Character,
        arms,
        rifle
    }

    params.IgnoreWater = true
    params.RespectCanCollide = true

    local targetPosition = mouse.Hit.Position
    local direction = (targetPosition - gunMuzzlePosition).Unit * MAX_DISTANCE

    local result = workspace:Raycast(gunMuzzlePosition, direction, params)
    local endPosition = result and result.Position or (gunMuzzlePosition + direction)

    shootVisualBullet(gunMuzzlePosition, endPosition)
    bulletFiredEvent:FireServer(gunMuzzlePosition, direction)
end

local function tryFireRifle()
    if ammo > 0 then
        fireRifle(barrel.Position)
        ammo -= 1
        UI.displayAmmo(ammo, MAX_AMMO)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        tryFireRifle()
    end
end)

bulletFiredEvent.OnClientEvent:Connect(shootVisualBullet)
