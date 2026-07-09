local RunConsoleCommand = RunConsoleCommand
local tonumber = tonumber
local tostring = tostring
local CurTime = CurTime
local Entity = Entity
local unpack = unpack
local table = table
local pairs = pairs
local ipairs = ipairs
local concommand = concommand
local timer = timer
local ents = ents
local hook = hook
local math = math
local pcall = pcall
local ErrorNoHalt = ErrorNoHalt
local DeriveGamemode = DeriveGamemode
local util = util
local net = net
local player = player

--[[
⠀⠀⠀⠀     ⠀⠀⡔⠠⢤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⡴⠒⠒⠒⠒⠒⠶⠦⠄⢹⣄⠀⠀⠑⠄⣀⡠⠤⠴⠒⠒⠒⠀⠀
⢇⠀⠀⠀⠀⠀⠀⠐⠋⠀⠒⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀
⠈⢆⠀⠀⠀⠀⡤⠤⣄⠀⠀⠀⠀⡤⠤⢄⠀⠀⠀⠀⠀⣠⠃⠀
⠀⡀⠑⢄⡀⡜⠀⡜⠉⡆⠀⠀⠀⡎⠙⡄⠳⡀⢀⣀⣜⠁⠀⠀
⠀⠹⣍⠑⠀⡇⠀⢣⣰⠁⠀⠀⠀⠱⣠⠃⠀⡇⠁⣠⠞⠀⠀⠀
⠀⠀⠀⡇⠔⣦⠀⠀⠀⠈⣉⣀⡀⠀⠀⠰⠶⠖⠘⢧⠀⠀⠀⠀
⠀⠀⠰⠤⠐⠤⣀⡀⠀⠈⠑⣄⡁⠀⡀⣀⠴⠒⠀⠒⠃⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠘⢯⡉⠁⠀⠀⠀⠀⠉⢆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣞⡄⠀⠀⠀⠀⠀⠀⠈⡆⠀⠀
You like coding, don't you? 

:3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3

HAAVEE FUNNNN!!! >:3

--]]

if false then

BREACH = BREACH or {}
BREACH.Logs = BREACH.Logs or {}
BREACH.Logs.StartedLog = BREACH.Logs.StartedLog or false
BREACH.Logs.ServerIP = "46.174.50.119:27015" 

hook.Add("InitPostEntity", "Disable3DSkybox", function()
	timer.Simple(1, function()
		for _, ent in ipairs(ents.FindByClass("sky_camera")) do
			SafeRemoveEntity(ent)
		end
		print("[Fix] Энтити 3D-скайбокса (sky_camera) была удалена для предотвращения крашей.")
	end)
end)

local currentip = currentip or ""
hook.Add("PlayerConnect", "BREACH.Logs:GetServerIP", function()
	currentip = game.GetIPAddress()
	if currentip ~= BREACH.Logs.ServerIP then
		ServerLog("BREACH LOGS: server ip doesn't match with current ip\n")
	end
end)

local logqueue_admin = ""
local logqueue_admin_total = 0

function BREACH.Logs.SendUserLog(message, modifiedtime)
end

function BREACH.Logs.SendAdminLog(message, modifiedtime)
	if currentip ~= "" and currentip ~= BREACH.Logs.ServerIP then return end

	local time = modifiedtime and os.date("%H:%M:%S - %d/%m/%Y", os.time()) or os.date("%H:%M:%S", os.time())

	logqueue_admin = logqueue_admin .. time .. " " .. message .. "\n"
	logqueue_admin_total = logqueue_admin_total + 1

	ServerLog("BRLOG-ADMIN: " .. message .. "\n")

	if logqueue_admin_total >= 50 then
		for _, v in ipairs(player.GetAll()) do
			v:PrintMessage(HUD_PRINTCONSOLE, "Processing HTTP")
			v:PrintMessage(HUD_PRINTCONSOLE, time)
		end

		print("HTTP: Sending admin log queue")
		ServerLog("HTTP: Sending admin log queue\n")
		logqueue_admin = ""
		logqueue_admin_total = 0
	end
	
	if CHTTP then
		local form = {
			["username"] = "Forge Logger",
			["content"] = "",
			["embeds"] = {{
				["title"] = message,
				["description"] = "",
				["color"] = 16730698
			}}
		}

		CHTTP({
			["failed"] = function(msg) print("[Discord] " .. msg) end,
			["method"] = "POST",
			["url"] = "https://discord.com/api/webhooks/1219890298184798268/94bAtBnn7u9XrDczokyIH42J4R0oBBx-RutdTX1n77ANSvQTZiw4tADTbs45bC4UJjYf",
			["body"] = util.TableToJSON(form),
			["type"] = "application/json; charset=utf-8"
		})
	end
