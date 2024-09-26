@tool
extends EditorPlugin

const MainPanel = preload("res://addons/resource_manager/main_panel.tscn")
const IngredientRow = preload("res://addons/resource_manager/ingredient_row.tscn")

var main_panel_instance: Control

############# Setup/Teardown Handlers #############
func _enter_tree() -> void:
	main_panel_instance = MainPanel.instantiate()
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)


func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()


func _ready():
	# Load resources
	_on_refresh_button_pressed()
	# Connect refresh button signal
	main_panel_instance.get_node("MainVBox/TitleHBox/RefreshButton").connect("pressed", _on_refresh_button_pressed)
	main_panel_instance.get_node("MainVBox/AddHBox/AddButton").connect("pressed", _on_add_button_pressed)


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if main_panel_instance:
		main_panel_instance.visible = visible


################# Label Appearance ################
func _get_plugin_name() -> String:
	return "Resources"

func _get_plugin_icon() -> Texture2D:
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")

################# Signal Handling #################
func _on_refresh_button_pressed():
	var table_body = main_panel_instance.get_node("MainVBox/TableContainer/TableBody")
	# Remove all rows
	for child in table_body.get_children():
		table_body.remove_child(child)
		child.queue_free()
	# Reload and add all ingredient rows
	for path in ResourcePaths.get_all_ingredient_paths():
		var ingredient_row_instance = IngredientRow.instantiate().with_data(path)
		table_body.add_child(ingredient_row_instance)


func _on_add_button_pressed():
	# check ingredient has name
	var new_name = main_panel_instance.get_node("MainVBox/AddHBox/AddNameEdit").text
	if not new_name: return
	main_panel_instance.get_node("MainVBox/AddHBox/AddNameEdit").text = ""
	
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
	main_panel_instance.get_node("MainVBox/TableContainer/TableBody").add_child(ingredient_row_instance)
