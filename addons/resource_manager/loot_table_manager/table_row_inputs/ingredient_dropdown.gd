@tool
extends OptionButton

## Functions the same as the default item_selected signal except it returns the actual ingredient
signal ingredient_changed(ingredient:Ingredient)

@export var include_variant_ingredients:bool = true
@export var selected_ingredient:Ingredient

## Add ingredient options
func _ready():
	self.clear()
	var paths = ResourcePaths.get_all_ingredient_paths() if include_variant_ingredients \
				else ResourcePaths.get_all_non_variant_ingredient_paths()
	for path in paths:
		# we use this path name calculation so we don't have to load every ingredient
		# (they are loaded once they're selected)
		var ingredient_name = path.get_file().get_basename().replace("_", " ").capitalize()
		self.add_item(ingredient_name)
	select(0)
	_on_item_selected(0)


func _on_item_selected(index):
	var selected_name = get_item_text(index)
	var selected_id = selected_name.replace(" ", "_").to_lower()
	selected_ingredient = load(ResourcePaths.get_ingredient_path(selected_id))
	ingredient_changed.emit(selected_ingredient)


func select_ingredient(ingredient:Ingredient):
	for i in item_count:
		if get_item_text(i) == ingredient.name:
			select(i); break
