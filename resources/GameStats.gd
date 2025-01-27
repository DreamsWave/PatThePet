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

func add_pats_from_click() -> void:
	total_pats += pats_per_click

func has_sufficient_pats(amount: float) -> bool:
	return total_pats >= amount

func accrue_passive_income() -> void:
	total_pats += passive_income_per_second

func increase_pats(amount: float) -> void:
	total_pats += amount

func spend_pats(amount: float) -> void:
	increase_pats(-amount)
