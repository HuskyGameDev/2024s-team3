extends Control

# Declare the nodes we need to reference
@onready var volume_slider = $VBoxContainer/VolumeSlider
@onready var volume_label = $VBoxContainer/VolumeValue

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initial the slider value and label text based on current volume
	volume_slider.value = 50 # Set a defualt value
	volume_label.text = str(volume_slider.value) # Update the label to show the slider's value


# This fucntion will be triggered when the slider value changes
func _on_VolumeSlider_value_changed(value):
	# Update the volume label to reflect the slider value
	volume_label.text = str(value)
	
	# Adjust the game's master volume (assuming its controlled by the audio bus)
	var db_value = -80 + (value * 0.8) # Maps 0-100 range to -80 to 0 decibels
	AudioServer.set_bus_volume_db(0, db_value) # Adjust the volume of bus 0 (the master bus)
