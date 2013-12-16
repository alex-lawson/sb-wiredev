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
  output(object.getInboundNodeLevel(0))
end

function output(state)
  storage.state = state
  if state then
    object.setAnimationState("doorState", "open")
    object.playSound("openSounds")
    object.setColliding(false)
  else
    object.setAnimationState("doorState", "closed")
    object.playSound("closeSounds")
    object.setColliding(true)
  end
end