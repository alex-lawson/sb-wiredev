function init(args)
  object.setInteractive(true)

  if storage.state == nil then
    output(false)
  else
    output(storage.state)
  end

  if storage.timer == nil then
    storage.timer = 0
  end

  self.timeout = object.configParameter("timeout")
end

function onInteraction(args)
  output(true)

  object.playSound("onSounds");
  storage.timer = self.timeout
end

function output(state)
  storage.state = state
  object.setAllOutboundNodes(state)
  if state then
    object.setAnimationState("switchState", "on")
    object.playSound("onSounds");
  else
    object.setAnimationState("switchState", "off")
    object.playSound("offSounds");
  end
end

function main()
  if storage.timer > 0 then
    storage.timer = storage.timer - object.dt()

    if storage.timer <= 0 then
      output(false)
    end
  end
end
