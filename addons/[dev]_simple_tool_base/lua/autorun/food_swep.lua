FoodSwep = {}

FoodSwep.ANIMATION_EVENT_COMPLETE = 0
FoodSwep.ANIMATION_EVENT_HALF = 1

function FoodSwep:IncludeFile(file)
    if SERVER then
        AddCSLuaFile(file)
        include(file)
    end

    if CLIENT then
        include(file)
    end
end

function FoodSwep:IncludeDirectory(dir)
    local files, directories = file.Find(dir .. "/*.lua", "LUA")

    for _, file in pairs(files) do
        FoodSwep:IncludeFile(dir .. "/" .. file)
    end
end

function FoodSwep:Initialize()
    FoodSwep:IncludeFile("food_swep/easing.lua")
    FoodSwep:IncludeFile("food_swep/bones.lua")
    FoodSwep:IncludeFile("food_swep/net.lua")
    FoodSwep:IncludeFile("food_swep/main.lua")
end

FoodSwep:Initialize()