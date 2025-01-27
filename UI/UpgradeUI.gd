extends Control

@onready var icon: TextureRect = %Image
@onready var name_label: Label = %Name
@onready var level_label: Label = %Level
@onready var purchase_button: Button = %PurchaseButton
@export var upgrade_stats: UpgradeStats
@export var is_button_disabled: bool = false

func _ready() -> void:
	if upgrade_stats:
		update_ui()
	_update_purchase_button_state()
	SignalBus.total_pats_changed.connect(_on_total_pats_changed)
	SignalBus.upgrade_level_changed.connect(_on_upgrade_level_changed)

func _on_total_pats_changed(_total_pats: float) -> void:
	_update_purchase_button_state()

func _on_upgrade_level_changed(_new_level: int, changed_upgrade: UpgradeStats) -> void:
	if changed_upgrade == upgrade_stats:
		update_ui()
		_update_purchase_button_state()

func _update_purchase_button_state() -> void:
	var current_level: int = StatsManager.game_stats.get_upgrade_level(upgrade_stats.name)
	var can_afford: bool = StatsManager.game_stats.has_sufficient_pats(upgrade_stats.get_price(current_level))
	is_button_disabled = !can_afford or !upgrade_stats.can_purchase(current_level)
	purchase_button.disabled = is_button_disabled

func _on_purchase_button_pressed() -> void:
	if can_purchase_upgrade():
		UpgradeManager.purchase_upgrade(upgrade_stats.name)

func update_ui() -> void:
	if upgrade_stats:
		var current_level: int = StatsManager.game_stats.get_upgrade_level(upgrade_stats.name)
		name_label.text = upgrade_stats.name
		level_label.text = "Lvl " + Utils.to_scientific_notation(current_level) if current_level > 0 else ""
		purchase_button.text = Utils.to_scientific_notation(upgrade_stats.get_price(current_level))
		icon.texture = upgrade_stats.icon

func can_purchase_upgrade() -> bool:
	var current_level: int = StatsManager.game_stats.get_upgrade_level(upgrade_stats.name)
	return StatsManager.game_stats.has_sufficient_pats(upgrade_stats.get_price(current_level)) and upgrade_stats.can_purchase(current_level)
