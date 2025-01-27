#class_name Upgrade
##extends Node
#
#var upgrade_data: UpgradeData
#
#func get_price() -> int:
	#return round(upgrade_data.base_price * pow(upgrade_data.price_multiplier, upgrade_data.current_level))
#
#func apply_effect(current_income: float) -> float:
	#match upgrade_data.effect_type:
		#Utils.UPGRADE_EFFECT_TYPES.FLAT_INCREASE:
			#return current_income + upgrade_data.effect_amount
		#Utils.UPGRADE_EFFECT_TYPES.PERCENTAGE_INCREASE:
			#return current_income * (1 + upgrade_data.effect_amount / 100)
		#Utils.UPGRADE_EFFECT_TYPES.MULTIPLIER:
			#return current_income * upgrade_data.effect_amount
		#_:
			#return current_income
#
#func can_purchase() -> bool:
	#return upgrade_data.max_level == -1 or upgrade_data.current_level < upgrade_data.max_level
#
#func level_up() -> bool:
	#if can_purchase():
		#upgrade_data.current_level += 1
		#return true
	#return false
