@tool
extends Resource
class_name Effect

@export var id:String # ex: healing_poison
@export_range(0, 10) var reputation_factor:float
@export_range(0, 10) var money_factor:float

@export_group("Positive")
@export var pos_label: String
@export_color_no_alpha var pos_color: Color

@export_group("Negative")
@export var neg_label: String
@export_color_no_alpha var neg_color: Color
