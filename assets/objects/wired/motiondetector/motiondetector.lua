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

  --allow triggering through manual interaction if specified
  object.setInteractive(object.configParameter("manualTrigger") ~= nil and object.configParameter("manualTrigger"))

  object.setAllOutboundNodes(false)
  object.setAnimationState("switchState", "off")
  self.cooldown = 0
end

function trigger()
  object.setAllOutboundNodes(true)
  object.setAnimationState("switchState", "on")
  self.cooldown = object.configParameter("timeout")
end

function onInteraction(args)
  trigger()
end

function validateEntities(entityIds)
  local validTypes = {"player", "monster", "npc"}

  for i, entityId in ipairs(entityIds) do
    local entityType = world.entityType(entityIds[i])
    for j, validType in ipairs(validTypes) do
      if entityType == validType then return true end
    end
  end
  
  return false
end

function main() 
  if self.cooldown > 0 then
    self.cooldown = self.cooldown - object.dt()
  else
    if self.cooldown <= 0 then
      local entityIds = world.entityQuery(self.detectOrigin, self.detectArea, { notAnObject = true })
      if #entityIds > 0 and validateEntities(entityIds) then
        trigger()
      else
        object.setAllOutboundNodes(false)
        object.setAnimationState("switchState", "off")
      end
    end
  end
end