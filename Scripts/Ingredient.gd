extends Resource
class_name Ingredient

@export var icon: Texture2D
@export var name: String

@export var recipe: Array[Ingredient]

@export_enum("Potion","Material")
var type = "Material"

@export_multiline var description: String
