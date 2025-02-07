extends Node

enum CURSOR_STATES {
	EMPTY,
	DEFAULT,
	HAND,
	HAND_POINTER,
	HAND_PATTING
}

enum UPGRADE_EFFECT_TYPES {
	FLAT_INCREASE,
	PERCENTAGE_INCREASE,
	MULTIPLIER
}

enum BuyLvlAmount { 
	LVL_1, 
	LVL_10, 
	LVL_25, 
	LVL_100, 
	LVL_MAX 
}

func to_scientific_notation(number: float, to_int: bool = false) -> String:
	if number == 0:
		return "0"
	if (to_int): number = int(number)
	var number_str := str(number)
	# If the string representation of the number fits within MAX_DIGITS, return it as is
	if number_str.length() <= Global.MAX_DIGITS:
		return number_str
	# Convert to scientific notation if number_str length exceeds MAX_DIGITS
	var exponent: float = floor(log(abs(number)) / log(10))
	var coefficient: float = number / pow(10, exponent)
	# Format the coefficient with exactly two decimal places
	var formatted_coefficient: String = "%.2f" % coefficient
	return formatted_coefficient + "e" + str(exponent)
	
func get_upgrade_multiplier_for_buy_lvl(upgrade_stats: UpgradeStats, buy_lvl: BuyLvlAmount) -> int:
	match buy_lvl:
		Utils.BuyLvlAmount.LVL_1: return 1
		Utils.BuyLvlAmount.LVL_10: return 10
		Utils.BuyLvlAmount.LVL_25: return 25
		Utils.BuyLvlAmount.LVL_100: return 100
		Utils.BuyLvlAmount.LVL_MAX: 
			var max_level: int = upgrade_stats.max_level
			if max_level == -1:  # If no max level, return something arbitrary but very high
				return 9999  # This should be adjusted based on game logic
			var current_level: int = StatsManager.game_stats.get_upgrade_level(upgrade_stats)
			return max_level - current_level
		_: return 1  # Default case
