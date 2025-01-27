class_name GameStats
extends Resource

@export var total_pats: float = 0.0:
	set(value):
		if value != total_pats: 
			total_pats = value
			SignalBus.total_pats_changed.emit(value)

@export var passive_income_per_second: float = 0.0:
	set(value):
		if value != passive_income_per_second: 
			passive_income_per_second = value
			SignalBus.passive_income_per_second_changed.emit(value)

@export var pats_per_click: float = 1.0:
	set(value):
		if value != pats_per_click: 
			pats_per_click = value
			SignalBus.pats_per_click_changed.emit(value)

@export var upgrades: Array = []

class UpgradeData:
	var name: String
	var current_level: int

	func _init(upgrade_name: String, upgrade_level: int) -> void:
		name = upgrade_name
		current_level = upgrade_level

	func to_dict() -> Dictionary:
		return {"name": name, "current_level": current_level}

func add_pats_from_click() -> void:
	total_pats += pats_per_click

func has_sufficient_pats(amount: float) -> bool:
	return total_pats >= amount

func increase_pats(amount: float) -> void:
	total_pats += amount

func spend_pats(amount: float) -> void:
	increase_pats(-amount)

func get_upgrade_data(upgrade_name: String) -> UpgradeData:
	for upgrade in upgrades as Array[Dictionary]:
		if upgrade is Dictionary and upgrade.has("name") and upgrade["name"] == upgrade_name:
			return UpgradeData.new(upgrade["name"], upgrade["current_level"])
	return UpgradeData.new(upgrade_name, 0)  # Return a default UpgradeData if not found

func get_upgrade_level(upgrade_name: String) -> int:
	var upgrade_data: UpgradeData = get_upgrade_data(upgrade_name)
	return upgrade_data.current_level

func update_upgrade(upgrade_name: String, level: int) -> void:
	var upgrade_stats: UpgradeStats = UpgradeManager.get_upgrade_stats(upgrade_name)
	for i in upgrades.size():
		if upgrades[i] is Dictionary and upgrades[i]["name"] == upgrade_name:
			upgrades[i]["current_level"] = level
			SignalBus.upgrade_level_changed.emit(level, upgrade_stats)
			return
	upgrades.append({"name": upgrade_name, "current_level": level})
	SignalBus.upgrade_level_changed.emit(level, upgrade_stats)

func calculate_passive_income() -> float:
	var income: float = 0.0
	for upgrade in upgrades as Array[Dictionary]:
		var upgrade_stats: UpgradeStats = UpgradeManager.get_upgrade_stats(upgrade["name"])
		if upgrade_stats:
			income = upgrade_stats.apply_effect(income, upgrade["current_level"])
			# Here you can add other sources of passive income
			# income += some_other_income_source()
	return income

func update_passive_income() -> void:
	var new_income: float = calculate_passive_income()
	if new_income != passive_income_per_second:
		passive_income_per_second = new_income
		SignalBus.passive_income_per_second_changed.emit(new_income)

func accrue_passive_income() -> void:
	total_pats += passive_income_per_second
	update_passive_income()