end

if not BREACH.Logs.StartedLog then
	BREACH.Logs.StartedLog = true
	BREACH.Logs.SendAdminLog("Log started", true)
	BREACH.Logs.SendUserLog("Log started", true)
end

function BREACH.Logs.FormatPlayer(ply, hideip)
	if type(ply) == "string" then return ply end
	if not IsValid(ply) then return "NULL ENTITY" end
	if ply:IsBot() then return ply:Name() .. "<BOT>" end

	local ip = string.Split(ply:IPAddress(), ":")[1] or "Unknown"
	ip = hideip and ("<IP CRC: " .. util.CRC(ip) .. ">") or ("<IP: " .. ip .. ">")

	local name = ply:Name()
	local steamid = ply:SteamID64() or "Unknown"
	local survivorname = ply.GetNamesurvivor and ply:GetNamesurvivor() or "nil"
	local gteam = ply.GTeam and gteams.GetName(ply:GTeam()) or "nil"
	local role = ply.GetRoleName and ply:GetRoleName() or "nil"
	local hp = ply:Health() .. "/" .. ply:GetMaxHealth()
	
	local wepent = ply.GetActiveWeapon and ply:GetActiveWeapon() or NULL
	local weapon = IsValid(wepent) and wepent:GetClass() or "none"

	return string.format("%s %s %s | HP: %s WEP: %s CHARNAME: %s TEAM: %s ROLE: %s | ", 
		name, steamid, ip, hp, weapon, survivorname, gteam, role)
end

local function LogBoth(admin_msg, user_msg)
	BREACH.Logs.SendAdminLog(admin_msg)
	BREACH.Logs.SendUserLog(user_msg or admin_msg)
end

gameevent.Listen("player_connect")
hook.Add("player_connect", "BREACH.Logs:player_connect", function(data)
	if data.bot then return end 

	local name = data.name
	local steamid = data.networkid
	local ip = string.Split(data.address, ":")[1] or "Unknown"
	local ip_crc = util.CRC(ip)

	BREACH.Logs.SendAdminLog(string.format("%s <IP: %s> | %s connected.", name, ip, steamid))
	BREACH.Logs.SendUserLog(string.format("%s <IP CRC: %s> | %s connected.", name, ip_crc, steamid))
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "BREACH.Logs:player_disconnect", function(data)
	if data.bot then return end 

	local ply = player.GetByID(data.userid)
	local reason = data.reason or "Unknown"
	
	local f_admin = BREACH.Logs.FormatPlayer(ply, false)
	local f_user = BREACH.Logs.FormatPlayer(ply, true)

	LogBoth(f_admin .. " disconnected. Reason: " .. reason, f_user .. " disconnected. Reason: " .. reason)
end)

hook.Add("PlayerSay", "BREACH.Logs:PlayerSay", function(ply, text, teamchat)
	local f_admin = BREACH.Logs.FormatPlayer(ply, false)
	local f_user = BREACH.Logs.FormatPlayer(ply, true)
	local action = teamchat and " whispered " or " said "

	LogBoth(f_admin .. action .. text, f_user .. action .. text)
end)

