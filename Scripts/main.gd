extends Node2D

var potionScene = preload("res://Scenes/Potion.tscn")

func _on_cauldron_potion_made(potion:Potion):
	var newPotionObj = potionScene.instantiate()
	newPotionObj.setType(potion)
	newPotionObj.global_position = $"Cauldron".global_position - Vector2(0, 100)
	add_child(newPotionObj)
	## "throws" potion
	## angle options: +/- 250, 350, 450, and 550
	var throwAngle = (randi_range(2, 5) * 100 + 50)
	if(bool(randi_range(0, 1))):
		throwAngle *= -1
	newPotionObj.rigidbody.apply_central_impulse(Vector2(throwAngle, -2000))

func _on_shelf_body_entered(body):
	body.rotation = 0
	print("entered")
