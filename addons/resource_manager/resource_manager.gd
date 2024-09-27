@tool
extends EditorPlugin

const MainPanel = preload("res://addons/resource_manager/main_panel.tscn")

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


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if main_panel_instance:
		main_panel_instance.visible = visible
		if visible: 
			# initial load ingredient rows
			main_panel_instance.get_node("Ingredients")._on_refresh_button_pressed()


################# Label Appearance ################
func _get_plugin_name() -> String:
	return "Resources"

func _get_plugin_icon() -> Texture2D:
	return get_editor_interface().get_base_control().get_theme_icon("FileList", "EditorIcons")
