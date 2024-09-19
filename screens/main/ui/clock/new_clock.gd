extends Node2D

## If you want to change the number of nodes in the clock you have to change the radian divisor as well, both here and in the clock node script
## So 8 nodes would mean a radian divisor of 3, 4 nodes would be 2, etc
@export var radianDivisor = 6
@export var numberOfNodes = 12

@onready var clockNodeHolder = %ClockNode_Holder
@onready var markerHolder = %MarkerHolder
@onready var timer = $Timer
@onready var clockNodeInstance = preload("res://screens/main/ui/clock/clock_node.tscn")

signal timerWentOff

# Called when the node enters the scene tree for the first time.
func _ready():
	var markers = markerHolder.get_children()
	for x in numberOfNodes:
		var instance = clockNodeInstance.instantiate()
		clockNodeHolder.add_child(instance)
		
		instance.pivotPoint = %ClockFace
		instance.position = markers[0].position.rotated(x * PI/radianDivisor)
		instance.nodeSymbol.region_rect = Rect2((x * 6) + 1, 0, 4, 6)
	
	timer.wait_time = abs(GameTime.STORE_OPEN_TIME - GameTime.STORE_CLOSE_TIME) * GameTime.GAME_TIME_SCALE / 50.0
	print(timer.wait_time)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	emit_signal("timerWentOff")
