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
