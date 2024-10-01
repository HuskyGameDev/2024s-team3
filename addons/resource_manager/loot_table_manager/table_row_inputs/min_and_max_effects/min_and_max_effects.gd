@tool
extends Control

const EffectRow = preload("res://addons/resource_manager/loot_table_manager/table_row_inputs/min_and_max_effects/min_and_max_effects_row.tscn")

@onready var EffectOptions = $AddHBox/EffectOptions

func _on_add_button_pressed():
	var selected_id = EffectOptions.selected
	if selected_id < 0: return
	## Add new effect editor row
	var new_row = EffectRow.instantiate().with_data(EffectOptions.get_item_text(selected_id))
	add_child(new_row)
	move_child(new_row, get_child_count() - 2)
	if get_child_count() >= 4: $AddHBox.hide()
	## Remove option from dropdown
	EffectOptions.remove_item(selected_id)
	## Connect new row signals
	new_row.connect("deleted", _on_row_deleted)


func _on_row_deleted(deleted_row_key:String):
	# need to use <= because when the signal is emitted the node hasn't been removed from the tree yet
	if get_child_count() <= 4: $AddHBox.show() 
	## Add option back to dropdown
	EffectOptions.add_item(deleted_row_key)
