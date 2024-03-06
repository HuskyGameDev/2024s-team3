extends Resource
class_name Potion

@export var id: String = ""
@export var potion_name: String = ""
@export_multiline var description: String = ""
@export var image: Texture2D = null
@export var recipe: Array[String] = []

func _setup(name: String, desc: String, newRecipe: Array):
	potion_name = name
	description = desc
	id = name.to_snake_case()
	var imagePath = "res://Assets/Sprites/Potions/" + id + ".png"
	if ResourceLoader.exists(imagePath):
		image = load(imagePath)
	for ingredient in newRecipe:
		if typeof(ingredient) != TYPE_STRING:
			print(ingredient + " is not of type string")
			continue
		if not ResourceLoader.exists("res://Assets/Resources/Ingredients/" + ingredient + ".tres"):
			print("Resource " + ingredient + " does not exist")
			continue
		recipe.append(ingredient)
	
