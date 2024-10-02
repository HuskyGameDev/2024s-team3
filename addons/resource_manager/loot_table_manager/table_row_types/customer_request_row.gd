@tool
extends "../loot_table_row.gd"

## Customer Request table type:
## [ CustomerOrder ]

var order:CustomerOrder :
	set(value):
		order = value
		#TODO update inputs


func set_data(data: CustomerOrder):
	self.order = data


func _ready():
	if not self.order: 
		self.order = CustomerOrder.new()
		self.order.minEffects = EffectSet.new()
		self.order.maxEffects = EffectSet.new()
		self.order.minEffects.set_all(-50)
		self.order.maxEffects.set_all(50)
	super()


func _on_rarity_changed(index):
	var old_rarity = self.rarity.to_lower()
	var new_rarity = $RarityOptions.get_item_text(index).to_lower()
	# remove from old section and add to new
	table[old_rarity].erase(order)
	table[new_rarity].append(order)
	# emit signal to move row
	rarity_changed.emit(self, old_rarity, new_rarity)
	self.rarity = new_rarity


func _on_dialogue_changed():
	var lines = $DialogueEdit.text.split("\n")
	# clear blanks
	while lines.has(""): lines.remove_at(lines.find(""))
	order.dialogueOptions = lines


func _on_min_effect_changed(key, value):
	order.minEffects.set_effect_by_key(key, value)


func _on_max_effect_changed(key, value):
	order.maxEffects.set_effect_by_key(key, value)


func _on_delete_button_pressed():
	table[self.rarity.to_lower()].erase(order)
	super()
