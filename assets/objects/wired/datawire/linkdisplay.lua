function init(args)
  -- self.displayCharSet = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-"}
  -- self.linkStates = {"none", "left", "right", "both"}

  if object.direction() == -1 then
    object.setFlipped(true)
  end

  storage.connectedRight = false
  storage.connectedLeft = false
  updateLinkAnimationState()

  -- if storage.autoCountEnabled == nil then
  --   storage.dataInterval = object.configParameter("countInterval")
  --   storage.dataCooldown = storage.dataInterval
  --   storage.autoCountEnabled = true
  -- end

  self.dataFormat = object.configParameter("dataFormat")
  if self.dataFormat == nil then
    self.dataFormat = "%d"
  end

  self.displaySize = object.configParameter("displaySize")
  if self.displaySize == nil then
    --maybe no point to setting a default since this will totally break
    self.displaySize = 1
  end
end

function findAdjacentSegments()
  pingLeft()
  pingRight()

  updateLinkAnimationState()

  if storage.data == nil then
    if storage.connectedLeft then
      storage.data = world.callScriptedEntity(storage.connectedLeft, "getData", {})
    end
  end
end

function isLinkedDisplayAt(pos)
  return pos[1] == math.floor(object.position()[1]) and pos[2] == math.floor(object.position()[2])
end

function validateData(data, nodeId)
  return type(data) == "number"
end

function onValidDataReceived(data, nodeId)
  setData(data)
end

function getData()
  return storage.data
end

function setData(data)
  storage.data = data

  if storage.connectedRight then
    world.callScriptedEntity(storage.connectedRight, "setData", data)
  end

  return true
end

function pingRight()
  local entityIds = world.entityQuery({object.position()[1] + self.displaySize, object.position()[2]}, 1,
     { callScript = "isLinkedDisplayAt", callScriptArgs = { {math.floor(object.position()[1] + self.displaySize), math.floor(object.position()[2]) }}, withoutEntityId = object.id()})
  
  -- world.logInfo(string.format("%d detected %d entities to the right", object.id(), #entityIds))
  -- for i, entityId in ipairs(entityIds) do
  --   world.logInfo(entityId)
  -- end

  if #entityIds == 1 then
    storage.connectedRight = entityIds[1]
  else
    storage.connectedRight = false
  end
end

function pingLeft()
  local entityIds = world.entityQuery({object.position()[1] - self.displaySize, object.position()[2]}, 1,
      { callScript = "isLinkedDisplayAt", callScriptArgs = { {math.floor(object.position()[1] - self.displaySize), math.floor(object.position()[2]) }}, withoutEntityId = object.id()})

  -- world.logInfo(string.format("%d detected %d entities to the left", object.id(), #entityIds))
  -- for i, entityId in ipairs(entityIds) do
  --   world.logInfo(entityId)
  -- end

  if #entityIds == 1 then
    storage.connectedLeft = entityIds[1]
  else
    storage.connectedLeft = false
  end
end

function takeOneAndPassToYourLeft(args)
  storage.data = args.data

  --take one
  local newDisplayData
  if #args.dataString >= 1 then
    newDisplayData = args.dataString:sub(#args.dataString, #args.dataString)
  end
  updateDisplay(newDisplayData)

  --pass to your left
  if storage.connectedLeft then
    world.callScriptedEntity(storage.connectedLeft, "takeOneAndPassToYourLeft", {data = args.data, dataString = args.dataString:sub(1, #args.dataString - 1)})
  end
end

function updateLinkAnimationState()
  if storage.connectedRight and storage.connectedLeft then
    object.setAnimationState("linkState", "both")
  elseif not storage.connectedRight and storage.connectedLeft then
    if object.direction() == 1 then
      object.setAnimationState("linkState", "left")
    else
      object.setAnimationState("linkState", "right")
    end
  elseif storage.connectedRight and not storage.connectedLeft then
    if object.direction() == 1 then
      object.setAnimationState("linkState", "right")
    else
      object.setAnimationState("linkState", "left")
    end
  else
    object.setAnimationState("linkState", "none")
  end
end

function updateDisplay(newDisplayData)
  if newDisplayData and newDisplayData ~= "" then
    if object.direction() == 1 then
      object.setAnimationState("dataState", newDisplayData)
    else
      object.setAnimationState("dataState", "flipped."..newDisplayData)
    end
  else
    object.setAnimationState("dataState", "off")
  end

  storage.currentDisplayData = newDisplayData
end

function main()
  findAdjacentSegments()

  if storage.data then
    -- if storage.autoCountEnabled then
    --   if storage.data == nil then storage.data = 0 end

    --   --TODO: move this to separate counter object
    --   storage.dataCooldown = storage.dataCooldown - object.dt()
    --   if storage.dataCooldown <= 0 then
    --     storage.dataCooldown = storage.dataCooldown + storage.dataInterval

    --     storage.data = (storage.data - 1)-- % 3
    --   end
    -- end

    if not storage.connectedRight then
      world.logInfo(storage.data)
      dataStr = string.format(self.dataFormat, storage.data)
      world.logInfo(dataStr)
      takeOneAndPassToYourLeft({data = storage.data, dataString = dataStr:sub(1, #dataStr)})
    end
  end
end