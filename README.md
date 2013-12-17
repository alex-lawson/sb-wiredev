sb-wiredev
==========

Object code and scripts for wire objects to be integrated into Starbound

Object / Script Status
---

- Wire Table (used to craft wire-related recipes, also a wired object useful for testing outputs!)
    - created new script and object /objects/generic/wiretable
    - TODO: change this object type back to its default and un-kludge when scripting/wiring other object types is supported
    - created interface configuration /interface/windowconfig/wiretable.config
    - TODO: properly configure interface and figure out appropriate tags
    - NEED: graphics, recipe, descriptions, costs
- Logic Gates
    - added descriptions and names for default logic gates in /objects/logic
    - NEED: recipes, race-specific descriptions (?), costs
- Alarm
    - created script /objects/wired/alarm/alarm.lua for a triggered alarm which plays sound and changes animation state
    - created sample object /objects/samples/alarm
    - TODO: should also toggle a light source when that functionality is available
    - NEED: properly implemented objects for this template (graphics, recipe, descriptions, costs)
- Switch
    - reworked script /objects/wired/switch/switch.lua to accept input as well as output (switch will toggle when power cycled)
    - created sample object /objects/samples/smallbackgroundswitch
    - TODO: maybe integrate momentary button functionality in this script?
- Button
    - created script /objects/wired/button/button.lua to manage momentary switches
    - created sample object /objects/samples/smallbackgroundbutton
    - TODO: should this be merged into switch.lua and controlled via configParameters?
    - NEED: properly implemented objects for this template (graphics, recipe, descriptions, costs)
- Trapdoor
    - created a simplified script /objects/wired/trapdoor/trapdoor.lua which is better suited than door.lua for unidirectional doors
    - TODO: generalize this to be more widely applicable, add more functionality/options
    - created animation /objects/wired/trapdoor/trapdoor.lua
    - TODO: possibly rename/reconfigure frames depending on desired framecount and naming convention
    - created sample object /objects/samples/trapdoor
    - NEED: properly implemented objects for this template (graphics, recipe, descriptions, costs)
- Motion Detector
    - reworked script /objects/wired/motiondetector/motiondetector.lua to be more flexible/configurable from object properties
    - created sample object /objects/samples/pressureplate which implements this script
- Target (entity detector which triggers when hit by projectiles)
    - created script /objects/wired/target/target.lua which extends the functionality of motiondetector.lua
    - created sample object /objects/samples/wiredtarget
    - TODO: improve collision - currently toggles collidable to catch projectiles and doesn't behave satisfactorily
    - NEED: properly implemented objects for this template (graphics, recipe, descriptions, costs)
- Light Sensor (detects multiple and numeric light levels)
    - created new script and object /objects/wired/lightsensor
    - TODO: currently this object 'sends' data by calling scripts in a line above it to interface with linkdisplay; should use better method
    - NEED: graphics, recipe, descriptions, costs
- Scale (measures max hp of entities which stand on it)
    - created new script and object /objects/wired/scale
    - TODO: currently this object 'sends' data by calling scripts in a line above it to interface with linkdisplay; should use better method
    - TODO: possible make this extend from motiondetector.lua
    - NEED: guidance on if/how this should be integrated
    - NEED: graphics, recipe, descriptions, costs
- Linked Display (multi-segment numerical display communicates with adjacent segments to display large numbers)
    - created new script and object /objects/wired/linkdisplay
    - TODO: determine a better way to communicate with this display, currently Light Sensor and Scale will address a display when placed below it
    - NEED: guidance on if/how this should be integrated
    - NEED: graphics, recipe, descriptions, costs

Bugs (or potential bugs)
---

- the 'spaces' object collision type can prevent wires from attaching to an object when the object's imagePosition and/or animationPosition are [0, 0]
- the 'spaceScan' object collision type can pick up extra collidable blocks in an animation file (needs more investigation)

Wish List
---

- method to call scripts or api functions on player by id
- method to get id of objects connected by wire nodes
- method to destroy projectiles by id (can this currently be done?)
- argument passed to init() to determine whether the object is being previewed or placed