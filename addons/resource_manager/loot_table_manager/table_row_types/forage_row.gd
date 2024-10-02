@tool
extends "../loot_table_row.gd"

## Forage table type:
## [ Ingredient ]

var ingredient:Ingredient :
	set(value):
		ingredient = value
		$IngredientDropdown.select_ingredient(ingredient)

func set_data(data: Ingredient):
	self.ingredient = data


func _on_rarity_changed(index):
	var old_key = self.rarity.to_lower()
	var new_key = $RarityOptions.get_item_text(index).to_lower()
	# remove from old section and add to new
	table[old_key].erase(ingredient)
	table[new_key].append(ingredient)
	# call loot_table_row.gd _on_rarity_changed
	super(index)


func _on_ingredient_changed(new_ingredient:Ingredient):
	self.ingredient = new_ingredient
