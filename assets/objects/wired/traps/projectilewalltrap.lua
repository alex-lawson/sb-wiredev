function init()
  self.projectile = object.configParameter("projectile")
  self.projectileConfig = object.configParameter("projectileConfig")
  self.projectileSourcePosition = {object.position()[1] + 0.5, object.position()[2] + 0.5}

  self.fireCycle = object.configParameter("fireCycle")
  self.cooldown = 0

  self.state = false

  --janky workaround for orientations being weird
  if world.pointCollision({object.position()[1] - 1, object.position()[2]}, true) then
    self.fireDirection = 1
    
  elseif world.pointCollision({object.position()[1] + 1, object.position()[2]}, true) then
    self.fireDirection = -1
  else
    world.logInfo("this shouldn't be here")
  end

  if self.fireDirection * object.direction() == 1 then
    self.flipStr = ""
  else
    self.flipStr = "flipped."
  end

  updateState()
end

function onInboundNodeChange(args)
  updateState()
end

function onNodeConnectionChange()
  updateState()
end

function updateState()
  if object.getInboundNodeLevel(0) then
    self.cooldown = 0
    self.state = true
    object.setAnimationState("trapState", self.flipStr.."on")
  else
    self.state = false
    object.setAnimationState("trapState", self.flipStr.."off")
  end
end

function fire()
  --pew pew!
  object.playSound("fireSounds")
  world.spawnProjectile(self.projectile, self.projectileSourcePosition, object.id(), {self.fireDirection, 0}, false, self.projectileConfig)
end

function main()
  if self.state then
    self.cooldown = self.cooldown - object.dt()
    if self.cooldown <= 0 then
      self.cooldown = self.cooldown + self.fireCycle
      fire()
    end
  end
end