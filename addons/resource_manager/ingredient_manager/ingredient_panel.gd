@tool
extends Node

const IngredientRow = preload("res://addons/resource_manager/ingredient_manager/ingredient_row.tscn")
const EffectEditor = preload("res://addons/resource_manager/effects_manager/effect_editor_panel.tscn")

@onready var RefreshButton: Button = $TitleHBox/RefreshButton
@onready var AddButton: Button = $AddHBox/AddButton
@onready var AddNameText: LineEdit = $AddHBox/AddNameEdit
@onready var TableBody: VBoxContainer = $TableScrollContainer/TableContainer/TableBody

################# Signal Handling #################
func _on_refresh_button_pressed():
	# Remove all rows
	for child in TableBody.get_children():
		TableBody.remove_child(child)
		child.queue_free()
	# Reload and add all ingredient rows
	for path in ResourcePaths.get_all_ingredient_paths():
		# filter out ingredient variations (chopped, crushed, etc)
		var split_path = path.get_basename().split("/")
		if split_path[-1] != split_path[-2]: continue
		var ingredient_row_instance = IngredientRow.instantiate().with_data(path)
		ingredient_row_instance.connect("open_effect_editor", _on_edit_effect_button_pressed)
		ingredient_row_instance.connect("variant_created", _on_variant_row_created)
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
	ingredient_row_instance.connect("open_effect_editor", _on_edit_effect_button_pressed)
	ingredient_row_instance.connect("variant_created", _on_variant_row_created)
	TableBody.add_child(ingredient_row_instance)


## Called when a new variant of an ingredient is created
func _on_variant_row_created(row:HBoxContainer):
	row.connect("open_effect_editor", _on_edit_effect_button_pressed)


## Called when edit button for an effect is pressed
func _on_edit_effect_button_pressed(ingredient:Ingredient):
	# hide ingredient panel things
	$TitleHBox.visible = false
	$TableScrollContainer.visible = false
	$AddHBox.visible = false
	# add effect editor panel as child
	var editor_panel_instance = EffectEditor.instantiate().with_data(ingredient)
	self.add_child(editor_panel_instance)
	editor_panel_instance.connect("close_editor", _on_effect_panel_back_pressed)


## Called when effect editor back button is pressed
func _on_effect_panel_back_pressed():
	# show ingredient panel things
	$TitleHBox.visible = true
	$TableScrollContainer.visible = true
	$AddHBox.visible = true
	# update collapsed effect views
	for row in TableBody.get_children():
		row.update_effect_summary()
