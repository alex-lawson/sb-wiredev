function init(args)
  self.detectThresholdHigh = entity.configParameter("detectThresholdHigh")
  self.detectThresholdLow = entity.configParameter("detectThresholdLow")

  queryNodes()
end

function getSample()
  --to be implemented by sensor
  return false
end

function main(args)
  queryNodes()

  local sample = getSample()
  sendData(sample, 0)

  if sample >= self.detectThresholdLow then
    entity.setOutboundNodeLevel(0, true)
    entity.setAnimationState("sensorState", "med")
  else
    entity.setOutboundNodeLevel(0, false)
    entity.setAnimationState("sensorState", "min")
  end

  if sample >= self.detectThresholdHigh then
    entity.setOutboundNodeLevel(1, true)
    entity.setAnimationState("sensorState", "max")
  else
    entity.setOutboundNodeLevel(1, false)
  end
end