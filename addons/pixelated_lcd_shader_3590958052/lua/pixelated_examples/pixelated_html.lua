
local html_width = 1920
local html_height = 1080
local html_url = "https://www.youtube.com/embed/slVPS_VJqhs?autoplay=1&controls=0"

local world_scale = 0.04

local function initializeHTML()
    if IsValid(g_PixelatedHTML) then
        g_PixelatedHTML:Remove()
        g_PixelatedHTML = nil
    end

    g_PixelatedHTML = vgui.Create("DHTML")
    g_PixelatedHTML:SetSize(html_width, html_height)
    g_PixelatedHTML:SetMouseInputEnabled(false)
    g_PixelatedHTML:SetKeyboardInputEnabled(false)
    g_PixelatedHTML:SetAlpha(0)
    g_PixelatedHTML:OpenURL(html_url)

    -- chat gpt prun'k
    -- g_PixelatedHTML:SetHTML([[
    --     <head>
    --         <style>
    --         html, body {
    --             margin: 0;
    --             padding: 0;
    --             height: 100%;
    --             overflow: hidden; /* чтобы не было скролла */
    --         }
    --         iframe {
    --             position: fixed;
    --             top: 0;
    --             left: 0;
    --             width: 100vw;
    --             height: 100vh;
    --             border: none; /* убирает обводку */
    --         }
    --         </style>
    --     </head>
    --     <body>
    --     <iframe id="yt" src="]] .. html_url .. [[" allow="autoplay; fullscreen"></iframe>
    --     <script>
    --         /*
    --         var tag = document.createElement('script');
    --         tag.src = "https://www.youtube.com/iframe_api";
    --         document.head.appendChild(tag);
    
    --         var player;
    
    --         // 2️⃣ Эта функция вызывается автоматически, когда API загрузится
    --         function onYouTubeIframeAPIReady() {
    --         player = new YT.Player('yt', {
    --             events: {
    --             'onReady': onPlayerReady
    --             }
    --         });
    --         }
    
    --         // 3️⃣ Когда плеер готов
    --         function onPlayerReady(event) {
    --         player.setVolume(20); // громкость от 0 до 100
    --         player.playVideo();   // можно убрать, если не нужно автостарт
    --         }
    --         */
    --     </script>
    --     </body>
    -- ]])
end

local function htmlDraw()
    if not IsValid(g_PixelatedHTML) then return end

    local html_mat = g_PixelatedHTML.MainMaterial

    if not html_mat then
        html_mat = g_PixelatedHTML:GetHTMLMaterial()

        if not html_mat then
            return
        end

        g_PixelatedHTML.MainMaterial = html_mat
    end

    Pixelated.SetPixelLuma(3)
    Pixelated.SetPixelLayout(Pixelated.LAYOUT_SQUARE, 0)

    local width = html_mat:Width()
    local height = html_mat:Height()

    Pixelated.SetBaseTexture(html_mat:GetTexture("$basetexture"))

    Pixelated.Start3D2D(Vector(0, 0, -20), Angle(0, 90, 90), world_scale)
        Pixelated.DrawWithFunc(function()
            Pixelated.SetDrawColor(255, 255, 255)
            Pixelated.DrawTexturedRectUV(0, 0, html_width, html_height, 0, 0, html_width / width, html_height / height, true)
        end, true)
    Pixelated.End3D2D()
end

hook.Remove("PreDrawOpaqueRenderables", "pixelated_example_2")
hook.Remove("PostDrawOpaqueRenderables", "pixelated_example_2")
hook.Remove("PreDrawTranslucentRenderables", "pixelated_example_2") 
hook.Remove("PostDrawTranslucentRenderables", "pixelated_example_2")

hook.Add("PostDrawOpaqueRenderables", "pixelated_example_2", function()
    htmlDraw()
end)

hook.Add("InitPostEntity", "pixelated_example_2", function()
    timer.Simple(0.1, initializeHTML)
end)

if IsValid(LocalPlayer()) then
    timer.Simple(0.1, initializeHTML)
end