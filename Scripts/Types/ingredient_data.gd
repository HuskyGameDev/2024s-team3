extends Resource
class_name Ingredient

@export var id: String = ""
@export var ingredient_name: String = ""
@export_multiline var description: String = ""
@export var image: Texture2D = null

func _setup(name: String, desc: String):
	ingredient_name = name
	description = desc
	id = name.to_snake_case()
	var imagePath = "res://Assets/Sprites/Ingredients/" + id + ".png"
	if ResourceLoader.exists(imagePath):
		image = load(imagePath)
	
