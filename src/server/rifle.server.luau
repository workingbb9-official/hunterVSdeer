local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local bulletFiredEvent = ReplicatedStorage:WaitForChild("BulletFiredEvent")

local MAX_ALLOWED_MUZZLE_DISTANCE = 10
local MAX_DISTANCE = 500

local function onBulletFired(player, muzzlePos, directionVector)
    local character = player.Character
	if not character or not character:FindFirstChild("Humanoid") or character.Humanoid.Health <= 0 then
		return
	end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

    local distanceToMuzzle = (hrp.Position - muzzlePos).Magnitude
	if distanceToMuzzle > MAX_ALLOWED_MUZZLE_DISTANCE then
		warn(player.Name .. " attempted to fire from suspicious muzzle position.")
		return
	end

    local rayDirection = directionVector.Unit * MAX_DISTANCE

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {character}

	local result = workspace:Raycast(muzzlePos, rayDirection, raycastParams)
	local endPos = result and result.Position or (muzzlePos + rayDirection)

	if result and result.Instance then
		local hitPart = result.Instance
		local targetModel = hitPart:FindFirstAncestorOfClass("Model")

		if targetModel then
			local humanoid = targetModel:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
                local playerHit = Players:GetPlayerFromCharacter(humanoid.Parent)
                print(player.Name .. " hit " .. playerHit.Name)
			end
		end
	end

	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player then
			bulletFiredEvent:FireClient(otherPlayer, muzzlePos, endPos)
		end
	end
end

bulletFiredEvent.OnServerEvent:Connect(onBulletFired)
