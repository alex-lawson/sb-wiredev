function init(args)
  object.setInteractive(true)

  if storage.state == nil then
    output(false)
  else
    output(storage.state)
  end

  if storage.triggered == nil then
    storage.triggered = false
  end
end

function onInteraction(args)
  output(not storage.state)
end

function onInboundNodeChange(args)
  checkInboundNodes()
end

function onNodeConnectionChange(args)
  checkInboundNodes()
end

function checkInboundNodes()
  if object.inboundNodeCount() > 0 and object.getInboundNodeLevel(0) then
    output(not storage.state)
  end
end

function output(state)
  storage.state = state
  if state then
    object.setAnimationState("switchState", "on")
    object.playSound("onSounds");
    object.setAllOutboundNodes(true)
  else
    object.setAnimationState("switchState", "off")
    object.playSound("offSounds");
    object.setAllOutboundNodes(false)
  end
end