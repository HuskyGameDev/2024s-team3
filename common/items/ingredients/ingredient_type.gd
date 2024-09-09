extends Item
class_name Ingredient

@export var effects: EffectSet

func _setup(ingredient_name: String, desc: String, stack: int):
	self.name = ingredient_name
	self.description = desc
	self.id = self.name.to_snake_case()
	self.stackSize = stack
	var imagePath = "res://Assets/Sprites/Ingredients/" + id + ".png"
	if ResourceLoader.exists(imagePath):
		self.image = load(imagePath)
	
