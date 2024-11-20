extends Node

# On spawn water signal, respawn water
func on_spawn_water() -> void:
	var water_scene = preload("res://common/items/water/water.tscn")
	
	var water_instance = water_scene.instantiate()
	add_child(water_instance)
	
	print("Signal Recieved: Spawn Water")
