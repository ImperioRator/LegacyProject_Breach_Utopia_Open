
local FullscreenCvar = MediaPlayer.Cvars.Fullscreen

local pcall = pcall
local print = print
local Angle = Angle
local IsValid = IsValid
local ValidPanel = ValidPanel
local Vector = Vector
local cam = cam
local Start3D = cam.Start3D
local Start3D2D = cam.Start3D2D
local End3D2D = cam.End3D2D
local draw = draw
local math = math
local string = string
local surface = surface

local ceil = math.ceil
local floor = math.floor
local Round = math.Round
local log = math.log
local pow = math.pow

local RenderScale = 0.1
local InfoScale = 1/17

local BaseInfoHeight = 60

local function CeilPower2(n)
	return pow(2, ceil(log(n) / log(2)))
end

local function drawHTMLPanel(panel, w, h)
    if not (IsValid( panel ) and w and h) then return end

    panel:UpdateHTMLTexture()

    local pw, ph = panel:GetSize()

    w = w / pw
    h = h / ph

    pw = CeilPower2(pw)
    ph = CeilPower2(ph)

    local mat = panel:GetHTMLMaterial()

    if mat then
        Pixelated.SetBaseTexture(mat:GetTexture("$basetexture"))

        Pixelated.DrawWithFunc(function()
            Pixelated.SetDrawColor(255, 255, 255)
            Pixelated.DrawTexturedRect(0, 0, w * pw, h * ph)
            -- Pixelated.DrawTexturedRectUV(0, 0, html_width, html_height, 0, 0, html_width / width, html_height / height, true)
        end, false, false) -- we dont need depth pass
    end

end

local function injectScreen(ent)
    print(ent)

    local mediaplayer = ent:GetMediaPlayer()

    if not mediaplayer then
        error("mediaplayer not exists! Entity = " .. tostring(ent))
    end

    print("mediaplayer", mediaplayer, "ent", ent)

    local drawHook = hook.GetTable()["PostDrawOpaqueRenderables"][mediaplayer]

    hook.Add("PostDrawOpaqueRenderables", mediaplayer, function()
        local self = mediaplayer

        if
                FullscreenCvar:GetBool() or -- Don't draw if we're drawing fullscreen
                not IsValid(ent) or
                (ent.IsDormant and ent:IsDormant()) then
            return
        end

        local media = self:GetMedia()
        local w, h, pos, ang = self:GetOrientation()

        -- Render scale
        local rw, rh = w / RenderScale, h / RenderScale

        if IsValid(media) then

            -- Custom media draw function
            -- if media.Draw then
            --     Start3D2D( pos, ang, RenderScale )
            --         media:Draw( rw, rh )
            --     End3D2D()
            -- end
            -- TODO: else draw 'not yet implemented' screen?


            if media.Browser then -- render browser, why we need media info with LCD effect?
                Pixelated.SetPixelLuma(3)
                Pixelated.SetPixelLayout(Pixelated.LAYOUT_SQUARE, 0)
    
                -- Pixelated.SetBaseTexture(media.Browser)

                Pixelated.Start3D2D(pos, ang, RenderScale)
                
                drawHTMLPanel(media.Browser, rw, rh)
    
                Pixelated.End3D2D()
            end

            -- scale based off of height
            local scale = InfoScale * ( h / BaseInfoHeight )

            -- Media info
            Start3D2D( pos, ang, scale )
                local iw, ih = w / scale, h / scale
                self:DrawMediaInfo( media, iw, ih )
            End3D2D()

        else

            Start3D2D( pos, ang, RenderScale )
                self:DrawIdlescreen( rw, rh )
            End3D2D()

        end
    end)

    
end

hook.Add("OnEntityCreated", "mediascreen-inject", function(ent)
    timer.Simple(1, function()
        if not IsValid(ent) then return end
        if scripted_ents.IsBasedOn(ent:GetClass(), "mediaplayer_base") then
            injectScreen(ent)
        end
    end)
end)

for k, v in pairs(ents.GetAll()) do
    if scripted_ents.IsBasedOn(v:GetClass(), "mediaplayer_base") then
        injectScreen(v)
    end
end