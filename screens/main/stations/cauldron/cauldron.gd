extends Node2D

var current_effects: EffectSet = EffectSet.new()
var has_ingredients: bool = false
var volume: int = -20
var making_potion: bool = false

@onready var SpriteShader:ShaderMaterial = $Sprite.material

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
	has_ingredients = true
	current_effects.add(body.data.effects)
	SpriteShader.set_shader_parameter("to", current_effects.get_color())
	body.queue_free()
	if (volume<0): 
		volume = volume + 5
		$Bubbler.volume_db = volume


func _on_cauldron_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		if has_ingredients && !making_potion: 
			making_potion = true
			$CauldronFinishPlayer.play(0.43)
			await get_tree().create_timer(0.47).timeout
			var potion = Potion.new()
			potion.effects = current_effects
			potion_made.emit(potion, self.global_position - Vector2(0, 100))
			has_ingredients = false
			current_effects = EffectSet.new()
			volume = -20
			$Bubbler.volume_db=volume
			SpriteShader.set_shader_parameter("to", Plane(14.0/255.0, 175.0/255.0, 155.0/255.0, 1))
			making_potion = false
