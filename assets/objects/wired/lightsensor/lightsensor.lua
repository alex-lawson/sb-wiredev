function init(args)
  self.detectThresholdHigh = object.configParameter("detectThresholdHigh")
  self.detectThresholdLow = object.configParameter("detectThresholdLow")
end

function send(value)
  local entityIds = world.entityLineQuery({object.position()[1] + 2, object.position()[2]}, {object.position()[1] + 2, object.position()[2] + 10}, {
      callScript = "setCount", callScriptArgs = { value } })
end

function main(args)
  local sample = world.lightLevel(object.position())

  if sample >= self.detectThresholdHigh then
    object.setOutboundNodeLevel(1, true)
    object.setAnimationState("sensorState", "high")
  else
    object.setOutboundNodeLevel(1, false)
  end

  if sample >= self.detectThresholdLow then
    object.setOutboundNodeLevel(0, true)
    object.setAnimationState("sensorState", "low")

    -- TEMPORARY WIRELESS COMMUNICATION WITH LINKDISPLAY
    send(math.floor(sample * 100))
  else
    object.setOutboundNodeLevel(0, false)
    object.setAnimationState("sensorState", "off")

    -- TEMPORARY WIRELESS COMMUNICATION WITH LINKDISPLAY
    send(0)
  end
end