local translatedamagetype = {
	[DMG_GENERIC] = "generic", [DMG_CRUSH] = "crush", [DMG_BULLET] = "bullet",
	[DMG_SLASH] = "slash", [DMG_BURN] = "burn", [DMG_VEHICLE] = "vehicle",
	[DMG_FALL] = "fall", [DMG_BLAST] = "blast", [DMG_CLUB] = "club",
	[DMG_SHOCK] = "shock", [DMG_SONIC] = "sonic", [DMG_ENERGYBEAM] = "energybeam",
	[DMG_DROWN] = "drowning", [DMG_PARALYZE] = "paralyzing", [DMG_NERVEGAS] = "nerve gas",
	[DMG_POISON] = "poison", [DMG_RADIATION] = "radiation", [DMG_ACID] = "acid",
	[DMG_PHYSGUN] = "gravity gun", [DMG_PLASMA] = "plasma", [DMG_DISSOLVE] = "dissolve",
	[DMG_BUCKSHOT] = "buckshot", [DMG_SNIPER] = "sniper"
}

hook.Add("PostEntityTakeDamage", "BREACH.Logs:PostEntityTakeDamage", function(ply, dmginfo)
	if not ply:IsPlayer() then return end

	local damage = math.Round(dmginfo:GetDamage())
	if damage <= 0 then return end
	
	local dmgtype = dmginfo:GetDamageType()
	local damagetype = translatedamagetype[dmgtype] or tostring(dmgtype)
	
	local attacker = dmginfo:GetAttacker()
	local att_admin = (IsValid(attacker) and attacker:IsPlayer()) and BREACH.Logs.FormatPlayer(attacker, false) or "world/nothing"
	local att_user = (IsValid(attacker) and attacker:IsPlayer()) and BREACH.Logs.FormatPlayer(attacker, true) or "world/nothing"

	local f_admin = BREACH.Logs.FormatPlayer(ply, false)
	local f_user = BREACH.Logs.FormatPlayer(ply, true)

	LogBoth(
		string.format("%s took %d %s dmg from %s", f_admin, damage, damagetype, att_admin),
		string.format("%s took %d %s dmg from %s", f_user, damage, damagetype, att_user)
	)
end)

hook.Add("DoPlayerDeath", "BREACH.Logs:DoPlayerDeath", function(ply, attacker, dmginfo)
	local att_admin = (IsValid(attacker) and attacker:IsPlayer()) and BREACH.Logs.FormatPlayer(attacker, false) or "world/nothing"
	local att_user = (IsValid(attacker) and attacker:IsPlayer()) and BREACH.Logs.FormatPlayer(attacker, true) or "world/nothing"

	local f_admin = BREACH.Logs.FormatPlayer(ply, false)
	local f_user = BREACH.Logs.FormatPlayer(ply, true)

	LogBoth(f_admin .. " died from " .. att_admin, f_user .. " died from " .. att_user)
	LogBoth(att_admin .. " killed " .. f_admin, att_user .. " killed " .. f_user)
end)

hook.Add("PlayerSpawn", "BREACH.Logs:PlayerSpawn", function(ply)
	timer.Simple(0, function()
		if not IsValid(ply) then return end
		LogBoth(BREACH.Logs.FormatPlayer(ply, false) .. " spawned", BREACH.Logs.FormatPlayer(ply, true) .. " spawned")
	end)
end)

gameevent.Listen("player_changename")
hook.Add("player_changename", "BREACH.Logs:player_changename", function(data)
	local ply = player.GetByID(data.userid)
	if not IsValid(ply) then return end

	local f_admin = BREACH.Logs.FormatPlayer(ply, false)
	local f_user = BREACH.Logs.FormatPlayer(ply, true)

	LogBoth(f_admin .. " changed their nickname from " .. data.oldname .. " to " .. data.newname, f_user .. " changed their nickname")
end)

