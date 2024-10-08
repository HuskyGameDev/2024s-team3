@tool
extends "../loot_table_row.gd"

const ThistleRootResource = preload("res://common/items/ingredients/thistle_root/thistle_root.tres")

## Ingredients shop table type:
## [ {
##    "id": String (auto generated)
##    "quantity": int,
##    "cost": int,
##    "item": Ingredient
## } ]
var quantity:int
var cost:int
var item:Ingredient


## Gets a string id for either the current object or a data dictionary
func get_id(data = null):
	if data:
		return "%s_%s_%s" % [ data.item.id, str(data.quantity), str(data.cost) ]
	elif item:
		return "%s_%s_%s" % [ item.id, str(quantity), str(cost) ]
	else: return null


func _ready():
	$IngredientDropdown.select_ingredient(item)
	$QuantityInput.value = quantity
	$CostInput.value = cost
	super()


func with_data(rarity:String, table:LootTable, data):
	if data:
		if data.has("item"): self.item = data.get("item")
		else: self.item = ThistleRootResource
		self.quantity = data.get("quantity", 0)
		self.cost = data.get("cost", 0)
	else:
		self.item = ThistleRootResource
		self.quantity = 0
		self.cost = 0
		table[rarity.to_lower()].append({
			"id": get_id(),
			"quantity": quantity,
			"cost": cost,
			"item": item
		})
	return super(rarity, table, data)


func _on_rarity_changed(index):
	# update resource
	var old_rarity = self.rarity.to_lower()
	var new_rarity = Options.get_item_text(index).to_lower()
	var id = get_id()
	table[old_rarity] = table[old_rarity].filter( func(obj): return obj.id != id )
	table[new_rarity].append({
		"id": id,
		"quantity": quantity,
		"cost": cost,
		"item": item
	})
	# emit signal to move row
	rarity_changed.emit(self, old_rarity, new_rarity)
	self.rarity = new_rarity


func _on_ingredient_changed(new_ingredient):
	var old_id = get_id()
	item = new_ingredient
	var new_id = get_id()
	update_resource(old_id, new_id)


func _on_quantity_changed(value):
	var old_id = get_id()
	quantity = value
	var new_id = get_id()
	update_resource(old_id, new_id)


func _on_cost_changed(value):
	var old_id = get_id()
	cost = value
	var new_id = get_id()
	update_resource(old_id, new_id)


func _on_delete_button_pressed():
	var rarity_key = self.rarity.to_lower()
	var id = get_id()
	table[rarity_key] = table[rarity_key].filter( func(obj): return obj.id != id )
	super()


func update_resource(old_id, new_id):
	var rarity_key = self.rarity.to_lower()
	# remove old data
	table[rarity_key] = table[rarity_key].filter( func(obj): return obj.id != old_id )
	# add new data
	table[rarity_key].append({
		"id": new_id,
		"quantity": quantity,
		"cost": cost,
		"item": item
	})
