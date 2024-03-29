@tool
extends EditorScript

const RESOURCES_PATH = "res://Assets/Resources"
const INGREDIENTS_DATA_PATH = "res://Assets/Data/Ingredients.txt"
const POTIONS_DATA_PATH = "res://Assets/Data/Potions.txt"
const LOCATIONS_DATA_PATH = "res://Assets/Data/Locations.txt"

func _run():
	## Recreate resources folder
	if DirAccess.dir_exists_absolute(RESOURCES_PATH):
		DirAccess.remove_absolute(RESOURCES_PATH)
	DirAccess.make_dir_absolute(RESOURCES_PATH)
	## Load each type of resource
	load_ingredients()
	load_potions()
	load_locations()
	

func load_ingredients():
	const ingredientDirPathName = RESOURCES_PATH + "/Ingredients"
	if not DirAccess.dir_exists_absolute(ingredientDirPathName):
		DirAccess.make_dir_absolute(ingredientDirPathName)
	var ingredientsFile = FileAccess.open(INGREDIENTS_DATA_PATH, FileAccess.READ)
	if not ingredientsFile: 
		print("No ingredients data file exists")
		return
	ingredientsFile.get_line() # skip the first line
	while not ingredientsFile.eof_reached():
		var ingredient = Ingredient.new()
		var csvLine = ingredientsFile.get_csv_line()
		if csvLine.size() < 3:
			continue
		ingredient._setup(csvLine[0], csvLine[2], int(csvLine[1]))
		ResourceSaver.save(ingredient, ingredientDirPathName + "/" + ingredient.id + ".tres")
	

func load_potions():
	const potionDirPathName = RESOURCES_PATH + "/Potions"
	if not DirAccess.dir_exists_absolute(potionDirPathName):
		DirAccess.make_dir_absolute(potionDirPathName)
	var potionsFile = FileAccess.open(POTIONS_DATA_PATH, FileAccess.READ)
	if not potionsFile: 
		print("No potions data file exists")
		return
	potionsFile.get_line() # skip the first line
	while not potionsFile.eof_reached():
		var potion = Potion.new()
		var csvLine = potionsFile.get_csv_line()
		if csvLine.size() < 3:
			continue
		potion._setup(csvLine[0], csvLine[1], JSON.parse_string(csvLine[2]))
		ResourceSaver.save(potion, potionDirPathName + "/" + potion.id + ".tres")
	

func load_locations():
	const locationDirPathName = RESOURCES_PATH + "/Locations"
	if not DirAccess.dir_exists_absolute(locationDirPathName):
		DirAccess.make_dir_absolute(locationDirPathName)
	var locationsFile = FileAccess.open(LOCATIONS_DATA_PATH, FileAccess.READ)
	if not locationsFile: 
		print("No locations data file exists")
		return
	while not locationsFile.eof_reached():
		var location = Location.new()
		var csvLine = locationsFile.get_csv_line()
		if csvLine.size() < 3:
			continue
		location._setup(csvLine[0], 
			JSON.parse_string(csvLine[1]), 
			JSON.parse_string(csvLine[2]), 
			JSON.parse_string(csvLine[3]))
		ResourceSaver.save(location, locationDirPathName + "/" + location.id + ".tres")
	
