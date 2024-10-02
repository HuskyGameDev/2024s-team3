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
	var old_rarity = self.rarity.to_lower()
	var new_rarity = $RarityOptions.get_item_text(index).to_lower()
	# remove from old section and add to new
	table[old_rarity].erase(ingredient)
	table[new_rarity].append(ingredient)
	# emit signal to move row
	rarity_changed.emit(self, old_rarity, new_rarity)
	self.rarity = new_rarity


func _on_ingredient_changed(new_ingredient:Ingredient):
	self.ingredient = new_ingredient


func _on_delete_button_pressed():
	table[self.rarity.to_lower()].erase(ingredient)
	super()
