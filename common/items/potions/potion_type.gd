extends Item
class_name Potion

@export var effects: EffectSet = EffectSet.new()


## Sets the item's name based on the potion's effects
func calculate_potion():
	effects.clear_neutrals()
	if effects.all_null(): 
		self.name = "Useless Potion"
		self.description = 'Maybe you can sell it as "Magic Water"'
		return
	else:
		var strongest = effects.get_strongest_as_strings()
		if strongest.size() > 3:
			self.name = "Confused Potion"
			self.description = "A potion that does too many things...or nothing?"
			return
		else:
			self.name = "%s Potion" % strongest[0]
			if strongest.size() == 1:
				self.description = "Potion with %s effects" % strongest[0].to_lower()
			elif strongest.size() == 2:
				self.description = "Potion with %s and %s effects" % [ strongest[0].to_lower(), strongest[1].to_lower() ]
			elif strongest.size() == 3:
				self.description = "Potion with %s, %s, and %s effects" % [ strongest[0].to_lower(), strongest[1].to_lower(), strongest[2].to_lower() ]
