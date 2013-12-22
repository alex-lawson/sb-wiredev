function init(args)
  self.detectThresholdHigh = object.configParameter("detectThresholdHigh")
  self.detectThresholdLow = object.configParameter("detectThresholdLow")

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
    object.setOutboundNodeLevel(0, true)
    object.setAnimationState("sensorState", "med")
  else
    object.setOutboundNodeLevel(0, false)
    object.setAnimationState("sensorState", "min")
  end

  if sample >= self.detectThresholdHigh then
    object.setOutboundNodeLevel(1, true)
    object.setAnimationState("sensorState", "max")
  else
    object.setOutboundNodeLevel(1, false)
  end
end