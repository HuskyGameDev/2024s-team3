@tool
extends HBoxContainer

# sent to min_and_max_effects
signal deleted(key:String)
# pass signals up
signal min_changed(key:String, value:int)
signal max_changed(key:String, value:int)

var effect_key:String

func with_data(key:String, maximum_range:int, min_value:int, max_value:int):
	self.effect_key = key
	$EffectSlider.effect_key = key
	$EffectSlider.max = maximum_range
	$EffectSlider.min_value = min_value
	$EffectSlider.max_value = max_value
	return self


func _on_delete_button_pressed():
	deleted.emit(effect_key)
	queue_free()


func _on_effect_min_changed(effect_key, value):
	min_changed.emit(effect_key, value)


func _on_effect_max_changed(effect_key, value):
	max_changed.emit(effect_key, value)
