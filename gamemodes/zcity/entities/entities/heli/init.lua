AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.CurrentFrame = 1
ENT.AutomaticFrameAdvance = true
ENT.IsDriving = true
ENT.HeliHealth = 2000

ENT.AnimationFrames = {
    {Vector(-4259.7104492188, -9853.466796875, 7742.6123046875), Angle(18.445833, 155, 0.000000)},
    {Vector(-4396.3129882813, -10219.21484375, 7634.955078125), Angle(18.445833, 150, 0.000000)},
    {Vector(-4501.5703125, -10504.157226563, 7551.5517578125), Angle(18.445833, 145, 0.000000)},
    {Vector(-4625.033203125, -10828.775390625, 7456.8354492188), Angle(18.445833, 140, 0.000000)},
    {Vector(-4750.3149414063, -11129.575195313, 7369.0234375), Angle(18.445833, 135, 0.000000)},
    {Vector(-4876.8666992188, -11406.143554688, 7287.16796875), Angle(18.445833, 130, 0.000000)},
    {Vector(-5013.2641601563, -11677.614257813, 7204.037109375), Angle(18.445833, 125, 0.000000)},
    {Vector(-5178.2055664063, -11957.110351563, 7112.0317382813), Angle(18.445833, 120, 0.000000)},
    {Vector(-5343.6845703125, -12183.345703125, 7029.4233398438), Angle(18.445833, 115, 0.000000)},
    {Vector(-5597.4228515625, -12413.731445313, 6923.0390625), Angle(18.445833, 110, 0.000000)},
    {Vector(-5852.2626953125, -12549.310546875, 6780.03125), Angle(0, 90, 0.000000)},
}

ENT.EscapeAnimationFrames = {
	{Vector(-5852.2626953125, -12549.310546875, 6780.03125), Angle(0, 90, 0.000000)},
	{Vector(-5852.2626953125, -12549.310546875, 6790.03125), Angle(0, 87, 0.000000)},
	{Vector(-5852.2626953125, -12549.310546875, 6800.03125), Angle(0, 85, 0.000000)},
    {Vector(-5880.8408203125, -12502.782226563, 6979.2221679688), Angle(0, 80, 0.000000)},
    {Vector(-5958.9736328125, -12436.532226563, 7041.7143554688), Angle(0, 80, 0.000000)},
    {Vector(-6046.873046875, -12362.000976563, 7112.0180664063), Angle(0, 70, 0.000000)},
    {Vector(-6144.2041015625, -12278.7421875, 7190.0756835938), Angle(0, 60, 0.000000)},
    {Vector(-6227.2416992188, -12198.669921875, 7260.1025390625), Angle(0, 50, 0.000000)},
    {Vector(-6311.0717773438, -12085.654296875, 7345.603515625), Angle(0, 40, 0.000000)},
    {Vector(-6400.787109375, -11898.392578125, 7388.7524414063), Angle(0, 30, 0.000000)},
    {Vector(-6492.7495117188, -11624.46484375, 7528.1596679688), Angle(0, 25, 0.000000)},
    {Vector(-6573.2700195313, -11283.3046875, 7745.4487304688), Angle(0, 20, 0.000000)},
    {Vector(-6682.7368164063, -10842.763671875, 7643.0981445313), Angle(0, 15, 0.000000)},
    {Vector(-6843.7041015625, -10407.516601563, 7628.8295898438), Angle(0, 10, 0.000000)},
    {Vector(-7024.2026367188, -9910.4765625, 7688.5805664063), Angle(0, 5, 0.000000)},
    {Vector(-7139.8896484375, -9582.119140625, 7743.7504882813), Angle(0, 1, 0.000000)},
}

