@tool
extends HBoxContainer

# sent to min_and_max_effects
signal deleted(effect:Effect)
# pass signals up
signal min_changed(effect:Effect, value:int)
signal max_changed(effect:Effect, value:int)

var effect:Effect

func with_data(effect:Effect, maximum_range:int, min_value:int, max_value:int):
	self.effect = effect
	$EffectSlider.effect = effect
	$EffectSlider.max = maximum_range
	$EffectSlider.min_value = min_value
	$EffectSlider.max_value = max_value
	return self


func _on_delete_button_pressed():
	deleted.emit(effect)
	queue_free()


func _on_effect_min_changed(effect, value):
	min_changed.emit(effect, value)


func _on_effect_max_changed(effect, value):
	max_changed.emit(effect, value)
