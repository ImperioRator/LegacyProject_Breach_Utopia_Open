local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
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

hook.Add( "RegisterSCP", "RegisterBaseSCPs", function()

	RegisterSCP( "SCP049", "models/cultist/scp/scp_049.mdl", {"weapon_scp_049_redux"}, {
		jump_power = 100,
		no_spawn = true,
		
		base_health = 2500,
		max_health = 2500,
		base_speed = 80,
		run_speed =80,
		max_speed = 80,
		scaledamage = {
				["HITGROUP_HEAD"] = 0.65,
				["HITGROUP_CHEST"] = 0.65,
				["HITGROUP_LEFTARM"] = 0.65,
				["HITGROUP_RIGHTARM"] = 0.65,
				["HITGROUP_STOMACH"] = 0.65,
				["HITGROUP_GEAR"] = 0.65,
				["HITGROUP_LEFTLEG"] = 0.65,
				["HITGROUP_RIGHTLEG"] = 0.65
			},
	}, {
	}, nil, function(ply)
		ply:SetPos(Vector(9465.075195, 2065, 10.031250))
	end )
	RegisterSCP( "SCP106", "models/cultist/scp/scp_106.mdl", {"weapon_scp_106"}, {
		jump_power = 200,
		no_spawn = true,
		scaledamage = {
				["HITGROUP_HEAD"] = 0.6,
				["HITGROUP_CHEST"] = 0.6,
				["HITGROUP_LEFTARM"] = 0.6,
				["HITGROUP_RIGHTARM"] = 0.6,
				["HITGROUP_STOMACH"] = 0.6,
				["HITGROUP_GEAR"] = 0.6,
				["HITGROUP_LEFTLEG"] = 0.6,
				["HITGROUP_RIGHTLEG"] = 0.6
			},
	}, {
		base_health = 4500,
		max_health = 4500,
		base_speed = 100,
		run_speed = 100,
		max_speed = 100,
	}, nil, function(ply)
		ply:SetPos(Vector(6541.768555, 1798.549805, -381))
	end )
	RegisterSCP( "SCP542", "models/cultist/scp/scp_542.mdl", {"weapon_scp_542"}, {
		jump_power = 200,
		prep_freeze = true,
		base_health = 3000,
		
		max_health = 3000,
		base_speed = 150,
		run_speed = 150,
		scaledamage = {
				["HITGROUP_HEAD"] = 0.45,
				["HITGROUP_CHEST"] = 0.45,
				["HITGROUP_LEFTARM"] = 0.45,
				["HITGROUP_RIGHTARM"] = 0.45,
				["HITGROUP_STOMACH"] = 0.45,
				["HITGROUP_GEAR"] = 0.45,
				["HITGROUP_LEFTLEG"] = 0.45,
				["HITGROUP_RIGHTLEG"] = 0.45
			},
		max_speed = 150,
	}, {
	} )

		RegisterSCP( "SCP966", "models/1000shells/scp966/scp_966.mdl", {"weapon_scp_966"}, {
		jump_power = 200,
		prep_freeze = true,
		base_health = 1000,
		
		max_health = 1000,
		base_speed = 150,
		run_speed = 150,
		scaledamage = {
				["HITGROUP_HEAD"] = 0.45,
				["HITGROUP_CHEST"] = 0.45,
				["HITGROUP_LEFTARM"] = 0.45,
				["HITGROUP_RIGHTARM"] = 0.45,
				["HITGROUP_STOMACH"] = 0.45,
				["HITGROUP_GEAR"] = 0.45,
				["HITGROUP_LEFTLEG"] = 0.45,
				["HITGROUP_RIGHTLEG"] = 0.45
			},
		max_speed = 150,
	}, {
	} )

end )

function SetupSCP0761( ply )
	if !IsValid( SCP0761 ) then
		cspawn076 = SPAWN_SCP076
		SCP0761 = ents.Create( "item_scp_0761" )
		SCP0761:Spawn()
		SCP0761:SetPos( cspawn076 )
	end
	ply:SetPos( cspawn076 )
end