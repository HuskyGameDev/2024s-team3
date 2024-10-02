@tool
extends Control

## Signals
# sends a signal for min and max value changes (only min is used if show_range is false)
signal min_changed(effect_key:String, value:int)
signal max_changed(effect_key:String, value:int)

## Inspector vars
@export_category("Settings")
@export var show_range:bool = false # show both min and max (if not we just use the min slider)
@export var max:int = 30 # absolute value of the max number on the slider
@export var effect_key:String # string of effect name

## Nodes
@onready var MinGrabber = $SliderContainer/MinGrabber
@onready var MinGrabberLabel = $SliderContainer/MinGrabber/MinLabel
@onready var MaxGrabber = $SliderContainer/MaxGrabber
@onready var MaxGrabberLabel = $SliderContainer/MaxGrabber/MaxLabel
@onready var SliderRange = $SliderContainer/SliderRange

var range_section_width:int
var range_center:int

## Track the current min and max values
@export_category("Values")
@export var min_value:int :
	set(value):
		min_value = value
		if MinGrabber:
			MinGrabber.global_position.x = range_center + min_value * range_section_width
			MinGrabberLabel.text = str(min_value)
@export var max_value:int :
	set(value):
		max_value = value
		if MaxGrabber:
			MaxGrabber.global_position.x = range_center + max_value * range_section_width
			MaxGrabberLabel.text = str(max_value)


func _ready():
	# Update effect labels
	if effect_key:
		$LabelHBox/PositiveLabel.text = EffectSet.positive_labels[effect_key]
		$LabelHBox/NegativeLabel.text = EffectSet.negative_labels[effect_key]
	# Show max grabber and calculate offsets/section width
	if not show_range: MaxGrabber.hide()
	# Wait for slider size to update
	while not SliderRange or not SliderRange.size.x:
		await get_tree().process_frame
	_on_resized()


func _on_resized():
	if not SliderRange: return
	range_section_width = round(SliderRange.size.x / (max * 2 + 1)) # double max for pos and neg, add 1 for zero
	range_center = round(SliderRange.global_position.x + SliderRange.size.x / 2)
	# update grabber locations
	min_value = min_value
	max_value = max_value


func set_value(new_min:int, new_max:int = max):
	min_value = new_min
	max_value = new_max

############################### DRAGGING SLIDERS ##############################
var holding_min = false
var holding_max = false

func _on_min_grabber_input(event):
	# check for click or release
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		holding_min = event.pressed
	# move grabber and update value
	if event is InputEventMouseMotion and holding_min:
		var new_value = round((event.global_position.x - range_center) / range_section_width)
		if abs(new_value) <= max and (not show_range or new_value <= max_value): # check valid
			min_value = new_value
			min_changed.emit(effect_key, min_value)


func _on_max_grabber_input(event):
	# check for click or release
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		holding_max = event.pressed
	# move grabber and update value
	if event is InputEventMouseMotion and holding_max:
		var new_value = round((event.global_position.x - range_center) / range_section_width)
		if abs(new_value) <= max and (not show_range or new_value >= min_value): # check valid
			max_value = new_value
			max_changed.emit(effect_key, max_value)
