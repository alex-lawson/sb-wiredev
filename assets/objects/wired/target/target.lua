function onEntityDetected(entityId, entityType)
  if entityType == "projectile" then
    --clean up projectiles that hit targets, not sure whether this a good way to do it
    --world.logInfo(world.callScriptedEntity(entityId, "moveDown", 100))
    object.setColliding(true)
  end
end

function onTick()
  if object.animationState("switchState") == "off" then
    object.setColliding(false)
  end
end