extends Sprite2D


const START_LOCATION = Vector2(1800, 500)
const ONSCREEN_LOCATION = Vector2(1200, 500)
const END_LOCATION = Vector2(-650, 500)


var data: Customer
var walk_speed: float = 0.25


func with_data(data: Customer):
	self.data = data
	self.texture = ResourcePaths.get_random_customer_sprite()
	return self


func _ready():
	self.global_position = ONSCREEN_LOCATION
