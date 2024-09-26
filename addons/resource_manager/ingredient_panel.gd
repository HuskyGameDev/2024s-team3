@tool
extends Node

const IngredientRow = preload("res://addons/resource_manager/ingredient_row.tscn")

@onready var RefreshButton: Button = $TitleHBox/RefreshButton
@onready var AddButton: Button = $AddHBox/AddButton
@onready var AddNameText: LineEdit = $AddHBox/AddNameEdit
@onready var TableBody: VBoxContainer = $TableContainer/TableBody

############# Setup/Teardown Handlers #############
func _ready():
	# Load resources
	_on_refresh_button_pressed()

################# Signal Handling #################
func _on_refresh_button_pressed():
	# Remove all rows
	for child in TableBody.get_children():
		TableBody.remove_child(child)
		child.queue_free()
	# Reload and add all ingredient rows
	for path in ResourcePaths.get_all_ingredient_paths():
		var ingredient_row_instance = IngredientRow.instantiate().with_data(path)
		TableBody.add_child(ingredient_row_instance)


func _on_add_button_pressed():
	# check ingredient has name
	var new_name = AddNameText.text
	if not new_name: return
	AddNameText.text = ""
	
	# create ingredient resource
	var new_ingredient = Ingredient.new()
	new_ingredient.name = new_name
	new_ingredient.id = new_name.to_snake_case()
	var new_path = "res://common/items/ingredients/%s/%s.tres" % [new_ingredient.id, new_ingredient.id]
	DirAccess.make_dir_absolute("res://common/items/ingredients/%s" % new_ingredient.id)
	ResourceSaver.save(new_ingredient, new_path)
	# update resource paths singleton
	ResourcePaths.update_ingredient_paths()
	
	# add row to table
	var ingredient_row_instance = IngredientRow.instantiate().with_data(new_path)
	TableBody.add_child(ingredient_row_instance)
