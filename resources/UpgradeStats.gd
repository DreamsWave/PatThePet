class_name UpgradeStats
extends Resource

@export var name: String
@export var description: String
@export var base_price: float
@export var price_multiplier: float = 1.15
@export var effect_amount: float
@export var effect_type: Utils.UPGRADE_EFFECT_TYPES
@export var max_level: int = -1
@export var icon: Texture
@export var is_click_upgrade: bool = false

func get_price(level: float) -> float:
	return snapped(base_price * pow(price_multiplier, level), 0.01)

func can_purchase(level: int) -> bool:
	return max_level == -1 or level < max_level

func apply_effect(value: float, level: int) -> float:
	match effect_type:
		Utils.UPGRADE_EFFECT_TYPES.FLAT_INCREASE:
			return value + (effect_amount * level)
		Utils.UPGRADE_EFFECT_TYPES.PERCENTAGE_INCREASE:
			return value * pow(1 + effect_amount / 100, level)
		Utils.UPGRADE_EFFECT_TYPES.MULTIPLIER:
			return value * pow(effect_amount, level)
		_:
			return value
