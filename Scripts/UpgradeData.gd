class_name UpgradeData
extends Resource

@export var name: String
@export var description: String
@export var base_price: float
@export var price_multiplier: float = 1.15  # 15% increase each time
@export var effect_amount: float
@export var effect_type: Utils.UPGRADE_EFFECT_TYPES
@export var current_level: int = 0
@export var max_level: int = -1  # -1 for unlimited
@export var icon: Texture
