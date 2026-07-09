function GM:PlayerNoClip()
    return false
end

BREACH = BREACH or {}
ALLLANGUAGES = ALLLANGUAGES or {}
WEPLANG = WEPLANG or {}
russian = russian or {}
nontranslated = nontranslated or {}

local BASE_PATH = GM.FolderName .. "/gamemode"
local LANGUAGES_PATH = BASE_PATH .. "/languages"
local MAP_CONFIG_PATH = BASE_PATH .. "/mapconfigs"

MsgC( Color(255,0,255), "\n[Legacy Breach] Legend: ", Color(0,255,255), "Server ", Color(255,255,0), "Shared ", Color(255,100,0), "Client\n" )
Msg("======================================================================\n")

if SERVER then
    AddCSLuaFile( "modules/cl_module.lua" )
    AddCSLuaFile( "modules/sh_module.lua" )
    AddCSLuaFile( "modules/config/changelogs.lua" )
    AddCSLuaFile( "modules/config/donatelist.lua" )
    AddCSLuaFile( "modules/config/music.lua" )

    include( "modules/config/music.lua" )
    include( "modules/sv_module.lua" )
    include( "modules/sh_module.lua" )
else
    include( "modules/cl_module.lua" )
    include( "modules/sh_module.lua" )
end

Msg( "\n" )


MsgC( Color(0,255,0), "----------------Loading Languages----------------\n")

local lang_files = file.Find(LANGUAGES_PATH .. "/*.lua", "LUA" )
for _, f in ipairs( lang_files ) do
    local filepath = LANGUAGES_PATH .. "/" .. f
    if SERVER then
        MsgC( Color(255,255,0), "[Legacy Breach] Loading Language: " .. f .. "\n" )
        AddCSLuaFile( filepath )
        include( filepath )
    else
        include( filepath )
    end
end

function BREACH.CompareLanguage(lang)
    local no_translations = {}
    for k, v in pairs(russian) do
        if not lang[k] then
            no_translations[k] = v
        end
    end
    return no_translations
end

local function AutoComplete(cmd, stringargs)
    local tbl = {}
    for k, _ in pairs(ALLLANGUAGES) do
        table.insert(tbl, "breach_compare_language " .. tostring(k))
    end
    return tbl
end

concommand.Add("breach_compare_language", function(ply, cmd, args)
    if not args[1] or not ALLLANGUAGES[args[1]] then
        print("Language not found or missing argument.")
        return
    end

    local tbl = BREACH.CompareLanguage(ALLLANGUAGES[args[1]])
    local missing_count = table.Count(tbl)

    if missing_count > 0 then
        PrintTable(tbl)
        print("Found " .. missing_count .. " missing phrases in " .. args[1])
    else
        print("Language " .. args[1] .. " is up to date!")
    end
end, AutoComplete)

if not BREACH.LanguageChecked then
    local obsolete_found = false
    MsgC( Color(255,255,0), "[Legacy Breach] Comparing languages...\n" )
    
    for k, v in pairs(ALLLANGUAGES) do
        local missing_count = table.Count(BREACH.CompareLanguage(v))
        if missing_count > 0 then
            MsgC( Color(255,0,0), "[Legacy Breach] Language " .. tostring(k) .. " is obsolete. Missing: " .. missing_count .. "\n" )
            obsolete_found = true
        end
    end

    if obsolete_found then
        MsgC( Color(255,255,0), "[Legacy Breach] Use command 'breach_compare_language <lang>' to get missing phrases\n" )
    else
        MsgC( Color(0,255,0), "[Legacy Breach] All languages are up to date\n" )
    end
    BREACH.LanguageChecked = true
end

local function LoadDirectory(folder_path, title)
    MsgC( Color(0,255,0), "----------------" .. title .. "----------------\n")
    
    local files = file.Find( folder_path .. "/*.lua", "LUA" )
    local skipped = 0

    for _, f in ipairs( files ) do
        if f == "sv_module.lua" or f == "sh_module.lua" or f == "cl_module.lua" then continue end
        
        if string.sub( f, 1, 1 ) == "_" then
            skipped = skipped + 1
            continue
        end

        if string.len( f ) > 3 then
            local ext = string.sub( f, 1, 3 )
            local filepath = folder_path .. "/" .. f

            if ext == "cl_" then
                if SERVER then
                    MsgC( Color(255,100,0), "[Legacy Breach] Loading CLIENT file: " .. f .. "\n" )
                    AddCSLuaFile( filepath )
                else
                    include( filepath )
                end
            elseif ext == "sv_" then
                if SERVER then
                    MsgC( Color(0,255,255), "[Legacy Breach] Loading SERVER file: " .. f .. "\n" )
                    include( filepath )
                end
            elseif ext == "sh_" then
                if SERVER then
                    AddCSLuaFile( filepath )
                end
                MsgC( Color(255,255,0), "[Legacy Breach] Loading SHARED file: " .. f .. "\n" )
                include( filepath )
            end
        else
            skipped = skipped + 1
        end
    end

    if skipped > 0 then
        MsgC( Color(0,255,0), "# Skipped files in " .. title .. ": " .. skipped .. "\n")
    end
end

LoadDirectory(BASE_PATH .. "/modules", "Loading Modules")
LoadDirectory(BASE_PATH .. "/modules/anim_base", "Loading Animation Base")

MsgC( Color(0,255,0), "---------------Loading Map Config----------------\n" )

local current_map = game.GetMap()
local map_file_path = MAP_CONFIG_PATH .. "/" .. current_map .. ".lua"
local map_rel_path = "mapconfigs/" .. current_map .. ".lua"

MAP_LOADED = MAP_LOADED or false

if file.Exists( map_file_path, "LUA" ) then
    if SERVER then AddCSLuaFile( map_rel_path ) end
    include( map_rel_path )
    
    MsgC( Color(0,255,0), "# Config loaded for map " .. current_map .. "\n" )
    MAP_LOADED = true
else
    MsgC( Color(255,0,0), "[Legacy Breach] WARNING: Unsupported map " .. current_map .. "! Gamemode may not work correctly.\n" )
end

MsgC( Color(0,255,0), "================ Loading Complete =================\n" )