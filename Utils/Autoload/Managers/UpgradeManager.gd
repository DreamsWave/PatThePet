extends Node

var upgrades_stats: Array[UpgradeStats] = [
	preload("res://Resources/upgrades/PatUpgrade.tres"),
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
	for upgrade_stats in upgrades_stats:
		if upgrade_stats.name == upgrade_name:
			var current_level: int = game_stats.get_upgrade_level(upgrade_stats)
			return upgrade_stats.get_price(current_level)
	return -1

func get_upgrade_passive_income(upgrade_stats: UpgradeStats) -> float:
	if (upgrade_stats.is_click_upgrade): return 0.0
	
	var upgrade_current_level: int = game_stats.get_upgrade_level(upgrade_stats)
	if (upgrade_current_level):
		var passive_income: float = upgrade_stats.apply_effect(0, upgrade_current_level)
		if (passive_income):
			return passive_income
	return 0.0
	
func get_upgrade_pats_per_click(upgrade_stats: UpgradeStats) -> float:
	if (not upgrade_stats.is_click_upgrade): return 0.0
	
	var upgrade_current_level: int = game_stats.get_upgrade_level(upgrade_stats)
	if (upgrade_current_level):
		var ppc: float = upgrade_stats.apply_effect(0, upgrade_current_level)
		if (ppc):
			return ppc
	return 0.0

func purchase_upgrade(upgrade_name: String, buy_amount: Utils.BuyLvlAmount = Utils.BuyLvlAmount.LVL_1) -> int:
	for upgrade in upgrades_stats:
		if upgrade.name == upgrade_name:
			var current_level: int = game_stats.get_upgrade_level(upgrade)
			var levels_to_buy: int = get_levels_to_buy(upgrade, current_level, buy_amount)
			var total_price: float = get_total_price_for_levels(upgrade, current_level, levels_to_buy)

			if game_stats.has_sufficient_pats(total_price):
				game_stats.spend_pats(total_price)
				for i in range(levels_to_buy):
					game_stats.update_upgrade(upgrade_name, current_level + i + 1)  # Increment level for each level bought
				return levels_to_buy
	return 0  # If no upgrade was found or couldn't afford

# Helper function to determine how many levels can be bought
func get_levels_to_buy(upgrade: UpgradeStats, current_level: int, buy_amount: Utils.BuyLvlAmount) -> int:
	if buy_amount == Utils.BuyLvlAmount.LVL_MAX:
		var available_pats: float = game_stats.total_pats
		var levels: int = 0
		while available_pats >= upgrade.get_price(current_level + levels):
			available_pats -= upgrade.get_price(current_level + levels)
			levels += 1
			if upgrade.max_level != -1 and current_level + levels >= upgrade.max_level:
				break
		return levels
	else:
		return Utils.get_upgrade_multiplier_for_buy_lvl(upgrade, buy_amount)

# Helper function to calculate the total price for buying levels
func get_total_price_for_levels(upgrade: UpgradeStats, current_level: int, levels_to_buy: int) -> float:
	var total_price: float = 0.0
	for i in range(levels_to_buy):
		if current_level + i < upgrade.max_level or upgrade.max_level == -1:
			total_price += upgrade.get_price(current_level + i)
	return total_price

func reset_upgrades() -> void:
	for upgrade in upgrades_stats:
		game_stats.update_upgrade(upgrade.name, 0)

func load_upgrades() -> void:
	for upgrade_stats in upgrades_stats:
		if game_stats.get_upgrade_level(upgrade_stats) == 0:
			game_stats.update_upgrade(upgrade_stats.name, 0)
	
func get_upgrade_stats(upgrade_name: String) -> UpgradeStats:
	for upgrade in upgrades_stats:
		if upgrade.name == upgrade_name:
			return upgrade
	return null