function ENT:LinearMotion(endpos, speed, islast)
if !IsValid(self) then return end
	timer.Remove(self:GetClass().."_linear_motion")
	local ratio = 0
	local time = 0
	local startpos = self:GetPos()
	timer.Create(self:GetClass().."_linear_motion", FrameTime(), 9999999999999, function()
		if !IsValid(self) then return end
	    ratio = speed + ratio
	    time = time + FrameTime()
	    self:SetPos(LerpVector(ratio, startpos, endpos))
	    if self:GetPos():DistToSqr(endpos) < 1 then
	    	self:SetPos(endpos)
	    end
	    if self:GetPos() == endpos then
	    	timer.Remove(self:GetClass().."_linear_motion")
	    	if islast and !isfunction(islast) then
	    		self.PropellerSound:Stop()
	    		local physobj = self:GetPhysicsObject()
				if IsValid(physobj) then physobj:EnableMotion(false) end
	    		self.IsFlying = false
	    		self.IsDriving = false
	    		self:SetBodygroup(2,0)
	    		self:SetBodygroup(3,1)
	    		self:ChangeRotating()
	    		self:AddGestureSequence(self:LookupSequence("door_open"), false)
				self:EmitSound("nextoren/vo/chopper/chopper_evacuate_start_"..math.random(1,7)..".wav", 110, 100, 1.2, CHAN_VOICE, 0, 0)
			elseif isfunction(islast) then
				islast()
			end
	    end
	end)
end

function ENT:LinearAngle(endangle, speed)
if !IsValid(self) then return end
	timer.Remove(self:GetClass().."_linear_angle")
    local ratio = 0
    local startangle = self:GetAngles()
    local startangle_tovector = Vector(startangle[1], startangle[2], startangle[3])
    local endangle_tovector = Vector(endangle[1], endangle[2], endangle[3])
    timer.Create(self:GetClass().."_linear_angle", FrameTime(), 9999999999999, function()
        if !IsValid(self) then return end
        ratio = math.min(ratio + speed, 1)
        self:SetAngles(LerpAngle(ratio, startangle, endangle))
        if startangle_tovector:DistToSqr(endangle_tovector) < 1 then
            self:SetAngles(endangle)
        end
        if self:GetAngles() == endangle then
            timer.Remove(self:GetClass().."_linear_angle")
            return true
        end
    end)
end

function ENT:ChangeRotating(start)
	local unid = "change_playback_"..self:EntIndex()
	timer.Create(unid, FrameTime(), 0, function()
		if !IsValid(self) or (!start and self:GetPlaybackRate() <= 0) or (start and self:GetPlaybackRate() >= 1) then
			timer.Remove(unid)
			return
		end
		if start then
			self:SetPlaybackRate(math.Approach(self:GetPlaybackRate(), 1, FrameTime()/2))
		else
			self:SetPlaybackRate(math.Approach(self:GetPlaybackRate(), 0, FrameTime()/2))
		end
	end)
end

function ENT:Explode(tem)
	if self.Blownup then return end
	local pos = self:GetPos()
	local dmg = 625
	local dmgowner = self
	self.Blownup = true

	for i = 2, #self.AnimationFrames do
		timer.Remove("helicopter__anim_"..tostring(i))
	end

	if !self.IsFlying then
		ParticleEffect("gas_explosion_main", self:GetPos(), Angle(0,0,0), game.GetWorld())
		BroadcastLua("ParticleEffect(\"gas_explosion_main\", Vector("..tostring(self:GetPos().x)..", "..tostring(self:GetPos().y)..", "..tostring(self:GetPos().z).."), Angle(0,0,0), game.GetWorld())")
		local dmginfo = DamageInfo()
		dmginfo:SetDamageType(DMG_BLAST)
		dmginfo:SetDamage(450)
		local savepos = self:GetPos()
		sound.Play( "bullet/explode/large_4.wav", savepos, 125, 100, 1.3 )
		self:Remove()
		util.BlastDamageInfo(dmginfo, savepos, 1450)
	else
		local filt = RecipientFilter()
		filt:AddAllPlayers()
        
        timer.Simple(0, function()
            if IsValid(self) then
                self:SetCollisionGroup(COLLISION_GROUP_WORLD)
            end
        end)
		
		self.PropellerSound:Stop()
		self.PropellerSound = CreateSound(self, "nextoren/others/helicopter/apache_damage_alarm.wav", filt)
		self.PropellerSound:Play()

		local fallpos = (isfunction(GroundPos) and GroundPos(self:GetPos())) or (self:GetPos() - Vector(0,0,1000))
		self:LinearMotion(fallpos, 0.02, function()
			ParticleEffect("gas_explosion_main", self:GetPos(), Angle(0,0,0), game.GetWorld())
			BroadcastLua("ParticleEffect(\"gas_explosion_main\", Vector("..tostring(self:GetPos().x)..", "..tostring(self:GetPos().y)..", "..tostring(self:GetPos().z).."), Angle(0,0,0), game.GetWorld())")
			local dmginfo = DamageInfo()
			dmginfo:SetDamageType(DMG_BLAST)
			dmginfo:SetDamage(450)
			local savepos = self:GetPos()
			sound.Play( "bullet/explode/large_4.wav", savepos, 125, 100, 1.3 )
			self.NOMOREEXPLOSIONS = true
			self:Remove()
			util.BlastDamageInfo(dmginfo, savepos, 1450)
		end)
		self:Ignite(1000)

		local _timername = "Helicopter_Crush_Animation_"..self:EntIndex()
		timer.Create(_timername, FrameTime(), 999999, function()
			if IsValid(self) then
				local curang = self:GetManipulateBoneAngles(0)
				local curpos = self:GetManipulateBonePosition(0)
				local yaw = math.Clamp(curang.yaw + math.random(0.5, 2), 0, 360)
				if yaw == 360 then yaw = -3.5 end
				self:ManipulateBonePosition(0, Vector(curpos.x, math.Clamp(curpos.y + math.random(0.5, 2), 0, 70), curpos.z))
				self:ManipulateBoneAngles(0, Angle(0, math.Clamp(curang.yaw + math.random(0.5, 2), 0, 360), math.Clamp(curang.roll + math.random(0.5, 2), 0, 90)))
			else
				timer.Remove(_timername)
			end
		end)
		self.IsBroken = true
	end

	for _, ply in pairs(player.GetAll()) do
		if ply:GTeam() == tem then
			ply:RXSENDNotify("l:ci_choppa_down")
			ply:AddToStatistics("l:choppa_bonus", 100)
		end
	end
