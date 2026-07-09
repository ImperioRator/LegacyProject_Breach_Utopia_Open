-- Draw gmod logo on construct

local function exampleDraw()
    Pixelated.SetBaseTexture("effects/flashlight/logo", 512, 512)

    -- local pos = Vector(-903.968750, -1372.773560, -60.237328)
    local pos = Vector(8141.260742, -3929.963135, 65)

    -- if we change the pixel mask, it is preferred to restore the state after rendering
    Pixelated.SetPixelMask("pixelated/pixelstripes1")


    Pixelated.SetPixelLuma(3)
    Pixelated.SetPixelLayout(Pixelated.LAYOUT_SQUARE, 0)
    
    -- old method

    -- Pixelated.StartDraw()
    -- render.DrawQuadEasy(pos, Vector(-1, 0, 0), 128, 128, Color(183, 183, 183), 180)
    -- Pixelated.EndDraw()

    -- render.SetMaterial(depth_write_mat)
    -- render.PushRenderTarget(render.GetResolvedFullFrameDepth())
    -- render.DrawQuadEasy(pos, Vector(1, 0, 0), 128, 128, Color(255, 255, 255), 180)
    -- render.PopRenderTarget()
    
    -- new method

    local pos = Vector(0, 0, -80)
    local ang = Angle(0, 45, 90)
    local scale = 0.5

    Pixelated.Start3D2D(pos, ang, scale)
        Pixelated.DrawWithFunc(function()
            Pixelated.SetDrawColor(255, 255, 255)
            Pixelated.DrawTexturedRect(0, 0, 128, 128)
            Pixelated.DrawTexturedRectUV(128 + 2, 0, 128, 128, 0.14, 0.114, 0.858, 0.825)
        end, true)
    Pixelated.End3D2D()


    Pixelated.SetDefaultPixelMask()
end

hook.Remove("PreDrawOpaqueRenderables", "pixelated_example")
hook.Remove("PostDrawOpaqueRenderables", "pixelated_example") -- It is recommended to use this hook if you have it installed or want compatibility with GShader Lib.
hook.Remove("PreDrawTranslucentRenderables", "pixelated_example") 
hook.Remove("PostDrawTranslucentRenderables", "pixelated_example")

hook.Add("PostDrawOpaqueRenderables", "pixelated_example", function()
    exampleDraw()
end)
