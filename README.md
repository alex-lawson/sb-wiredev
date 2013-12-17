sb-wiredev
==========

Finished object code and scripts for wire objects to be integrated into Starbound

Finished or Nearly Finished
---
- new scripts (alarm.lua, button.lua, lightsensor.lua, wiretable.lua)
- updated scripts (motiondetector.lua, switch.lua)
- names and generic descriptions for logic gates
- new objects (alarm, lightsensor, pressureplate, smallbackgroundbutton, smallbackgroundswitch)
- wire crafting table object, which also functions as 2 indicator bulbs

Placeholder Content
---

- all images
- recipe costs
- pixel values (though the objects are currently set to not be printable/scannable)

Outstanding Needs
---

- race-specific descriptions?
- determine 'complete' vs 'prototype' object structure (e.g. lightsensor is a full object with its own scripts, pressureplate is built on the motiondetector prototype)
- more complete crafting interface configuration?


Bugs (?)
---

- defining a 'spaces' instead of 'spaceScan' for a wired object orientation prevents proper wire attachment. works when both properties are defined but 'spaceScan' seems to override 'spaces'

Wish List
---

- method to call scripts or api functions on player by id
- method to get id of objects connected by wire nodes
- method to destroy projectiles by id (can this currently be done?)
- argument passed to init() to determine whether the object is being previewed or placed