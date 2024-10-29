@tool
extends Control

static var IngredientRowPreload = preload("res://addons/resource_manager/location_manager/ingredient_row.tscn")
const DEBOUNCE_LENGTH = 1

# sends signal to location panel to switch to forage table editor
signal open_forage_table_editor(location:Location, type:String)
# sends signal to location panel to switch to ingredients shop table editor
signal open_ingredients_shop_table_editor(location:Location, type:String)
# sends signal to location panel to switch to customer request table editor
signal open_customer_request_table_editor(location:Location, type:String)

var location: Location
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
	if not path: return
	self.location = ResourceLoader.load(path, "Location")
	$LocationInfo/NameLabel.text = location.name
	for ingredient in location.ingredients:
		var row = IngredientRowPreload.instantiate()
		row.get_node("NameLabel").text = ingredient.name
		row.get_node("DeleteButton").connect("pressed", _on_ingredient_removed.bind(row, ingredient))
		$IngredientMarginContainer/IngredientContainer.add_child(row)


################# UPDATE LOCATION VALUES #################
## Triggered when name changes
func _on_name_changed(new_name:String):
	location.name = new_name
	name_changed = true
	# add timer so paths aren't updated so often (debounce)
	if not debounce_timer:
		debounce_timer = get_tree().create_timer(DEBOUNCE_LENGTH)
		debounce_timer.timeout.connect(_on_name_debounce_complete)
	else:
		debounce_timer.time_left = DEBOUNCE_LENGTH

## Triggered when ingredient is removed from location
func _on_ingredient_removed(row, ingredient):
	self.location.ingredients.erase(ingredient)
	row.queue_free()
	ResourceSaver.save(location, path)

## Triggered when ingredient is added to location:
func _on_ingredient_added():
	var ingredient = $AddIngredientMarginContainer/AddIngredientHBox/IngredientDropdown.selected_ingredient
	self.location.ingredients.append(ingredient)
	var row = IngredientRowPreload.instantiate()
	row.get_node("NameLabel").text = ingredient.name
	row.get_node("DeleteButton").connect("pressed", _on_ingredient_removed.bind(row, ingredient))
	$IngredientMarginContainer/IngredientContainer.add_child(row)
	ResourceSaver.save(location, path)

###################### OTHER HANDLING ######################
## Triggers after name change debounce
func _on_name_debounce_complete():
	debounce_timer = null
	
	# get new path
	location.id = location.name.to_snake_case()
	var new_path = "%s/%s.tres" % [ path.get_base_dir(), location.id ]
	
	# save to new path
	ResourceSaver.save(location, new_path)
	DirAccess.remove_absolute(path)
	# update resource paths singleton
	ResourcePaths.update_location_paths()
	path = new_path


## Called when row delete button pressed
func _on_delete_button_pressed():
	# show confirmation dialog
	$DeleteConfirmationDialog.visible = true


## Called from delete confirmation dialog
func _on_delete_confirmed():
	self.queue_free()
	DirAccess.remove_absolute(path)
	# update resource paths singleton
	ResourcePaths.update_location_paths()


## Called when forage table edit button is pressed
func _on_edit_forage_table_pressed(): 
	open_forage_table_editor.emit(location, "FORAGE")


## Called when ingredients shop table edit button is pressed
func _on_edit_ingredients_shop_table_pressed(): 
	open_ingredients_shop_table_editor.emit(location, "INGREDIENTS_SHOP")


## Called when customer request table edit button is pressed
func _on_edit_customer_request_table_pressed(): 
	open_customer_request_table_editor.emit(location, "CUSTOMER_REQUEST")
