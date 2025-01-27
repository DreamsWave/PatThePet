class_name UpgradeStats
extends Resource

@export var name: String
@export var description: String
@export var base_price: float
@export var price_multiplier: float = 1.15
@export var effect_amount: float
@export var effect_type: Utils.UPGRADE_EFFECT_TYPES
@export var current_level: int = 0:
	set(value):
		if (value != current_level):
			current_level = value
			SignalBus.upgrade_level_changed.emit(value, self)
@export var max_level: int = -1
@export var icon: Texture

func get_price() -> int:
	return round(base_price * pow(price_multiplier, current_level))

func apply_effect(current_income: float) -> float:
	match effect_type:
		Utils.UPGRADE_EFFECT_TYPES.FLAT_INCREASE:
			return current_income + effect_amount
		Utils.UPGRADE_EFFECT_TYPES.PERCENTAGE_INCREASE:
			return current_income * (1 + effect_amount / 100)
		Utils.UPGRADE_EFFECT_TYPES.MULTIPLIER:
			return current_income * effect_amount
		_:
			return current_income

func can_purchase() -> bool:
	return max_level == -1 or current_level < max_level

func level_up() -> bool:
	if can_purchase():
		current_level += 1
		return true
	return false
