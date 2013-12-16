function init(args)
  self.detectArea = object.configParameter("detectArea")
  self.detectAreaOffset = object.configParameter("detectAreaOffset")
  if type(self.detectArea) == "table" then
    --build rectangle for detection using object position and specified detectAreaOffset
    if type(self.detectAreaOffset) == "table" then
      self.detectArea = {object.position()[1] + self.detectArea[1] + self.detectAreaOffset[1], object.position()[2] + self.detectArea[2] + self.detectAreaOffset[2]}
    else
      self.detectArea = {object.position()[1] + self.detectArea[1], object.position()[2] + self.detectArea[2]}
    end
  end

  if type(self.detectAreaOffset) == "table" then
    self.detectOrigin = {object.position()[1] + self.detectAreaOffset[1], object.position()[2] + self.detectAreaOffset[2]}
  else
    self.detectOrigin = object.position()
  end

  object.setAnimationState("switchState", "off")
end

function onDetect(entityId)
  if entityId then
    local sample = math.floor(world.entityHealth(entityId)[2])
    send(sample)

    object.setAnimationState("switchState", "on")
  else
    send(0)

    object.setAnimationState("switchState", "off")
  end
end

function send(value)
  local entityIds = world.entityLineQuery({object.position()[1] + 2, object.position()[2]}, {object.position()[1] + 2, object.position()[2] + 10}, {
      callScript = "setCount", callScriptArgs = { value } })
end
  

function firstValidEntity(entityIds)
  local validTypes = {"player", "monster", "npc"}

  for i, entityId in ipairs(entityIds) do
    local entityType = world.entityType(entityIds[i])
    for j, validType in ipairs(validTypes) do
      if entityType == validType then return entityId end
    end
  end
  
  return false
end

function main()
  local entityIds = world.entityQuery(self.detectOrigin, self.detectArea, { notAnObject = true, order = "nearest" })
  local nearestValid = firstValidEntity(entityIds)
  onDetect(nearestValid)
end