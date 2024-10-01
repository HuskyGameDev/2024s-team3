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

########################## SETUP ###########################
func with_data(location:Location, type:String):
	self.location = location
	
	self.type = type
	match type:
		"FORAGE": self.rowScene = ForageTableRow
		"INGREDIENTS_SHOP": self.rowScene = IngredientsShopTableRow
		"CUSTOMER_REQUEST": self.rowScene = CustomerRequestTableRow
	
	if not location.forage_table: location.forage_table = LootTable.new()
	if not location.ingredients_shop_table: location.ingredients_shop_table = LootTable.new()
	if not location.customer_request_table: location.customer_request_table = LootTable.new()
	return self

func _ready():
	if not location: return
	# Update labels
	$Content/Header/LootTableTypeLabel.text = self.type.replace("_", " ").capitalize() + " Table"
	$Content/Header/LocationNameLabel.text = "(%s)" % location.name
	#TODO Load values
	

##################### EDITOR FUNCTIONS #####################
func _on_back_button_pressed():
	close_editor.emit()
	self.queue_free()

#################### UPDATE TABLE VALUES ###################
func _on_add_row_pressed(rarity:String):
	var add_container = $Content/ScrollContainer/MarginContainer/VBoxContainer.get_node("%sVBox" % rarity)
	var row_scene_instance = rowScene.instantiate().with_data(rarity)
	row_scene_instance.connect("rarity_changed", _on_row_rarity_changed)
	add_container.add_child(row_scene_instance)


func _on_row_rarity_changed(row:HBoxContainer, old_rarity:String, new_rarity:String):
	var old_container = $Content/ScrollContainer/MarginContainer/VBoxContainer.get_node("%sVBox" % old_rarity)
	var new_container = $Content/ScrollContainer/MarginContainer/VBoxContainer.get_node("%sVBox" % new_rarity)
	old_container.remove_child(row)
	new_container.add_child(row)


## Called when edit button for an effect is pressed
func _on_edit_effect_button_pressed(effects:EffectSet):
	# hide ingredient panel things
	$TitleHBox.visible = false
	$TableContainer.visible = false
	$AddHBox.visible = false
	# add effect editor panel as child
	var editor_panel_instance = EffectEditor.instantiate().with_data(ingredient)
	self.add_child(editor_panel_instance)
	editor_panel_instance.connect("close_editor", _on_effect_panel_back_pressed)


## Called when effect editor back button is pressed
func _on_effect_panel_back_pressed():
	# show ingredient panel things
	$TitleHBox.visible = true
	$TableContainer.visible = true
	$AddHBox.visible = true
	# update collapsed effect views
	for row in TableBody.get_children():
		row.update_effect_summary()
