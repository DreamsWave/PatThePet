extends Label

func _ready() -> void:
	_update_passive_income(StatsManager.game_stats.calculate_passive_income())
	SignalBus.passive_income_per_second_changed.connect(_update_passive_income)
	SignalBus.upgrade_level_changed.connect(_upgrade_level_changed)

func _update_passive_income(_new_passive_income: float) -> void:
	text = str("+" + Utils.to_scientific_notation(StatsManager.game_stats.calculate_passive_income()))
	
func _upgrade_level_changed(_new_level: int, _upgrade: UpgradeStats) -> void:
	text = str("+" + Utils.to_scientific_notation(StatsManager.game_stats.calculate_passive_income()))
