class_name UpgradeManager
extends Resource

var upgrades: Array[Upgrade] = [
	preload("res://resources/upgrades/PettingMachineUpgrade.tres"),
	preload("res://resources/upgrades/TreatDispenserUpgrade.tres"),
	preload("res://resources/upgrades/DebugUpgrade.tres"),
]

func get_upgrade_cost(upgrade_name: String) -> float:
	for upgrade in upgrades:
		if upgrade.name == upgrade_name:
			return upgrade.get_price()
	return -1  # Not found

func purchase_upgrade(upgrade_name: String) -> bool:
	for upgrade in upgrades:
		if upgrade.name == upgrade_name and upgrade.can_purchase():
			if Global.pats_manager.has_enough_pats(upgrade.get_price()): 
				Global.pats_manager.spend_pats(upgrade.get_price())
				upgrade.level_up()
				apply_upgrade_effect(upgrade)
				return true
	return false

func apply_upgrade_effect(upgrade: Upgrade):
	var new_income = upgrade.apply_effect(Global.pats_manager.passive_income)
	Global.pats_manager.passive_income = new_income  
	
func display_upgrades(upgrades_container: Node):
	for upgrade in upgrades:
		var upgrade_ui = load("res://UI/Upgrade.tscn").instantiate()
		upgrade_ui.set_upgrade_data(upgrade)
		upgrades_container.add_child(upgrade_ui)
