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
	name_changed = true
	# add timer so paths aren't updated so often (debounce)
	if not debounce_timer:
		debounce_timer = get_tree().create_timer(DEBOUNCE_LENGTH)
		debounce_timer.timeout.connect(_on_name_debounce_complete)
	else:
		debounce_timer.time_left = DEBOUNCE_LENGTH


###################### OTHER HANDLING ######################
## Triggers after name change debounce
func _on_name_debounce_complete():
	debounce_timer = null
	
	# get new path
	var regex = RegEx.new()
	regex.compile(ingredient.id)
	var new_id = ingredient.name.to_snake_case()
	var new_path = regex.sub(path, new_id, true)
	
	# remove old file and rename directory
	DirAccess.remove_absolute(path)
	DirAccess.rename_absolute(path.get_base_dir(), new_path.get_base_dir())
	
	# update id and image
	ingredient.id = new_id
	var image_path = new_path.get_basename() + ".png"
	if FileAccess.file_exists(image_path): 
		ingredient.image = load(image_path)
	else: 
		ingredient.image = null
	$ImageContainer/ImageLabel.texture = ingredient.image
	
	# save to new path
	ResourceSaver.save(ingredient, new_path, ResourceSaver.FLAG_CHANGE_PATH)
	path = new_path
	# update resource paths singleton
	ResourcePaths.update_ingredient_paths()


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