end

function ENT:Touch(ply)
	if !IsValid(ply) then return end
	if !ply:IsPlayer() then return end
	if ply:GTeam() == TEAM_SPEC then return end
	if !ply:Alive() or ply:Health() <= 0 then return end
	if self.IsDriving != true then return end
	ply:Kill()
end

function ENT:OnTakeDamage( dmginfo )
	if self.NOMOREEXPLOSIONS or self.Blownup then return end
	
    local attacker = dmginfo:GetAttacker()
    local inflictor = dmginfo:GetInflictor()

    if IsValid(attacker) and not attacker:IsPlayer() then
        local owner = attacker:GetOwner()
        if IsValid(owner) and owner:IsPlayer() then
            attacker = owner
        elseif IsValid(inflictor) and inflictor:IsPlayer() then
            attacker = inflictor
        end
    end

    if not IsValid(attacker) or not attacker:IsPlayer() then return dmginfo:GetDamage() end

    local team = attacker:GTeam()
    local isBlast = dmginfo:IsDamageType(DMG_BLAST) or dmginfo:GetDamageType() == DMG_CLUB

	if isBlast and team == TEAM_CHAOS then
		self:Explode(TEAM_CHAOS)
	elseif isBlast and team == TEAM_GRU then
		self:Explode(TEAM_GRU)
	elseif team == TEAM_GRU then
		if GRU_Objective != "Срыв эвакуации" then
			attacker:RXSENDNotify(Color(255,0,0), "l:gru_psycho_pt1 ", color_white, "l:gru_psycho_pt2")
			return
		end
		self.HelicopterHealth = self.HelicopterHealth - dmginfo:GetDamage()
		if self.HelicopterHealth <= 0 then
			self:Explode(TEAM_GRU)
		end
	end
	return dmginfo:GetDamage()
end

function ENT:Initialize()
    self:SetModel("models/scp_helicopter/resque_helicopter.mdl")
    self:SetMoveType(MOVETYPE_NONE)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetTrigger(true)

    self.IsFlying = true
    self.HelicopterHealth = self.HeliHealth
    self.IsBroken = false
    self.HeliState = 0 
    
    self.Velocity = Vector(0,0,0)
    self.SmoothedDesiredVel = Vector(0,0,0) 
    
    self.CurrentAngles = self.AnimationFrames and self.AnimationFrames[1][2] or Angle(0,0,0)
    self.GhostPos = self.AnimationFrames and self.AnimationFrames[1][1] or self:GetPos()
    self.GhostIndex = 2
    
    local filt = RecipientFilter()
    filt:AddAllPlayers()
    self.PropellerSound = CreateSound(self, "nextoren/others/helicopter/helicopter_propeller.wav", filt)
    self.PropellerSound:Play()

    if self.AnimationFrames then
        self:SetPos(self.AnimationFrames[1][1])
        self:SetAngles(self.AnimationFrames[1][2])
    end

    self:ResetSequence(self:LookupSequence("rotating"))
    self:ResetSequenceInfo()
    self:SetBodygroup(2, 3)

    local physobj = self:GetPhysicsObject()
    if IsValid(physobj) then 
        physobj:EnableMotion(false) 
        physobj:Sleep()
    end

    local remembername = "Frame_Advance_"..self:EntIndex()
    timer.Create(remembername, FrameTime(), 0, function()
        if IsValid(self) then self:FrameAdvance() else timer.Remove(remembername) end
    end)
