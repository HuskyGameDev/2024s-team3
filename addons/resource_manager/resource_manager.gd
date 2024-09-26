@tool
extends EditorPlugin

const MainPanel = preload("res://addons/resource_manager/main_panel.tscn")
const IngredientRow = preload("res://addons/resource_manager/ingredient_row.tscn")

var main_panel_instance: Control


func _enter_tree() -> void:
	main_panel_instance = MainPanel.instantiate()
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)


func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()


func _ready():
	for path in ResourcePaths.get_all_ingredient_paths():
		var ingredient:Ingredient = load(path)
		var ingredient_row_instance = IngredientRow.instantiate()
		ingredient_row_instance.ingredient = ingredient
		main_panel_instance.get_node("TableBody").add_child(ingredient_row_instance)


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if main_panel_instance:
		main_panel_instance.visible = visible

func _handles(object):
	return is_instance_of(object, preload("res://common/items/ingredients/ingredient_type.gd"))


func _get_plugin_name() -> String:
	return "Resources"


func _get_plugin_icon() -> Texture2D:
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")