hook.Add("PlayerSwitchWeapon", "BREACH.Logs:PlayerSwitchWeapon", function(ply, oldwep, newwep)
	if ply.BREACHLogs_OldWep == oldwep and ply.BREACHLogs_NewWep == newwep then return end 

	ply.BREACHLogs_OldWep = oldwep
	ply.BREACHLogs_NewWep = newwep

	local oldwepstr = IsValid(oldwep) and oldwep:GetClass() or "none"
	local newwepstr = IsValid(newwep) and newwep:GetClass() or "none"

	LogBoth(
		BREACH.Logs.FormatPlayer(ply, false) .. " switched their weapon from " .. oldwepstr .. " to " .. newwepstr,
		BREACH.Logs.FormatPlayer(ply, true) .. " switched their weapon from " .. oldwepstr .. " to " .. newwepstr
	)
end)

hook.Add("BreachLog_DoorOpen", "BREACH.Logs:BreachLog_DoorOpen", function(ply, name)
	LogBoth(BREACH.Logs.FormatPlayer(ply, false) .. " used door " .. (name or ""), BREACH.Logs.FormatPlayer(ply, true) .. " used door " .. (name or ""))
end)

hook.Add("BreachLog_ElevatorUse", "BREACH.Logs:BreachLog_ElevatorUse", function(ply, name)
	LogBoth(BREACH.Logs.FormatPlayer(ply, false) .. " used elevator " .. (name or ""), BREACH.Logs.FormatPlayer(ply, true) .. " used elevator " .. (name or ""))
end)

