@tool
extends HBoxContainer

var ingredient: Ingredient
var path: String
@onready var name_changed: bool = false # track if name has changed (to update path)

########################## SETUP ###########################
## Used when initializing, path is the ingredient resource path
func with_data(path:String):
	self.path = path
	self.ingredient = ResourceLoader.load(path)
	return self

## Set values on load
func _ready():
	if ingredient:
		$NameLabel.text = ingredient.name
		$DescriptionLabel.text = ingredient.description
		$StackSizeLabel.value = ingredient.stack_size
		$EffectLabel.text = ""
		$ImageContainer/ImageLabel.texture = ingredient.image


################# UPDATE INGREDIENT VALUES #################
## Triggered when description text changes
func _on_description_changed(new_desc:String):
	ingredient.description = new_desc


## Triggered when stack size changes
func _on_stack_size_changed(new_size:int):
	ingredient.stack_size = new_size

## Triggered when name changes
func _on_name_changed(new_name:String):
	ingredient.name = new_name
	ingredient.id = new_name.to_snake_case()
	name_changed = true


##################### BUTTON HANDLING ######################
func _on_save_button_pressed():
	if not name_changed:
		# save resource
		ResourceSaver.save(ingredient, path)
	else: 
		# move resource to different path
		pass
	name_changed = false


func _on_delete_button_pressed():
	#TODO
	pass
