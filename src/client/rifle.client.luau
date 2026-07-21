local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local MAX_DISTANCE = 500
local BULLET_SPEED = 300

local ammo = 5

local camera = workspace.CurrentCamera
local arms = camera:WaitForChild("FPS Arm")
local rifle = camera:WaitForChild("Hunting Rifle")
local barrel = rifle:WaitForChild("Barrel", true)

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

    if not result then
        return
    end

    print(result.Instance)
end

local function tryFireRifle()
    if ammo > 0 then
        print("Firing rifle")
        fireRifle(barrel.Position)

        ammo -= 1
        print(ammo)
    else
        print("No ammo left")
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        tryFireRifle()
    end
end)
