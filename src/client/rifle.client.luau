local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local hunterRifleTemplate = ReplicatedStorage:WaitForChild("Hunting Rifle")
local hunterRifle

local cameraOffsetFrame = CFrame.new(0.7, -0.8, -1)

local function spawnRifle()
    if hunterRifle then
        hunterRifle:Destroy()
    end

    hunterRifle = hunterRifleTemplate:Clone()
    hunterRifle.Parent = camera

    for _, part in pairs(hunterRifle:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = true
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
		end
	end
end

local function updateRifle()
    if hunterRifle and hunterRifle.PrimaryPart then
        hunterRifle:SetPrimaryPartCFrame(camera.CFrame * cameraOffsetFrame)
    end
end
        
player.CharacterAdded:Connect(spawnRifle)
RunService.RenderStepped:Connect(updateRifle)
