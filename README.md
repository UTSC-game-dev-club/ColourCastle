# ColourCastle

## directory structure
- game: everything tied to individual levels
- off-game: all UI screens for non game scene. Including Main menu, chapter select and loading screen
- player: everything tied to player, including it's raycasts and 3D model
- shaders: shaders used in game, for now it's only used for level connectors
- autoloads: all the autoloads in the game

## multiscene content
In this project, all contents passed in between scenes should be stored through an autoload

## how to swap scene?
A simple call in autoload SceneManager will do the job: `SceneManager.switch_scene(new_scene_enum)`
(via `res://autoloads/scene_manager.gd` for details)

## assumptions for levels:
The dimension of the wall and ground should be <= 250
The camera's positions match with them

## assumptions for player:
Player is a rectangular prism of dimension: 2 * 4 * 2

## todo
- [ ] level transitioning
- [ ] chapter content
- [ ] save load system
- [ ] level select
- [ ] (todo: add more todos)
