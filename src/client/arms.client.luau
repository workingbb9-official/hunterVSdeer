local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local hunterArmsTemplate = ReplicatedStorage:WaitForChild("FPS Arm")
local hunterArms

local cameraOffsetFrame = CFrame.new(0, -0.5, 0)

local function spawnArms()
    if hunterArms then
        hunterArms:Destroy()
    end

    hunterArms = hunterArmsTemplate:Clone()
    hunterArms.Parent = camera

    for _, part in pairs(hunterArms:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = true
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
		end
	end
end

local function updateArms()
    if hunterArms and hunterArms.PrimaryPart then
        local CFrame = camera.CFrame * cameraOffsetFrame
        hunterArms:SetPrimaryPartCFrame(CFrame)
    end
end
        
RunService.RenderStepped:Connect(updateArms)
player.CharacterAdded:Connect(spawnArms)
