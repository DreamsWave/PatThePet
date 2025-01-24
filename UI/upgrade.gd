extends PanelContainer

@onready var image = %Image
@onready var name_ui = %Name
@onready var level_ui = %Level
@onready var purchase_button_ui = %PurchaseButton

@export var upgrade_data: Upgrade
@export var is_button_disabled: bool = false

func _ready() -> void:
	if (upgrade_data):
		update_upgrade_data()
	_update_button_disabled()
	SignalBus.pats_changed.connect(_pats_changed)

func _pats_changed(_value) -> void:
	_update_button_disabled()

func _update_button_disabled() -> void:
	is_button_disabled = !Global.pats_manager.has_enough_pats(upgrade_data.get_price()) or !upgrade_data.can_purchase()
	purchase_button_ui.disabled = is_button_disabled

func _on_purchase_button_pressed() -> void:
	if (can_purchase_upgrade()):
		Global.upgrade_manager.purchase_upgrade(upgrade_data.name)
		update_upgrade_data()

func update_upgrade_data() -> void:
	if (upgrade_data):
		name_ui.text = upgrade_data.name
		if (upgrade_data.current_level > 0):
			level_ui.text = str("%s lvl" %Utils.to_scientific_notation(upgrade_data.current_level))
		else:
			level_ui.text = ""
		purchase_button_ui.text = str(Utils.to_scientific_notation(upgrade_data.get_price()))

func can_purchase_upgrade() -> bool:
	return Global.pats_manager.has_enough_pats(upgrade_data.get_price()) and upgrade_data.can_purchase()
