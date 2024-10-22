@tool
extends HBoxContainer

const DEBOUNCE_LENGTH = 1

# sends signal to ingredient panel to switch to effect editor
signal open_effect_editor(ingredient:Ingredient)
# sends signal to ingredient panel to connect to signals from new row
signal variant_created(row:Node)

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
	self.name = ingredient.id # renames the node, not the ingredient
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
		create_variant(Ingredient.Actions.CHOP)
	if ingredient.available_actions & Ingredient.Actions.CRUSH:
		create_variant(Ingredient.Actions.CRUSH)
	if ingredient.available_actions & Ingredient.Actions.MELT:
		create_variant(Ingredient.Actions.MELT)
	if ingredient.available_actions & Ingredient.Actions.CONCENTRATE:
		create_variant(Ingredient.Actions.CONCENTRATE)


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
		create_variant(Ingredient.Actions.CHOP)
	else:
		ingredient.available_actions &= ~Ingredient.Actions.CHOP
		remove_variant(Ingredient.Actions.CHOP)
	ResourceSaver.save(ingredient, path)

## Triggered when crushable checkbox changes:
func _on_crushable_check_toggled(toggled_on):
	if toggled_on:
		ingredient.available_actions |= Ingredient.Actions.CRUSH
		create_variant(Ingredient.Actions.CRUSH)
	else:
		ingredient.available_actions &= ~Ingredient.Actions.CRUSH
		remove_variant(Ingredient.Actions.CRUSH)
	ResourceSaver.save(ingredient, path)

## Triggered when meltable checkbox changes:
func _on_meltable_check_toggled(toggled_on):
	if toggled_on:
		ingredient.available_actions |= Ingredient.Actions.MELT
		create_variant(Ingredient.Actions.MELT)
	else:
		ingredient.available_actions &= ~Ingredient.Actions.MELT
		remove_variant(Ingredient.Actions.MELT)
	ResourceSaver.save(ingredient, path)

## Triggered when concentratable checkbox changes:
func _on_concentratable_check_toggled(toggled_on):
	if toggled_on:
		ingredient.available_actions |= Ingredient.Actions.CONCENTRATE
		create_variant(Ingredient.Actions.CONCENTRATE)
	else:
		ingredient.available_actions &= ~Ingredient.Actions.CONCENTRATE
		remove_variant(Ingredient.Actions.CONCENTRATE)
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
	if ingredient.image:
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
		$CollapsedEffectView.set_summary(", ".join(ingredient.effects.get_strongest_as_strings()))


## Called to create a variant resource of this one
func create_variant(variation:Ingredient.Actions):
	# check if already a variant
	var split_path = path.get_basename().split("/")
	var new_name = "%s %s" % [Ingredient.action_to_string(variation).capitalize(), split_path[-2].replace("_", " ").capitalize()]
	var new_id = new_name.to_snake_case()
	var new_path = "%s/%s.tres" % [path.get_base_dir(), new_id]
	# check if variant already in resource manager
	if get_parent().get_node_or_null(new_id) != null: return
	# check if resource exists
	if not ResourcePaths.get_ingredient_path(new_id):
		# create ingredient resource
		var new_ingredient = Ingredient.new()
		new_ingredient.name = new_name
		new_ingredient.id = new_id
		new_ingredient.effects = ingredient.effects.duplicate()
		match variation:
			Ingredient.Actions.CHOP: new_ingredient.effects.modify_smallest(func(e): return 0)
			Ingredient.Actions.CRUSH: 
				new_ingredient.effects.modify_largest(func(e): return 0)
				new_ingredient.effects.modify_smallest(func(e): return clamp(e * 2, -30, 30))
			Ingredient.Actions.MELT: new_ingredient.effects.modify_each(func(e): return e * -1)
			Ingredient.Actions.CONCENTRATE: new_ingredient.effects.modify_largest(func(e): return clamp(e * 1.5, -30, 30))
		ResourceSaver.save(new_ingredient, new_path)
		# update resource paths singleton
		ResourcePaths.update_ingredient_paths()
	# add variant row to resource manager
	var new_variant_scene = load("res://addons/resource_manager/ingredient_manager/ingredient_variant_row.tscn").instantiate().with_data(new_path)
	variant_created.emit(new_variant_scene)
	add_sibling(new_variant_scene)


## Called to remove a variant resource of this one
func remove_variant(variation:Ingredient.Actions):
	# check if any other versions of this ingredient allow that variation
	var variant_paths = ResourcePaths.get_all_ingredient_variant_paths(ingredient.id)
	for path in variant_paths:
		var variant = ResourceLoader.load(path, "Ingredient")
		if variant.can(variation): # used by another version of this ingredient, so don't remove it
			return 
	# remove resource file
	var split_path = path.get_basename().split("/")
	var new_id = "%s_%s" % [Ingredient.action_to_string(variation), split_path[-2]]
	var new_path = "%s/%s.tres" % [path.get_base_dir(), new_id]
	DirAccess.remove_absolute(new_path)
	# update resource paths singleton
	ResourcePaths.update_ingredient_paths()
	# remove row from table
	var row = get_parent().get_node_or_null(new_id)
	if row != null: row.queue_free()
