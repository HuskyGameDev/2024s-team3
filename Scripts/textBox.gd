extends CanvasLayer

# const CHAR_READ_RATE = 0.05 # might use this

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

@export var order: String


func _ready(): # keep this there is a bug, for now
	add_text("text to be added!")

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide() # hides the text only
	
func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()
	
func add_text(next_text):
		label.text = order
		show_textbox()


