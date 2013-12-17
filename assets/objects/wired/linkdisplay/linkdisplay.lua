function init(args)
  -- self.counterStates = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
  -- self.linkStates = {"none", "left", "right", "both"}

  if object.direction() == -1 then
    object.setFlipped(true)
  end

  storage.connectedRight = false
  storage.connectedLeft = false
  updateLinkAnimationState()

  if storage.autoCountEnabled == nil then
    storage.countInterval = object.configParameter("countInterval")
    storage.countCooldown = storage.countInterval
    storage.autoCountEnabled = true
  end

  if storage.countAnimationState == nil then
    storage.countAnimationState = "off"
  end
  updateCountAnimationState()
end

function checkConnections()
  pingLeft()
  pingRight()

  updateLinkAnimationState()

  if storage.count == nil then
    if storage.connectedLeft then
      storage.count = world.callScriptedEntity(storage.connectedLeft, "getCount", {})
    else
      storage.count = 0
    end
  end
end

function isLinkedDisplayAt(pos)
  return pos[1] == math.floor(object.position()[1]) and pos[2] == math.floor(object.position()[2])
end

function getCount()
  return storage.count
end

function setCount(count)
  storage.count = count

  if storage.connectedRight then
    world.callScriptedEntity(storage.connectedRight, "setCount", count)
  end

  storage.autoCountEnabled = false

  return true
end

function pingRight()
  local entityIds = world.entityQuery({object.position()[1] + 2, object.position()[2]}, 1,
     { callScript = "isLinkedDisplayAt", callScriptArgs = { {math.floor(object.position()[1] + 2), math.floor(object.position()[2]) }}, withoutEntityId = object.id()})
  
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
  local entityIds = world.entityQuery({object.position()[1] - 2, object.position()[2]}, 1,
      { callScript = "isLinkedDisplayAt", callScriptArgs = { {math.floor(object.position()[1] - 2), math.floor(object.position()[2]) }}, withoutEntityId = object.id()})

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
  storage.count = args.count

  --take one
  if #args.countChars >= 1 then
    storage.countAnimationState = args.countChars:sub(#args.countChars, #args.countChars)
  else
    storage.countAnimationState = "off"
  end
  updateCountAnimationState()

  --pass to your left
  if storage.connectedLeft then
    world.callScriptedEntity(storage.connectedLeft, "takeOneAndPassToYourLeft", {count = args.count, countChars = args.countChars:sub(1, #args.countChars - 1)})
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

function updateCountAnimationState()
  if object.direction() == 1 then
    object.setAnimationState("counterState", storage.countAnimationState)
  else
    object.setAnimationState("counterState", "flipped."..storage.countAnimationState)
  end
end

function main()
  checkConnections()

  if storage.count then
    if storage.autoCountEnabled then
      if storage.count == nil then storage.count = 0 end

      --TODO: move this to separate counter object
      storage.countCooldown = storage.countCooldown - object.dt()
      if storage.countCooldown <= 0 then
        storage.countCooldown = storage.countCooldown + storage.countInterval

        storage.count = storage.count + 1
      end
    end

    if not storage.connectedRight then
      countStr = string.format("%d", storage.count)
      takeOneAndPassToYourLeft({count = storage.count, countChars = countStr:sub(1, #countStr)})
    end
  end
end