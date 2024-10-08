@tool
extends HBoxContainer

const DEBOUNCE_LENGTH = 1

const VARIATION_ROW_SCENE = preload("res://addons/resource_manager/ingredient_manager/ingredient_variant_row.tscn")

# sends signal to ingredient panel to switch to effect editor
signal open_effect_editor(ingredient:Ingredient)

var ingredient: Ingredient
var path: String
var debounce_timer: SceneTreeTimer
@onready var name_changed: bool = false # track if name has changed (to update path)

########################## SETUP ###########################
## Used when initializing, path is the ingredient resource path
func with_data(path:String):
	self.path = path
	return self

## Set values on load
func _ready():
	# Load ingredient resource
	if not path: return
	self.ingredient = ResourceLoader.load(path, "Ingredient")
	
	# Update labels
	$NameLabel.text = ingredient.name
	$DescriptionLabel.text = ingredient.description
	$StackSizeContainer/StackSizeLabel.value = ingredient.stack_size
	$ImageContainer/ImageLabel.texture = ingredient.image
	try_load_image()
	self.update_effect_summary()
	
	# Update available action checkboxes
	$ChoppableCheck.button_pressed = ingredient.available_actions & Ingredient.Actions.CHOP
	$CrushableCheck.button_pressed = ingredient.available_actions & Ingredient.Actions.CRUSH
	$MeltableCheck.button_pressed = ingredient.available_actions & Ingredient.Actions.MELT
	$ConcentratableCheck.button_pressed = ingredient.available_actions & Ingredient.Actions.CONCENTRATE
	
	# If any alternates of the ingredient exist, add those rows
	if ingredient.available_actions & Ingredient.Actions.CHOP:
		create_variant("Chopped")
	if ingredient.available_actions & Ingredient.Actions.CRUSH:
		print("can crush")
	if ingredient.available_actions & Ingredient.Actions.MELT:
		print("can melt")
	if ingredient.available_actions & Ingredient.Actions.CONCENTRATE:
		print("can concentrate")


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

## Triggered when choppable checkbox changes:
func _on_choppable_check_toggled(toggled_on):
	if toggled_on:
		ingredient.available_actions |= Ingredient.Actions.CHOP
	else:
		ingredient.available_actions &= ~Ingredient.Actions.CHOP
	ResourceSaver.save(ingredient, path)

## Triggered when crushable checkbox changes:
func _on_crushable_check_toggled(toggled_on):
	if toggled_on:
		ingredient.available_actions |= Ingredient.Actions.CRUSH
	else:
		ingredient.available_actions &= ~Ingredient.Actions.CRUSH
	ResourceSaver.save(ingredient, path)

## Triggered when meltable checkbox changes:
func _on_meltable_check_toggled(toggled_on):
	if toggled_on:
		ingredient.available_actions |= Ingredient.Actions.MELT
	else:
		ingredient.available_actions &= ~Ingredient.Actions.MELT
	ResourceSaver.save(ingredient, path)

## Triggered when concentratable checkbox changes:
func _on_concentratable_check_toggled(toggled_on):
	if toggled_on:
		ingredient.available_actions |= Ingredient.Actions.CONCENTRATE
	else:
		ingredient.available_actions &= ~Ingredient.Actions.CONCENTRATE
	ResourceSaver.save(ingredient, path)

###################### OTHER HANDLING ######################
## Attempts to load an image with the same name as the resource
func try_load_image():
	if not ingredient.image: # don't clear existing image
		var image_path = path.get_basename() + ".png"
		if FileAccess.file_exists(image_path):
			ingredient.image = load(image_path)
		else: 
			ingredient.image = null
	$ImageContainer/ImageLabel.texture = ingredient.image


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
	path = new_path
	try_load_image()
	
	# save to new path
	ResourceSaver.save(ingredient, new_path, ResourceSaver.FLAG_CHANGE_PATH)
	# update resource paths singleton
	ResourcePaths.update_ingredient_paths()


## Called when row delete button pressed
func _on_delete_button_pressed():
	# show confirmation dialog
	$DeleteConfirmationDialog.visible = true


## Called from delete confirmation dialog
func _on_delete_confirmed():
	self.queue_free()
	DirAccess.remove_absolute(ingredient.image.resource_path)
	DirAccess.remove_absolute(ingredient.image.resource_path+".import")
	DirAccess.remove_absolute(path)
	DirAccess.remove_absolute(path.get_base_dir())
	# update resource paths singleton
	ResourcePaths.update_ingredient_paths()


## Called when effect edit button is pressed
## (Actual value change is handled in effect_editor_panel.gd)
func _on_effect_edit_pressed(): 
	open_effect_editor.emit(ingredient)


## Called on ready and when effects are edited
func update_effect_summary():
	if not ingredient.effects or ingredient.effects.all_null():
		$CollapsedEffectView.set_summary("None")
	else:
		$CollapsedEffectView.set_summary(", ".join(ingredient.effects.get_strongest()))


## Called to create a variant resource of this one
func create_variant(variation:String):
	var new_name = "%s %s" % [variation, self.ingredient.name]
	var new_id = new_name.to_snake_case()
	print(new_id)
	# check if resource exists
	if not ResourcePaths.get_ingredient_path(new_id):
		# create ingredient resource
		var new_ingredient = Ingredient.new()
		new_ingredient.name = new_name
		new_ingredient.id = new_id
		var new_path = "%s/%s.tres" % [ResourcePaths.get_ingredient_path(self.ingredient.id).get_base_dir(), new_id]
		ResourceSaver.save(new_ingredient, new_path)
		# update resource paths singleton
		ResourcePaths.update_ingredient_paths()
	# add variant row to resource manager
	var new_variant_scene = VARIATION_ROW_SCENE.instantiate()
	add_sibling(new_variant_scene)
