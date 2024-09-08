extends Resource
class_name Potion

@export var id: String = ""
@export var name: String = ""
@export_multiline var description: String = ""
@export var image: Texture2D = null
@export var min_effects: EffectSet
@export var max_effects: EffectSet

func _setup(potion_name: String, desc: String, new_recipe: Array):
	self.name = potion_name
	self.description = desc
	self.id = self.name.to_snake_case()
	var imagePath = "res://Assets/Sprites/Potions/" + id + ".png"
	if ResourceLoader.exists(imagePath):
		self.image = load(imagePath)
	for ingredient in new_recipe:
		if typeof(ingredient) != TYPE_STRING:
			print(ingredient + " is not of type string")
			continue
		if not ResourceLoader.exists("res://Assets/Resources/Ingredients/" + ingredient + ".tres"):
			print("Resource " + ingredient + " does not exist")
			continue
		self.recipe.append(ingredient)
	