end

function ENT:Escape()
    if self.HeliState == 5 or self.Blownup or self.IsBroken then return end

    self:AddGestureSequence(self:LookupSequence("door_close"), false)
    self:ChangeRotating(true)

    timer.Simple(1.5, function()
        if not IsValid(self) then return end
        self.PropellerSound:Play()
        self:SetBodygroup(2, 3)
        self:SetBodygroup(4, 0)

        self.GhostIndex = 2 
        self.HeliState = 5 
        
        self.IsFlying = true
        
        self.GhostPos = self:GetPos() 
        self.Velocity = Vector(0,0,0)
        self.SmoothedDesiredVel = Vector(0,0,0)
    end)
end

function ENT:Think()
    if not self.CurrentAngles then self.CurrentAngles = self:GetAngles() end
    if not self.Velocity then self.Velocity = Vector(0,0,0) end
    if not self.SmoothedDesiredVel then self.SmoothedDesiredVel = Vector(0,0,0) end
    if not self.GhostPos then self.GhostPos = self:GetPos() end
    if not self.GhostIndex then self.GhostIndex = 2 end
    if not self.HeliState then self.HeliState = 0 end

    local curPos = self:GetPos()
    local ang = self:GetAngles()

    local pos1, pos2 = curPos + ang:Forward() * -450 + ang:Right() * -150 + ang:Up() * -150,
                       curPos + ang:Forward() * 350 + ang:Right() * 150 + ang:Up() * 150
                       
    for k, v in ipairs(ents.FindInBox(pos1, pos2)) do
        local cls = v:GetClass()
        if (cls:find("rpg_projectile") or cls:find("cw_kk_ins2_projectile")) and not v.HeliIntercepted then
            v.HeliIntercepted = true
            
            local owner = v:GetOwner()
            
            timer.Simple(0, function()
                if IsValid(v) then
                    if v.selfDestruct then v:selfDestruct() else v:Remove() end
                end
            end)

            local dmg = DamageInfo()
            dmg:SetDamageType(DMG_BLAST)
            dmg:SetDamage(1000)
            dmg:SetAttacker(IsValid(owner) and owner or v)
            dmg:SetInflictor(v)
            self:TakeDamageInfo(dmg)
        end
    end

    if !self.RotorWash then
        self.RotorWash = ents.Create("env_rotorwash_emitter")
        self.RotorWash:SetPos(curPos)
        self.RotorWash:SetParent(self)
        self.RotorWash:Activate()
    end

    if not self.IsBroken and not self.Blownup then
        local FT = FrameTime()
        if FT > 0.05 then FT = 0.05 end

        local activePath = (self.HeliState == 5) and self.EscapeAnimationFrames or self.AnimationFrames
        if not activePath then return true end
        
        local targetNode = activePath[self.GhostIndex]
        local prevNode = activePath[self.GhostIndex - 1] or activePath[1]
        
        local ghostTarget = curPos
        local ghostTargetYaw = self.CurrentAngles.y 
        local ghostSpeed = 0

        if targetNode then
            ghostTarget = targetNode[1]
            
            local distTotal = prevNode[1]:Distance(targetNode[1])
            local distTraveled = prevNode[1]:Distance(self.GhostPos)
            local fraction = distTotal > 0.1 and math.Clamp(distTraveled / distTotal, 0, 1) or 1
            ghostTargetYaw = LerpAngle(fraction, prevNode[2], targetNode[2]).y
            
            if self.HeliState == 0 then ghostSpeed = 200 
            elseif self.HeliState == 1 then ghostSpeed = 150 
            elseif self.HeliState == 2 then ghostSpeed = 80 
            elseif self.HeliState == 5 then ghostSpeed = 300 end

            local dir = ghostTarget - self.GhostPos
            local step = ghostSpeed * FT
            
            if dir:Length() > step then
                self.GhostPos = self.GhostPos + dir:GetNormalized() * step
            else
                self.GhostPos = ghostTarget
            end
            
            local distToNode = self.GhostPos:Distance(ghostTarget)
            
            local switchDistance = math.min(300, distTotal * 0.8)
            if self.HeliState == 2 then switchDistance = 5 end

            if distToNode <= switchDistance then
                if self.GhostIndex < #activePath then
                    self.GhostIndex = self.GhostIndex + 1
                    if self.HeliState == 0 and self.GhostIndex == #activePath then
                        self.HeliState = 1 
                    end
                elseif self.HeliState == 5 then
                    self:Remove()
                    return
                end
            end
        end

        local finalPos = activePath[#activePath][1]
        if self.HeliState == 1 and curPos:Distance(finalPos) < 200 then 
            self.HeliState = 2 
        end
        
        if self.HeliState == 2 then
            local flatDist = Vector(curPos.x, curPos.y, 0):Distance(Vector(finalPos.x, finalPos.y, 0))
            if flatDist < 30 and curPos.z <= finalPos.z + 5 then
                self.HeliState = 3
                
                self.IsFlying = false
                self.IsDriving = false
                
                self:SetPos(finalPos)
                self.Velocity = Vector(0,0,0)
                self.SmoothedDesiredVel = Vector(0,0,0)
                self.CurrentAngles = targetNode[2] 
                self.PropellerSound:Stop()
                self:SetBodygroup(1, 1)
                self:SetBodygroup(2, 0)
                self:SetBodygroup(3, 1)
                self:ChangeRotating()
                self:AddGestureSequence(self:LookupSequence("door_open"), false)
                self:EmitSound("nextoren/vo/chopper/chopper_evacuate_start_"..math.random(1,7)..".wav", 110, 100, 1.2, CHAN_VOICE, 0, 0)
            end
        end

        local posError = self.GhostPos - curPos
        local reaction = (self.HeliState == 5) and 1.2 or 1.8 
        local rawDesiredVelocity = posError * reaction 
        
        local maxHeliSpeed = (self.HeliState == 2) and 150 or 300
        if rawDesiredVelocity:Length() > maxHeliSpeed then
            rawDesiredVelocity = rawDesiredVelocity:GetNormalized() * maxHeliSpeed
        end

        self.SmoothedDesiredVel = LerpVector(FT * 1.5, self.SmoothedDesiredVel, rawDesiredVelocity)

        local damping = (self.HeliState == 2) and 2.5 or 1.5 
        local newVelocity = LerpVector(FT * damping, self.Velocity, self.SmoothedDesiredVel)
        self.Velocity = newVelocity 

        if self.HeliState ~= 3 then
            local accelVector = (self.SmoothedDesiredVel - self.Velocity)
            local flatYawAng = Angle(0, ghostTargetYaw, 0)
            
            local fwdForce = accelVector:Dot(flatYawAng:Forward())
            local rightForce = accelVector:Dot(flatYawAng:Right())

            local basePitch = targetNode and targetNode[2].p or 0
            local baseRoll = targetNode and targetNode[2].r or 0

            local dynPitch = math.Clamp(fwdForce * 0.015, -35, 35)
            local dynRoll = math.Clamp(rightForce * 0.015, -35, 35)

            local targetPitch = basePitch + dynPitch
            local targetRoll = baseRoll + dynRoll

            if self.HeliState == 1 or self.HeliState == 2 then
                targetPitch = basePitch + math.Clamp(dynPitch, -15, 10)
                targetRoll = baseRoll + math.Clamp(dynRoll, -15, 15)
            end

            local targetAng = Angle(targetPitch, ghostTargetYaw, targetRoll)
            self.CurrentAngles = LerpAngle(FT * 2.5, self.CurrentAngles, targetAng)

            local nextPos = curPos + (self.Velocity * FT)

            if (self.HeliState == 1 or self.HeliState == 2) and nextPos.z < finalPos.z then
                nextPos.z = finalPos.z
                self.Velocity.z = math.max(self.Velocity.z, 0)
            end

            self:SetPos(nextPos)
            self:SetAngles(self.CurrentAngles)
        end
    end

    self:NextThink(CurTime() + FrameTime())
    return true
end