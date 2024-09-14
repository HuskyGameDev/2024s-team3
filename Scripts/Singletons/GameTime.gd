extends Timer

const STORE_OPEN_TIME = 9;
const STORE_CLOSE_TIME = 17;
const GAME_TIME_SCALE = 30; # The number of irl seconds per 1 in game hour

signal end_of_day;
signal start_of_day;
signal pause; # signals when game is paused emitted by pause menu and connected to gametime and clock node

var hour:int = 0
var day:int = 1

func _ready():
	self.connect("pause", on_pause) # connect pause signal to self
	self.connect("timeout", _on_timer_timeout);
	self.connect("end_of_day", _on_end_of_day);
	self.connect("start_of_day", _on_start_of_day);

func _on_timer_timeout():
	hour = hour + 1;
	if hour >= STORE_CLOSE_TIME:
		end_of_day.emit();
		
func _on_end_of_day():
	day += 1;
	self.stop();
	
func _on_start_of_day():
	hour = STORE_OPEN_TIME;
	self.start(GAME_TIME_SCALE);

func start_day():
	start_of_day.emit();

func on_pause(): # signaled when game is paused or unpaused
	if self.is_paused(): # if paused
		self.set_paused(0) # unpause
	else:
		self.set_paused(1) # pause
