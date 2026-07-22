local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local bulletFiredEvent = ReplicatedStorage:WaitForChild("BulletFiredEvent")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local scripts = player:WaitForChild("PlayerScripts")
local UI = require(scripts:WaitForChild("UI"))
local Effects = require(scripts:WaitForChild("Effects"))

local MAX_DISTANCE = 500
local BULLET_SPEED = 300

local MAX_AMMO = 5
local ammo = 5
UI.displayAmmo(ammo, MAX_AMMO)

local camera = workspace.CurrentCamera
local arms = camera:WaitForChild("FPS Arm")
local rifle = camera:WaitForChild("Hunting Rifle")
local barrel = rifle:WaitForChild("Bolt Action Rifle"):WaitForChild("Barrel")

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

    Effects.ShootTracer(gunMuzzlePosition, endPosition)
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

bulletFiredEvent.OnClientEvent:Connect(Effects.ShootTracer)
