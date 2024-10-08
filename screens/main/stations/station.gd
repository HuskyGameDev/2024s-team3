extends Node

signal change_ingredient(ingredient:Ingredient, position:Vector2)

@export var action: Ingredient.Actions

@onready var center_of_station = self.position - Vector2(0, 80)

func _on_body_enter_mortar(body):
	if not "data" in body: return
	if not body.data is Ingredient: return
	if not body.data.can(action): return
	
	## Animate object movement to center of station
	body.gravity_scale = 0
	var ingredient_position = body.global_position
	var time_to_animate = (center_of_station.distance_to(ingredient_position)) / 1000
	var tween = create_tween().bind_node(body)
	tween.tween_property(body, "global_position", center_of_station, time_to_animate).from(ingredient_position)
	await tween.finished
	
	## Delete old ingredient and spawn new one
	body.queue_free()
	var new_ingredient_id = "%s_%s" % [Ingredient.action_to_string(action), body.data.id]
	var new_ingredient = load(ResourcePaths.get_ingredient_path(new_ingredient_id))
	$ValidArea/CollisionShape2D.disabled = true
	change_ingredient.emit(new_ingredient, center_of_station)
	await get_tree().create_timer(0.1).timeout # wait for item to be thrown of collision area
	$ValidArea/CollisionShape2D.disabled = false
