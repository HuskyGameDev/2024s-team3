extends PanelContainer

var moneyLabel:Label
var repBar:ProgressBar

func _ready():
	moneyLabel = $"MarginContainer/VBoxContainer/MoneyLabel"
	repBar = $"MarginContainer/VBoxContainer/HBoxContainer/RepBar"
	PlayerData.moneyChanged.connect(_updateLabels)
	PlayerData.reputationChanged.connect(_updateLabels)
	_updateLabels(null)

func _updateLabels(_val):
	moneyLabel.text = "$" + str(PlayerData.money)
	repBar.value = PlayerData.reputation
