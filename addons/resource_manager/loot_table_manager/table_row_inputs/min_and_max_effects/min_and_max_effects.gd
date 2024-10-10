@tool
extends Control

# pass signals up
signal min_changed(effect:Effect, value:int)
signal max_changed(effect:Effect, value:int)

const EffectRow = preload("res://addons/resource_manager/loot_table_manager/table_row_inputs/min_and_max_effects/min_and_max_effects_row.tscn")
const ABS_MAX = 50 # max effect value (negative will be used for min)

@onready var EffectOptions = $EffectContainer/AddHBox/EffectOptions
@onready var EffectContainer = $EffectContainer


func _on_add_button_pressed():
	var selected_id = EffectOptions.selected
	if selected_id < 0: return
	var selected_key = EffectOptions.get_item_text(selected_id)
	## Add row
	add_row(selected_key, -ABS_MAX, ABS_MAX, selected_id)


func add_row(selected_key:String, min_val:int, max_val:int, selected_id = null):
	var selected_effect = EffectSet.get_effect_by_id(selected_key)
	## Add new effect editor row
	var new_row = EffectRow.instantiate().with_data(selected_effect, ABS_MAX, min_val, max_val)
	EffectContainer.add_child(new_row)
	EffectContainer.move_child(new_row, EffectContainer.get_child_count() - 2)
	if EffectContainer.get_child_count() >= 4: $EffectContainer/AddHBox.hide()
	## Remove option from dropdown
	if not selected_id:
		for i in EffectOptions.item_count:
			if EffectOptions.get_item_text(i) == selected_key:
				selected_id = i
				break
	EffectOptions.remove_item(selected_id)
	## Connect new row signals
	new_row.connect("deleted", _on_row_deleted)
	new_row.connect("min_changed", _on_min_effect_changed)
	new_row.connect("max_changed", _on_max_effect_changed)
	## Emit min and max changed with initial values
	min_changed.emit(selected_effect, min_val)
	max_changed.emit(selected_effect, max_val)


func _on_row_deleted(deleted_row_key:String):
	# need to use <= because when the signal is emitted the node hasn't been removed from the tree yet
	if EffectContainer.get_child_count() <= 4: $EffectContainer/AddHBox.show() 
	## Add option back to dropdown
	EffectOptions.add_item(deleted_row_key)
	## Set values back to default
	var deleted_effect = EffectSet.get_effect_by_id(deleted_row_key)
	min_changed.emit(deleted_effect, -ABS_MAX)
	max_changed.emit(deleted_effect, ABS_MAX)


func _on_min_effect_changed(effect:Effect, value:int):
	min_changed.emit(effect, value)


func _on_max_effect_changed(effect:Effect, value:int):
	max_changed.emit(effect, value)
