@tool
extends Node

# sends a signal to effect_editor_panel
signal value_changed(effect_key:String, value:int)

@export var effect_key:String
@onready var NumberSpinBox:SpinBox = $LabelHBox/ValueSpinBox
@onready var NumberSlider:HSlider = $NumberSlider

## Update effect labels
func _ready():
	$LabelHBox/PositiveLabel.text = EffectSet.positive_labels[effect_key]
	$LabelHBox/NegativeLabel.text = EffectSet.negative_labels[effect_key]


## Keep slider and number in sync
func _on_slider_changed(value:int):
	NumberSpinBox.value = value
func _on_number_changed(value:int):
	NumberSlider.value = value
	value_changed.emit(effect_key, value)


## Set value of slider/number
func set_value(value:int):
	NumberSpinBox.value = value
	NumberSlider.value = value
