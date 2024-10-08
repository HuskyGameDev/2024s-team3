extends Sprite2D


const START_LOCATION = Vector2(1800, 500)
const ONSCREEN_LOCATION = Vector2(1200, 500)
const END_LOCATION = Vector2(-650, 500)

var data: Customer
var walk_speed: float = 0.5


func with_data(data: Customer):
	self.data = data
	self.texture = ResourcePaths.get_random_customer_sprite()
	$DialogueLabel.text = data.order.dialogueOptions[randi() % data.order.dialogueOptions.size()]
	return self


func _ready():
	self.global_position = START_LOCATION
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", ONSCREEN_LOCATION, walk_speed)


func leave_store():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", END_LOCATION, walk_speed)
	tween.tween_callback(self.queue_free)
