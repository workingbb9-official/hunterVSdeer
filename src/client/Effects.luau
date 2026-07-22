local Effects = {}

local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local BULLET_SPEED = 300

function Effects.ShootTracer(startPos, endPos)
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

return Effects
