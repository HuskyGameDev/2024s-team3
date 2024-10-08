@tool
extends Node

# sends signal to ingredient_row when edit button pressed
signal edit

@onready var EffectLabel = $HBoxContainer/CollapsedContainer

func _on_edit_button_pressed():
	edit.emit()


func set_summary(string:String):
	EffectLabel.text = string
