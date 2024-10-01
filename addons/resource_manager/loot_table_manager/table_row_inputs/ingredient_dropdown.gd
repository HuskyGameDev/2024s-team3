@tool
extends OptionButton


## Add ingredient options
func _ready():
	self.clear()
	for path in ResourcePaths.get_all_ingredient_paths():
		# we use this path name calculation so we don't have to load every ingredient
		# (they are loaded once they're selected)
		var ingredient_name = path.get_file().get_basename().replace("_", " ").capitalize()
		self.add_item(ingredient_name)
