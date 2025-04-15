extends Timer

const STORE_OPEN_TIME = 9;
const STORE_CLOSE_TIME = 17;
const GAME_TIME_SCALE = 11.3; # The number of irl seconds per 1 in game hour

signal end_of_day;
signal end_of_night;
signal start_of_day;
signal pause; # signals when game is paused emitted by pause menu and connected to gametime and clock node
signal tutorial_time;


var hour:int = STORE_OPEN_TIME
var day:int = 1

func _ready():
	self.connect("pause", on_pause) # connect pause signal to self
	self.connect("timeout", _on_timer_timeout);
	self.connect("end_of_day", _on_end_of_day);
	self.connect("end_of_night", _on_end_of_night);
	self.connect("start_of_day", _on_start_of_day);
	#self.connect("tutorial_time", _on_tutorial);

#func _on_tutorial():
	#hour = STORE_OPEN_TIME - 1;
	#pause.emit()
	#print("It's Tutorial Time!")

func _on_timer_timeout():
	hour = hour + 1;
	if hour == STORE_CLOSE_TIME:
		end_of_day.emit();
		
func _on_end_of_day():
	#save the current state of the scene so items can be reloaded
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene()) #gets the main scene and all things it owns 
	ResourceSaver.save(packed_scene, "res://screens/main/packed_main.tscn" ) 
	#self.stop();
	
func _on_end_of_night():
	day = PlayerData.day # set day variables equal
	hour = STORE_OPEN_TIME
	
func _on_start_of_day():
	self.start(GAME_TIME_SCALE);

func start_day():
	hour = 1
	start_of_day.emit();

func on_pause(): # signaled when game is paused or unpaused
	print("PUASED")
	if self.is_paused(): # if paused
		self.set_paused(0) # unpause
	else:
		self.set_paused(1) # pause
