function init(args)
  self.alarmSoundCooldown = 1
  self.alarmSoundDuration = object.configParameter("alarmSoundDuration")

  if storage.state == nil then
    output(false)
  else
    output(storage.state)
  end
end

function onInboundNodeChange()
  checkInboundNodes()
end

function onNodeConnectionChange()
  checkInboundNodes()
end

function checkInboundNodes()
  if object.getInboundNodeLevel(0) then
    output(true)
  end
end

function output(state)
  storage.state = state
  if state then
    self.alarmSoundCooldown = 0
    object.setAnimationState("alarmState", "on")
    --TODO set light state
  else
    object.setAnimationState("alarmState", "off")
    --TODO set light state
  end
end

function main(args)
  if object.getInboundNodeLevel(0) then
    self.alarmSoundCooldown = self.alarmSoundCooldown - object.dt()
    if self.alarmSoundCooldown <= 0 then
      object.playSound("alarmSounds")
      self.alarmSoundCooldown = self.alarmSoundDuration
    end
  else
    output(false)
  end
end