@tool
extends "../loot_table_row.gd"

## Customer Request table type:
## [ CustomerOrder ]


func _on_rarity_changed(index):
	super(index)
	pass #TODO Replace with function body.


func _on_dialogue_changed():
	pass #TODO Replace with function body.


func _on_min_effect_changed(key, value):
	pass #TODO Replace with function body.


func _on_max_effect_changed(key, value):
	pass #TODO Replace with function body.


func _on_delete_button_pressed():
	#TODO table[self.rarity.to_lower()].erase({})
	super()
