@tool
extends HBoxContainer

@export var effect:Effect
var path:String

func _ready():
	if effect:
		path = "res://common/items/effects/%s.tres" % effect.id
		$IdLabel.text = effect.id
		$PositiveLabel.text = effect.pos_label
		$PositiveColorPicker.color = effect.pos_color
		$NegativeLabel.text = effect.neg_label
		$NegativeColorPicker.color = effect.neg_color
		$RepSpinBox.value = effect.reputation_factor
		$MoneySpinBox.value = effect.money_factor


func _on_rep_spin_box_value_changed(value):
	effect.reputation_factor = value
	ResourceSaver.save(effect, path)


func _on_money_spin_box_value_changed(value):
	effect.money_factor = value
	ResourceSaver.save(effect, path)


func _on_positive_color_picker_color_changed(color):
	effect.pos_color = color
	ResourceSaver.save(effect, path)


func _on_negative_color_picker_color_changed(color):
	effect.neg_color = color
	ResourceSaver.save(effect, path)
