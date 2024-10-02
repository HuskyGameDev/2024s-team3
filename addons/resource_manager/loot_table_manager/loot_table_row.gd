@tool
extends HBoxContainer

# signal sent to loot_table_manager to move row to new section
signal rarity_changed(row:HBoxContainer, rarity:String)

@onready var Options:OptionButton = $RarityOptions

var rarity:String
var table:LootTable

## Extended by each type of row
func set_data(data): pass


func with_data(rarity:String, table:LootTable):
	self.rarity = rarity
	self.table = table
	return self


func _ready():
	for i in Options.item_count:
		if Options.get_item_text(i) == self.rarity:
			Options.select(i)
			return


func _on_rarity_changed(index):
	var old = self.rarity
	var new = Options.get_item_text(index)
	# emit signal to move row
	rarity_changed.emit(self, old, new)
	self.rarity = new
