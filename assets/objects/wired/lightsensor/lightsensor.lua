function init(args)
  self.detectThresholdHigh = object.configParameter("detectThresholdHigh")
  self.detectThresholdLow = object.configParameter("detectThresholdLow")
end

function main(args)
  if world.lightLevel(object.position()) >= self.detectThresholdHigh then
    object.setAllOutboundNodes(true)
    object.setAnimationState("sensorState", "high")
  else
    object.setOutboundNodeLevel(1, false)
    if world.lightLevel(object.position()) >= self.detectThresholdLow then
      object.setOutboundNodeLevel(0, true)
      object.setAnimationState("sensorState", "low")
    else
      object.setOutboundNodeLevel(1, false)
      object.setAnimationState("sensorState", "off")
    end
  end
end