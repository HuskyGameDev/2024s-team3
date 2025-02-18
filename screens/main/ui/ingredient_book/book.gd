extends Node2D

@onready var sprite = $Sprite
@onready var ingredient = $Ingredient
@onready var description = $Description
@onready var forward = $Forward
@onready var backward = $Backward
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
	for x in locations.size(): # for each location player has visited
		var location = ResourceLoader.load(ResourcePaths.get_location_path(locations[x].id)) # get location
		for y in location.ingredients.size(): # for each ingredient in location
			var ing = location.ingredients[y]
			if knownIngredients.has(ing) == false: #if we do not already have this ingedient in known ingredients
				knownIngredients.append(ing) #add to known ingredients
				num += 1 
	num_ingr = num #number of known ingredients
	_update_data()

func _move_up():
	if (!up):
		bookButton.disabled = true
		bookButton.hide()
		var tween = create_tween()
		tween.tween_property(self, "position",Vector2(306, 858), .5)
		up = true
	else:
		bookButton.disabled = false
		var tween = create_tween()
		tween.tween_property(self, "position",Vector2(306, 1248), .5)
		await tween.finished
		bookButton.show()
		up = false
	

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
	

func _on_forward_pressed() -> void: # button press
	if (current_ingr_key < (num_ingr - 1)): # 
		anim.play("Forward")
		current_ingr_key += 1
		await get_tree().create_timer(0.5).timeout # wait for 0.5 seconds for animation to fade out before update
		_update_data()
	else:
		pass
		
	if (current_ingr_key == (num_ingr - 1)): #if this is last page hide forward button
		forward.visible = false
		
	if backward.visible == false: # if this is no longer first page show backward button
		backward.visible = true


func _on_back_pressed() -> void: # button press
	if (current_ingr_key > 0):
		anim.play("Backward")
		current_ingr_key -= 1
		await get_tree().create_timer(0.5).timeout # wait for 0.5 seconds for animation to fade out before update
		_update_data()
	else:
		pass
		
	if current_ingr_key == 0: # if this is first page hide back arrow
		backward.visible = false
	
	if  forward.visible == false: #if we are no longer on last page show forward arrow
		forward.visible = true
