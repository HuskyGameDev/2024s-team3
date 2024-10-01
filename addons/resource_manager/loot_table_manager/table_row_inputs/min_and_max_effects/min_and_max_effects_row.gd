@tool
extends HBoxContainer

# sent to min_and_max_effects
signal deleted(key:String)

var effect_key:String

func with_data(key:String):
	self.effect_key = key
	$EffectSlider.effect_key = key
	return self


func _on_delete_button_pressed():
	deleted.emit(effect_key)
	queue_free()


func _on_effect_min_changed(effect_key, value):
	pass #TODO Replace with function body.


func _on_effect_max_changed(effect_key, value):
	pass #TODO Replace with function body.
