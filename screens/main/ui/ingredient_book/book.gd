extends Node2D

@onready var sprite = $Sprite
@onready var ingredient = $Ingredient
@onready var description = $Description
@onready var forward = $Forward
@onready var back = $Back
@onready var anim = $"Book Animation"
@onready var values = $Values
@onready var ingrName = $Name


@export var bookButton: TextureButton


var locations
var knownIngredients: Array

var up: bool = false

var current_ingr_key = 0
@export var num_ingr: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	locations = PlayerData.visited_locations # get all loactions player has visited
	
	var num = 0;
	for x in locations.size():
		var location = ResourceLoader.load(ResourcePaths.get_location_path(locations[x].id))
		for y in location.ingredients.size():
			knownIngredients.append(location.ingredients[y])
			num += num
	print(num);
	_update_data()

func _move_up():
	if (!up):
		bookButton.disabled = true
		bookButton.hide()
		position = Vector2(306, 858)
		up = true
	else:
		bookButton.disabled = false
		bookButton.show()
		position = Vector2(306, 1248)
		up = false
	



func _add_one():
	if current_ingr_key < 10:
		current_ingr_key += 1
		_update_data()


func _sub_one():
	if current_ingr_key > 1:
		current_ingr_key -= 1
		_update_data()

func _update_data():
	var current_ingr: Ingredient
	current_ingr = knownIngredients[current_ingr_key]
	
	# Change all the data
	ingrName.text = current_ingr.name
	description.text = current_ingr.description
	ingredient.texture = current_ingr.image
	var valuesArray = values.get_children()
	
	valuesArray[0].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.HEALING_POISON)) 
	valuesArray[1].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.WARM_COLD)) 
	valuesArray[2].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.CALMING_AGITATION)) 
	valuesArray[3].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.STRENGTH_WEAKNESS)) 
	valuesArray[4].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.ENERGY_FATIGUE)) 
	valuesArray[5].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.LIGHT_DARK)) 
	valuesArray[6].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.LUCK_MISFORTUNE)) 
	valuesArray[7].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.CLARITY_CONFUSION)) 
	valuesArray[8].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.DEFENSE_VULNERABILITY)) 
	valuesArray[9].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.SWIFTNESS_SLOWNESS)) 
	
	PlayerData.bookPageNumber = current_ingr_key
	
	pass


func _on_forward_pressed() -> void:
	if (current_ingr_key < (num_ingr - 1)):
		anim.play("Forward")
	else:
		pass


func _on_back_pressed() -> void:
	if (current_ingr_key > 0):
		anim.play("Backward")
	else:
		pass
