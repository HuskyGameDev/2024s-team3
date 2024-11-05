extends CanvasLayer

var backgroundScene: Node

func update_background():
	if PlayerData.location.packed_background_scene:
		var newBackground = PlayerData.location.packed_background_scene.instantiate()
		add_child(newBackground)
		if backgroundScene: 
			remove_child(backgroundScene)
			backgroundScene.queue_free()
		backgroundScene = newBackground
