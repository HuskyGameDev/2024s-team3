extends Control

var description
var label

func _ready():
	top_level = true
	if description:
		$PanelContainer/VBoxContainer/Body.text = description
	if label:
		$PanelContainer/VBoxContainer/Header.text = label


func set_text(new_label, new_description):
	self.description = new_description
	self.label = new_label
	

func _process(_delta):
	global_position = get_global_mouse_position() + Vector2(0, 15)
