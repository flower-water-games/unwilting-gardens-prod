# unwilting game

## core scenes

`res://FRESH-FLOWERS/Scenes/MAIN.tscn`

Main scene contains all prefab and level scenes. This should not be directly edited by anyone unless that person is specifically calling out working on it. 

## prefab scenes

Each scene can be individually, one person at a time. all the level layouts are broken out into their own scenes, if you need to edit the scenes do not edit them in MAIN.tscn. 

1. add a `player.tscn` prefab to the scene to test within that scene. 
2. add a `world_environment.tscn` prefab to include the skybox / lighting 
3. add anything else needed to test from the CORE object in the `MAIN.tscn`	

### Main Scene Structure

THe scene is made up strictly of other prefabs. We should never use editable children to edit any of the prefab scenes in the main scene.

The core scenes are located under CORE object. these are all the scenes and objects required for any gameplay scene in game to run. These include the player, the managers, the world environment, and more.

