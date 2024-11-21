@tool
extends Node

const LocationRow = preload("res://addons/resource_manager/location_manager/location_row.tscn")
const LootTableEditor = preload("res://addons/resource_manager/loot_table_manager/loot_table_manager.tscn")

@onready var RefreshButton: Button = $TitleHBox/RefreshButton
@onready var AddButton: Button = $AddHBox/AddButton
@onready var AddNameText: LineEdit = $AddHBox/AddNameEdit
@onready var TableBody: VBoxContainer = $BodyScroll/TableBody

################# Signal Handling #################
func _on_refresh_button_pressed():
	# Remove all rows
	for child in TableBody.get_children():
		TableBody.remove_child(child)
		child.queue_free()
	# Reload and add all location rows
	for path in ResourcePaths.get_all_location_paths():
		add_location_row(path)


func _on_add_button_pressed():
	# check location has name
	var new_name = AddNameText.text
	if not new_name: return
	AddNameText.text = ""
	
	# create location resource
	var new_location = Location.new()
	new_location.name = new_name
	new_location.id = new_name.to_snake_case()
	var new_path = "res://common/locations/%s.tres" % new_location.id
	ResourceSaver.save(new_location, new_path)
	# update resource paths singleton
	ResourcePaths.update_location_paths()
	
	add_location_row(new_path)


## Called by _on_refresh_button_pressed and _on_add_button_pressed to add a row to the table
func add_location_row(path:String):
	var location_row_instance = LocationRow.instantiate().with_data(path)
	TableBody.add_child(location_row_instance)
	location_row_instance.connect("open_forage_table_editor", _on_edit_loot_table_button_pressed)
	location_row_instance.connect("open_ingredients_shop_table_editor", _on_edit_loot_table_button_pressed)
	location_row_instance.connect("open_customer_request_table_editor", _on_edit_loot_table_button_pressed)


## Called when edit button for a loot table is pressed
func _on_edit_loot_table_button_pressed(location:Location, type:String):
	# hide location panel things
	$TitleHBox.visible = false
	$BodyScroll.visible = false
	$AddHBox.visible = false
	# add effect editor panel as child
	var loot_table_panel_instance = LootTableEditor.instantiate().with_data(location, type)
	self.add_child(loot_table_panel_instance)
	loot_table_panel_instance.connect("close_editor", _on_edit_panel_back_pressed)


## Called when loot table editor back button is pressed
func _on_edit_panel_back_pressed():
	# show location panel things
	$TitleHBox.visible = true
	$BodyScroll.visible = true
	$AddHBox.visible = true
