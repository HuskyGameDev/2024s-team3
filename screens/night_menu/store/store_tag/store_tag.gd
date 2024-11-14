extends Node2D

signal buy_button_pressed

@onready var BuyContainer := $LabelContainer
@onready var Tag := $Tag

@export var price : int : 
	set(p):
		price = p
		if BuyContainer: BuyContainer.get_node("LabelVBox/PriceLabel").text = "Buy for $%s" % str(price)
@export var label : String :
	set(s):
		label = s
		if BuyContainer: BuyContainer.get_node("LabelVBox/ObjectLabel").text = label

var mouse_in_station : bool :
	set(i):
		mouse_in_station = i
		if mouse_in_station:
			BuyContainer.visible = true
			Tag.visible = false
		elif not mouse_in_station and not mouse_in_button:
			BuyContainer.visible = false
			Tag.visible = true
var mouse_in_button = false


func _ready():
	mouse_in_station = false


func _on_mouse_entered_buy_button():
	mouse_in_button = true


func _on_mouse_exited_buy_button():
	mouse_in_button = false
	if not mouse_in_station and not mouse_in_button:
		BuyContainer.visible = false
		Tag.visible = true


func _on_buy_button_pressed():
	buy_button_pressed.emit()
