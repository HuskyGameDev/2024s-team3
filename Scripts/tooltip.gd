extends Control

func set_text(label, description):
	$PanelContainer/VBoxContainer/Body.text = description
	$PanelContainer/VBoxContainer/Header.text = label
	

func _process(delta):
	global_position = get_global_mouse_position() + Vector2(0, 15)

