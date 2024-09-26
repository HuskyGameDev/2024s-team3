@tool
extends HBoxContainer

const DEBOUNCE_LENGTH = 1

var ingredient: Ingredient
var path: String
@onready var name_changed: bool = false # track if name has changed (to update path)
var debounce_timer: SceneTreeTimer

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
	ResourceSaver.save(ingredient, path)


## Triggered when stack size changes
func _on_stack_size_changed(new_size:int):
	ingredient.stack_size = new_size
	ResourceSaver.save(ingredient, path)

## Triggered when name changes
func _on_name_changed(new_name:String):
	ingredient.name = new_name
	ingredient.id = new_name.to_snake_case()
	name_changed = true
	# add timer so paths aren't updated so often (debounce)
	if not debounce_timer:
		debounce_timer = get_tree().create_timer(DEBOUNCE_LENGTH)
		debounce_timer.timeout.connect(_on_name_debounce_complete)
	else:
		debounce_timer.time_left = DEBOUNCE_LENGTH


###################### OTHER HANDLING ######################
## Triggers after name change
func _on_name_debounce_complete():
	debounce_timer = null
	#TODO


## Called when row delete button pressed
func _on_delete_button_pressed():
	# show confirmation dialog
	$DeleteConfirmationDialog.visible = true


## Called from confirmation dialog
func _on_delete_confirmed():
	self.queue_free()
	DirAccess.remove_absolute(path)
	DirAccess.remove_absolute(path.get_base_dir())
	# update resource paths singleton
	ResourcePaths.update_ingredient_paths()
