extends Control

var upgrades_stats: Array[UpgradeStats] = [
	preload("res://Resources/upgrades/PatUpgrade.tres"),
	preload("res://Resources/upgrades/PettingMachineUpgrade.tres"),
	preload("res://Resources/upgrades/TreatDispenserUpgrade.tres")
]
@onready var upgrade_container: VBoxContainer = %UpgradeContainer

func _ready() -> void:
	display_upgrades()

func display_upgrades() -> void:
	for upgrade in upgrades_stats:
		var upgrade_ui := preload("res://UI/UpgradeUI.tscn").instantiate()
		upgrade_ui.upgrade_stats = upgrade
		upgrade_container.add_child(upgrade_ui)

func reset_all_upgrades() -> void:
	for upgrade in upgrades_stats:
		upgrade.current_level = 0
		SignalBus.upgrade_level_changed.emit(0, upgrade)
	display_upgrades()
