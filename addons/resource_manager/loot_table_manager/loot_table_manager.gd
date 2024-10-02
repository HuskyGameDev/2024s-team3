@tool
extends Node

const ForageTableRow = preload("res://addons/resource_manager/loot_table_manager/table_row_types/forage_row.tscn")
const IngredientsShopTableRow = preload("res://addons/resource_manager/loot_table_manager/table_row_types/ingredients_shop_row.tscn")
const CustomerRequestTableRow = preload("res://addons/resource_manager/loot_table_manager/table_row_types/customer_request_row.tscn")

# sends signal to location_panel to close loot table editor
signal close_editor

var location:Location
var type:String
var rowScene:PackedScene
var table:LootTable

########################## SETUP ###########################
func with_data(location:Location, type:String):
	self.location = location
	
	self.type = type
	match type:
		"FORAGE": 
			self.rowScene = ForageTableRow
			self.table = location.forage_table
		"INGREDIENTS_SHOP": 
			self.rowScene = IngredientsShopTableRow
			self.table = location.ingredients_shop_table
		"CUSTOMER_REQUEST": 
			self.rowScene = CustomerRequestTableRow
			self.table = location.customer_request_table
	
	if not location.forage_table: location.forage_table = LootTable.new()
	if not location.ingredients_shop_table: location.ingredients_shop_table = LootTable.new()
	if not location.customer_request_table: location.customer_request_table = LootTable.new()
	return self

func _ready():
	if not location: return
	# Update labels
	$Content/Header/LootTableTypeLabel.text = self.type.replace("_", " ").capitalize() + " Table"
	$Content/Header/LocationNameLabel.text = "(%s)" % location.name
	# Load values (instantiate with table data)
	for item in self.table.common: _on_add_row_pressed("Common", item)
	for item in self.table.uncommon: _on_add_row_pressed("Uncommon", item)
	for item in self.table.rare: _on_add_row_pressed("Rare", item)
	for item in self.table.legendary: _on_add_row_pressed("Legendary", item)

##################### EDITOR FUNCTIONS #####################
func _on_back_button_pressed():
	close_editor.emit()
	self.queue_free()

#################### UPDATE TABLE VALUES ###################
func _on_add_row_pressed(rarity:String, data:Variant = null):
	var add_container = $Content/ScrollContainer/MarginContainer/VBoxContainer.get_node("%sVBox" % rarity)
	var row_scene_instance = rowScene.instantiate().with_data(rarity, self.table)
	if data: row_scene_instance.set_data(data)
	row_scene_instance.connect("rarity_changed", _on_row_rarity_changed)
	add_container.add_child(row_scene_instance)


func _on_row_rarity_changed(row:HBoxContainer, old_rarity:String, new_rarity:String):
	var old_container = $Content/ScrollContainer/MarginContainer/VBoxContainer.get_node("%sVBox" % old_rarity.capitalize())
	var new_container = $Content/ScrollContainer/MarginContainer/VBoxContainer.get_node("%sVBox" % new_rarity.capitalize())
	old_container.remove_child(row)
	new_container.add_child(row)
