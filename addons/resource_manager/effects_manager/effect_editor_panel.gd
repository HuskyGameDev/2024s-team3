@tool
extends Node

# sends signal to ingredient_panel to close effect editor
signal close_editor

@onready var slider_container = $Content/ScrollContainer/EffectEditorsMarginContainer/EffectEditorsVBoxContainer
var ingredient:Ingredient

########################## SETUP ###########################
func with_data(ingredient:Ingredient):
	self.ingredient = ingredient
	if not ingredient.effects: ingredient.effects = EffectSet.new()
	return self

func _ready():
	# Update label
	$Content/Header/IngredientNameLabel.text = ingredient.name
	# Load effect values
	slider_container.get_node("HealingSlider")  .set_value(ingredient.effects.healing_poison)
	slider_container.get_node("WarmSlider")     .set_value(ingredient.effects.warm_cold)
	slider_container.get_node("CalmingSlider")  .set_value(ingredient.effects.calming_agitation)
	slider_container.get_node("StrengthSlider") .set_value(ingredient.effects.strength_weakness)
	slider_container.get_node("EnergySlider")   .set_value(ingredient.effects.energy_fatigue)
	slider_container.get_node("LightSlider")    .set_value(ingredient.effects.light_dark)
	slider_container.get_node("LuckSlider")     .set_value(ingredient.effects.luck_misfortune)
	slider_container.get_node("ClaritySlider")  .set_value(ingredient.effects.clarity_confusion)
	slider_container.get_node("DefenseSlider")  .set_value(ingredient.effects.defense_vulnerability)
	slider_container.get_node("SwiftnessSlider").set_value(ingredient.effects.swiftness_slowness)

##################### EDITOR FUNCTIONS #####################
func _on_back_button_pressed():
	close_editor.emit()
	self.queue_free()

################### UPDATE EFFECT VALUES ###################
func _on_effect_value_changed(effect_key:String, new_value:int):
	ingredient.effects.set_effect_by_key(effect_key, new_value)
	ResourceSaver.save(ingredient, ResourcePaths.get_ingredient_path(ingredient.id), ResourceSaver.FLAG_BUNDLE_RESOURCES) # flag saves effects resource
