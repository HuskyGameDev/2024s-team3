extends Resource
class_name Ingredient

@export var id: String = ""
@export var name: String = ""
@export_multiline var description: String = ""
@export var stackSize: int = 5
@export var image: Texture2D = null

func _setup(name: String, desc: String, stack: int):
	self.name = name
	self.description = desc
	self.id = self.name.to_snake_case()
	self.stackSize = stack
	var imagePath = "res://Assets/Sprites/Ingredients/" + id + ".png"
	if ResourceLoader.exists(imagePath):
		self.image = load(imagePath)
	
