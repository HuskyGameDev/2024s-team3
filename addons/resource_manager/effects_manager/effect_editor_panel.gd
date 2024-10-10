@tool
extends Node

# sends signal to ingredient_panel to close effect editor
signal close_editor

@onready var SliderContainer = $Content/ScrollContainer/EffectEditorsMarginContainer/EffectEditorsVBoxContainer
var ingredient:Ingredient

########################## SETUP ###########################
func with_data(ingredient:Ingredient):
	self.ingredient = ingredient
	if not ingredient.effects: ingredient.effects = EffectSet.new()
	return self

func _ready():
	if not ingredient: return
	# Update label
	$Content/Header/IngredientNameLabel.text = ingredient.name
	# Load effect values
	SliderContainer.get_node("HealingSlider")  .set_value(ingredient.effects.get_strength(EffectSet.HEALING_POISON))
	SliderContainer.get_node("WarmSlider")     .set_value(ingredient.effects.get_strength(EffectSet.WARM_COLD))
	SliderContainer.get_node("CalmingSlider")  .set_value(ingredient.effects.get_strength(EffectSet.CALMING_AGITATION))
	SliderContainer.get_node("StrengthSlider") .set_value(ingredient.effects.get_strength(EffectSet.STRENGTH_WEAKNESS))
	SliderContainer.get_node("EnergySlider")   .set_value(ingredient.effects.get_strength(EffectSet.ENERGY_FATIGUE))
	SliderContainer.get_node("LightSlider")    .set_value(ingredient.effects.get_strength(EffectSet.LIGHT_DARK))
	SliderContainer.get_node("LuckSlider")     .set_value(ingredient.effects.get_strength(EffectSet.LUCK_MISFORTUNE))
	SliderContainer.get_node("ClaritySlider")  .set_value(ingredient.effects.get_strength(EffectSet.CLARITY_CONFUSION))
	SliderContainer.get_node("DefenseSlider")  .set_value(ingredient.effects.get_strength(EffectSet.DEFENSE_VULNERABILITY))
	SliderContainer.get_node("SwiftnessSlider").set_value(ingredient.effects.get_strength(EffectSet.SWIFTNESS_SLOWNESS))

##################### EDITOR FUNCTIONS #####################
func _on_back_button_pressed():
	close_editor.emit()
	self.queue_free()

################### UPDATE EFFECT VALUES ###################
func _on_effect_value_changed(effect:Effect, new_value:int):
	ingredient.effects.set_strength(effect, new_value)
	ResourceSaver.save(ingredient, ResourcePaths.get_ingredient_path(ingredient.id))
