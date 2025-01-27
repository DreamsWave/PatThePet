extends Node

var upgrades_stats: Array[UpgradeStats] = [
	preload("res://Resources/upgrades/PettingMachineUpgrade.tres"),
	preload("res://Resources/upgrades/TreatDispenserUpgrade.tres"),
]

func _ready() -> void:
	UpgradeManager.load_upgrades()

func _on_game_exit() -> void:
	UpgradeManager.save_upgrades()

func get_upgrade_cost(upgrade_name: String) -> float:
	for upgrade in upgrades_stats:
		if upgrade.name == upgrade_name:
			return upgrade.get_price()
	return -1  # Not found

func purchase_upgrade(upgrade_name: String) -> bool:
	for upgrade in upgrades_stats:
		if upgrade.name == upgrade_name and upgrade.can_purchase():
			if StatsManager.game_stats.has_sufficient_pats(upgrade.get_price()): 
				StatsManager.game_stats.spend_pats(upgrade.get_price())
				upgrade.level_up()
				apply_upgrade_effect(upgrade)
				return true
	return false

func apply_upgrade_effect(upgrade: UpgradeStats) -> void:
	var new_passive_income_per_second: float = upgrade.apply_effect(StatsManager.game_stats.passive_income_per_second)
	StatsManager.game_stats.passive_income_per_second = new_passive_income_per_second

func reset_upgrades() -> void:
	for upgrade in upgrades_stats:
		upgrade.current_level = 0

func save_upgrades() -> void:
	var save_data: Dictionary = {}
	for upgrade in upgrades_stats:
		save_data[upgrade.name] = {
			"current_level": upgrade.current_level
		}

		var file := FileAccess.open("user://upgrades.save", FileAccess.WRITE)
		if file != null:
			file.store_var(save_data)
			file.close()
		else:
			push_error("Failed to open file for saving upgrades.")

func load_upgrades() -> void:
	if FileAccess.file_exists("user://upgrades.save"):
		var file := FileAccess.open("user://upgrades.save", FileAccess.READ)
		if file != null:
			var save_data: Dictionary = file.get_var() as Dictionary
			file.close()
			
			for upgrade in upgrades_stats:
				if save_data.has(upgrade.name):
					var saved_upgrade_data: Dictionary = save_data[upgrade.name]
					upgrade.current_level = saved_upgrade_data["current_level"]
					SignalBus.upgrade_level_changed.emit(upgrade.current_level, upgrade)
		else:
			push_error("Failed to read upgrades save file.")
