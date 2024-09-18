extends Node2D

var currentEffects: EffectSet = EffectSet.new()
var hasIngredients: bool = false

signal potion_made(potion: Potion, pos: Vector2)

func _on_body_enter_cauldron(body):
	if not "data" in body: return
	if not body.data is Ingredient: return
	## Animate object movement to top of cauldron
	body.gravity_scale = 0
	var top_of_cauldron = self.position - Vector2(0, 80)
	var ingredient_position = body.global_position
	var time_to_animate = (top_of_cauldron.distance_to(ingredient_position)) / 1000
	var tween = create_tween().bind_node(body)
	tween.tween_property(body, "global_position", top_of_cauldron, time_to_animate).from(ingredient_position)
	await tween.finished
	## Add effects to cauldron's potion
	hasIngredients = true
	currentEffects.add(body.data.effects)
	body.queue_free()


func _on_cauldron_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		if hasIngredients: 
			var potion = Potion.new()
			potion.effects = currentEffects
			potion_made.emit(potion, self.global_position - Vector2(0, 100))
			hasIngredients = false
			currentEffects = EffectSet.new()
