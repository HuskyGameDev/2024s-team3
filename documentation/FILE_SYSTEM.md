# Naming Conventions

- Folders and files should be named using `snake_case`
- Nodes should be named using `PascalCase`

Recommended: [Godot Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)


# File Structure

When possible, all scripts, images, scenes, etc. for a single part of the game
should be in the same folder.

There are some root level folders that contain the following:
	- autoloads: scripts that are autoloaded by the game
	- documentation: files that explain things about the project or game
	- scenes: scenes where the player is able to play the game (the hut, the ingredient shop, etc.)
	- tools: editor tools
	- ui: UI elements that are reused in multiple places

All items that are only used in one scene will be under that scene's folder.
This includes things that have a root level folder (for example, the inventory
drawer that's shown in the main store is under `/scenes/main/ui`, not under the
root `ui` folder).

Finally, things that are common to all scenes (ingredients, potions, and locations)
are stored in `/scenes/common`.
