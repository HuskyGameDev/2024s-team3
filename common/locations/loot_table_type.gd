extends Resource
class_name LootTable

const COMMON_CHANCE = 0.74
const UNCOMMON_CHANCE = 0.94
const RARE_CHANCE = 0.99

@export var common: Array
@export var uncommon: Array
@export var rare: Array
@export var legendary: Array

func _ready():
	randomize()


func get_random(count: int):
	var foundItems = []
	while foundItems.size() < count:
		foundItems.push_back(get_one_random())
	return foundItems


func get_one_random():
	var options: Array = []
	
	## Choose which list to pick from (it cannot be empty)
	while options.size() == 0:
		var f = randf()
		if f < COMMON_CHANCE: options = self.common
		elif f < UNCOMMON_CHANCE: options = self.uncommon
		elif f < RARE_CHANCE: options = self.rare
		else: options = self.legendary
	
	return options[randi() % options.size()]
