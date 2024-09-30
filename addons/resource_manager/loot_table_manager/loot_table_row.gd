@tool
extends HBoxContainer

# signal sent to loot_table_manager to move row to new section
signal rarity_changed(row:HBoxContainer, rarity:String)

var rarity:String
@onready var Options:OptionButton = $OptionButton


func with_data(rarity:String):
	self.rarity = rarity
	return self


func _ready():
	for i in Options.item_count:
		if Options.get_item_text(i) == self.rarity:
			Options.select(i)
			return


func _on_rarity_changed(index):
	var old = self.rarity
	var new = Options.get_item_text(index)
	rarity_changed.emit(self, old, new)
	self.rarity = new
