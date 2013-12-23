-- function init(args)
  

--   --call object-specific initialization
--   objInit(args)
-- end

function isDataWireObject()
  return true
end

function onInboundNodeChange(args)
  --do we even do anything with boolean wire signals? have to think about this as an additional data channel
end

function onNodeConnectionChange()
  queryNodes()
end

function queryNodes()
  storage.connectedEntities = {}
  --TODO: build table of connected object ids from wire queries

  --TEMPORARY: connect to objects above on node "1"
  local entitiesAbove = world.entityLineQuery(entity.position(), {entity.position()[1], entity.position()[2] + 10}, {
      callScript = "isDataWireObject", callScriptArgs = { } })

  storage.connectedEntities[0] = entitiesAbove
end

function sendData(data, nodeId)
  if storage.connectedEntities[nodeId] and #storage.connectedEntities[nodeId] > 0 then 
    for i, entityId in ipairs(storage.connectedEntities[nodeId]) do
      world.callScriptedEntity(entityId, "receiveData", { data, nodeId })
    end
  end
end

function receiveData(args)
  local data = args[1]
  local nodeId = args[2]
  
  --TODO: convert entityId to nodeId

  if validateData(data, nodeId) then
    onValidDataReceived(data, nodeId)

    --TODO: remove for production
    -- world.logInfo(string.format("DataWire: object received data"))
    -- world.logInfo(data)
  else
    --TODO: remove for production
    world.logInfo(string.format("DataWire: object received INVALID data"))
    world.logInfo(data)
  end

  return true
end

function validateData(data, nodeId)
  --to be implemented by object
  return true
end

function onValidDataReceived(data, nodeId)
  --to be implemented by object
end

-- function main()


--   --call object-specific updates
--   --objMain()
-- end