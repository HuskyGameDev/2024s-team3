extends Control

var description
var label

func _ready():
	top_level = true
	update_labels()


func set_text(new_label, new_description):
	self.description = new_description
	self.label = new_label
	update_labels()
	
func update_labels():
	if description:
		$VBoxContainer/Body.text = description
	if label:
		$VBoxContainer/Header.text = label
