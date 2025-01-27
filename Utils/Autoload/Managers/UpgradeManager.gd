extends Node

var upgrades_stats: Array[UpgradeStats] = [
	preload("res://Resources/upgrades/PettingMachineUpgrade.tres"),
	preload("res://Resources/upgrades/TreatDispenserUpgrade.tres"),
]

var game_stats: GameStats

func _ready() -> void:
	if StatsManager:
		game_stats = StatsManager.game_stats
		if not game_stats:
			game_stats = GameStats.new() 
		load_upgrades()
	else:
		push_error("StatsManager not found.")

func get_upgrade_cost(upgrade_name: String) -> float:
	for upgrade in upgrades_stats:
		if upgrade.name == upgrade_name:
			var current_level: int = game_stats.get_upgrade_level(upgrade_name)
			return upgrade.get_price(current_level)
	return -1

func purchase_upgrade(upgrade_name: String) -> bool:
	for upgrade in upgrades_stats:
		if upgrade.name == upgrade_name:
			var current_level: int = game_stats.get_upgrade_level(upgrade_name)
			if game_stats.has_sufficient_pats(upgrade.get_price(current_level)):
				game_stats.spend_pats(upgrade.get_price(current_level))
				game_stats.update_upgrade(upgrade_name, current_level + 1)
				apply_upgrade_effect(upgrade)
				return true
	return false

func apply_upgrade_effect(upgrade: UpgradeStats) -> void:
	var current_income: float = game_stats.passive_income_per_second
	var current_level: int = game_stats.get_upgrade_level(upgrade.name)
	var new_passive_income_per_second: float = upgrade.apply_effect(current_income, current_level)
	game_stats.passive_income_per_second = new_passive_income_per_second

func reset_upgrades() -> void:
	for upgrade in upgrades_stats:
		game_stats.update_upgrade(upgrade.name, 0)

func load_upgrades() -> void:
	for upgrade in upgrades_stats:
		if game_stats.get_upgrade_level(upgrade.name) == 0:
			game_stats.update_upgrade(upgrade.name, 0)
	
func get_upgrade_stats(upgrade_name: String) -> UpgradeStats:
	for upgrade in upgrades_stats:
		if upgrade.name == upgrade_name:
			return upgrade
	return null
