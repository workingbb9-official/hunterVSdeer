local UserInputService = game:GetService("UserInputService")

local ammo = 5

local function tryFireRifle()
    if ammo > 0 then
        print("Firing rifle")
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
