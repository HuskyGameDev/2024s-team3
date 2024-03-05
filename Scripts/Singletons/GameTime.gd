extends Timer

const STORE_OPEN_TIME = 2;
const STORE_CLOSE_TIME = 4;

signal end_of_day;
signal start_of_day;

var hour:int = 0

func _ready():
	## If set to 1, 1 minute in game is 1 minute irl
	## If set to 2, 1 minute in game is 30 sec irl
	Engine.time_scale = 5;
	self.connect("timeout", _on_timer_timeout);
	self.connect("end_of_day", _on_end_of_day);
	self.connect("start_of_day", _on_start_of_day);
	start_of_day.emit();

func _on_timer_timeout():
	hour = hour + 1;
	if(hour >= STORE_CLOSE_TIME):
		end_of_day.emit();
		
func _on_end_of_day():
	print("End of day");
	self.stop();
	
func _on_start_of_day():
	print("Start of day")
	hour = STORE_OPEN_TIME;
	self.start(60);
