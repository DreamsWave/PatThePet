extends Node

var upgrades: Array[Upgrade] = [
	preload("res://Resources/upgrades/PettingMachineUpgrade.tres"),
	preload("res://Resources/upgrades/TreatDispenserUpgrade.tres"),
	preload("res://Resources/upgrades/DebugUpgrade.tres"),
]

func get_upgrade_cost(upgrade_name: String) -> float:
	for upgrade in upgrades:
		if upgrade.name == upgrade_name:
			return upgrade.get_price()
	return -1  # Not found

func purchase_upgrade(upgrade_name: String) -> bool:
	for upgrade in upgrades:
		if upgrade.name == upgrade_name and upgrade.can_purchase():
			if PatsManager.has_enough_pats(upgrade.get_price()): 
				PatsManager.spend_pats(upgrade.get_price())
				upgrade.level_up()
				apply_upgrade_effect(upgrade)
				return true
	return false

func apply_upgrade_effect(upgrade: Upgrade) -> void:
	var new_passive_income_rate: float = upgrade.apply_effect(PatsManager.get_passive_income_rate())
	PatsManager.set_passive_income_rate(new_passive_income_rate)  
	
#func display_upgrades(upgrades_container: Node) -> void:
	#for upgrade in upgrades:
		#var upgrade_ui = load("res://UI/Upgrade.tscn").instantiate()
		#upgrade_ui.set_upgrade_data(upgrade)
		#upgrades_container.add_child(upgrade_ui)
