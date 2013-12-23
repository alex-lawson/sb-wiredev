function init()
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
  output(entity.getInboundNodeLevel(0))
end

function output(state)
  storage.state = state
  if state then
    entity.setAnimationState("doorState", "open")
    entity.playSound("openSounds")
    entity.setColliding(false)
  else
    entity.setAnimationState("doorState", "closed")
    entity.playSound("closeSounds")
    entity.setColliding(true)
  end
end