extends Control

var description
var label

func _ready():
	top_level = true
	if description:
		$PanelContainer/VBoxContainer/Body.text = description
	if label:
		$PanelContainer/VBoxContainer/Header.text = label


func set_text(label, description):
	self.description = description
	self.label = label
	

func _process(delta):
	global_position = get_global_mouse_position() + Vector2(0, 15)
