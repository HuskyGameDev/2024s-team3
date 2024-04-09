extends Control
var main_scene = preload("res://Scenes/Screens/Main.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().get_root().add_child(main_scene)
	get_tree().change_scene_to_packed(main_scene)
	#get_tree().remove_child("/root/Title")
	get_node("/root/Title").queue_free()


func _on_exit_pressed():
	get_tree().quit()