local ULX_Blacklist = { ["ulx luarun"] = true, ["ulx rcon"] = true }
hook.Add(ULib and ULib.HOOK_COMMAND_CALLED or "ULibCommandCalled", "BREACH.Logs:UlibCommandCalled", function(ply, cmd, args)
	if not args then return end
	if (#args > 0 and ULX_Blacklist[cmd .. " " .. args[1]]) or ULX_Blacklist[cmd] then return end
	
	local f_admin = IsValid(ply) and BREACH.Logs.FormatPlayer(ply, false) or "CONSOLE"
	local f_user = IsValid(ply) and BREACH.Logs.FormatPlayer(ply, true) or "CONSOLE"
	local argss = (#args > 0) and (" " .. table.concat(args, " ")) or ""

	LogBoth(f_admin .. " ran ULX command " .. cmd .. argss, f_user .. " ran ULX command " .. cmd .. argss)
end)

local retranslate = {
	["armor_goc"] = "GOC uniform", ["armor_sci"] = "Scientist uniform", ["armor_mtf"] = "MTF uniform",
	["armor_medic"] = "Medic uniform", ["armor_hazmat_white"] = "White hazmat", ["armor_hazmat_orange"] = "Orange hazmat",
	["armor_hazmat_black"] = "Black hazmat", ["armor_hazmat_yellow"] = "Yellow hazmat", ["armor_hazmat_blue"] = "Blue hazmat",
	["armor_lighthazmat_1"] = "Light white hazmat", ["armor_lighthazmat_2"] = "Light yellow hazmat",
	["chaos"] = "CI uniform", ["recruit"] = "Ethics inspector uniform",
}
hook.Add("BreachLog_PickUpArmor", "BREACH.Logs:BreachLog_PickUpArmor", function(ply, armor)
	local armorName = retranslate[armor] or armor
	LogBoth(BREACH.Logs.FormatPlayer(ply, false) .. " picked up armor: " .. armorName, BREACH.Logs.FormatPlayer(ply, true) .. " picked up armor: " .. armorName)
end)

hook.Add("BreachLog_DropArmor", "BREACH.Logs:BreachLog_DropArmor", function(ply, armor)
	local armorName = retranslate[armor] or armor
	LogBoth(BREACH.Logs.FormatPlayer(ply, false) .. " dropped armor: " .. armorName, BREACH.Logs.FormatPlayer(ply, true) .. " dropped armor: " .. armorName)
end)

hook.Add("BreachLog_PickedUpItem", "BREACH.Logs:BreachLog_PickedUpItem", function(ply, wep)
	local wepstr = IsValid(wep) and wep:GetClass() or "none"
	LogBoth(BREACH.Logs.FormatPlayer(ply, false) .. " picked up " .. wepstr, BREACH.Logs.FormatPlayer(ply, true) .. " picked up " .. wepstr)
end)

hook.Add("PlayerDroppedWeapon", "BREACH.Logs:PlayerDroppedWeapon", function(ply, wep)
	local wepstr = IsValid(wep) and wep:GetClass() or "none"
	LogBoth(BREACH.Logs.FormatPlayer(ply, false) .. " dropped " .. wepstr, BREACH.Logs.FormatPlayer(ply, true) .. " dropped " .. wepstr)
end)

local function PlayerWarned(ply, admin, reason)
	local f_ply_admin = IsValid(ply) and BREACH.Logs.FormatPlayer(ply, false) or tostring(ply)
	local f_ply_user = IsValid(ply) and BREACH.Logs.FormatPlayer(ply, true) or tostring(ply)
	local f_adm_admin = IsValid(admin) and BREACH.Logs.FormatPlayer(admin, false) or tostring(admin)
	local f_adm_user = IsValid(admin) and BREACH.Logs.FormatPlayer(admin, true) or tostring(admin)

	local r_text = (reason and #string.Trim(reason) > 0) and (" for " .. reason) or ""

	LogBoth(f_adm_admin .. " warned " .. f_ply_admin .. r_text, f_adm_user .. " warned " .. f_ply_user .. r_text)
end
hook.Add("AWarnPlayerWarned", "BREACH.Logs:AWarnPlayerWarned", PlayerWarned)
hook.Add("AWarnPlayerIDWarned", "BREACH.Logs:AWarnPlayerIDWarned", PlayerWarned)

hook.Add("AWarnLimitKick", "BREACH.Logs:AWarnLimitKick", function(ply)
	LogBoth(BREACH.Logs.FormatPlayer(ply, false) .. " was kicked for reaching warns limit", BREACH.Logs.FormatPlayer(ply, true) .. " was kicked for reaching warns limit")
end)

hook.Add("AWarnLimitBan", "BREACH.Logs:AWarnLimitBan", function(ply)
	LogBoth(BREACH.Logs.FormatPlayer(ply, false) .. " was banned for reaching warns limit", BREACH.Logs.FormatPlayer(ply, true) .. " was banned for reaching warns limit")
end)

hook.Add("BreachLog_GameRestart", "BREACH.Logs:BreachLog_GameRestart", function()
	LogBoth("Restarting server...")
end)

hook.Add("BreachLog_RoundStart", "BREACH.Logs:BreachLog_RoundStart", function(rounds)
	LogBoth("Restarting round, rounds until server restart: " .. rounds)
end)

hook.Add("BreachLog_EnableGocNuke", "BREACH.Logs:BreachLog_EnableGocNuke", function(ply)
	LogBoth(BREACH.Logs.FormatPlayer(ply, false) .. " enabled warhead", BREACH.Logs.FormatPlayer(ply, true) .. " enabled warhead")
end)

hook.Add("BreachLog_DisableGocNuke", "BREACH.Logs:BreachLog_DisableGocNuke", function(ply)
	LogBoth(BREACH.Logs.FormatPlayer(ply, false) .. " disabled warhead", BREACH.Logs.FormatPlayer(ply, true) .. " disabled warhead")
end)

hook.Add("BreachLog_GocNukeDetonation", "BREACH.Logs:BreachLog_GocNukeDetonation", function()
	LogBoth("Warhead exploded by GOC")
end)

local _query = _query or sql.Query
LOGS_DATABASE_USAGE = LOGS_DATABASE_USAGE or {}

function sql.Query(q)
	if q:find("srv1_gas") then return _query(q) end
	if DEBUG_SHOWQUERY then print('SQL Query: ', q) end
	
	table.insert(LOGS_DATABASE_USAGE, {q, CurTime()})
	
	return _query(q)
end

local _netstart = _netstart or net.Start
function net.Start(messageName, unreliable)
	return _netstart(messageName, unreliable)
end
end