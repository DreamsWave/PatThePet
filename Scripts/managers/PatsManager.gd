class_name PatsManager
extends Node

@export var pats: float = 0:
	set(value): 
		if (pats == value): return
		pats = value
		SignalBus.pats_changed.emit(value)
		
@export var passive_income: float = 0:
	set(value): 
		if (passive_income == value): return
		passive_income = value
		SignalBus.pats_passive_income_changed.emit(value)
		
@export var pats_per_click: float = 1:
	set(value): 
		if (pats_per_click == value): return
		pats_per_click = value
		SignalBus.pats_per_click_changed.emit(value)

func click() -> void:
	pats += pats_per_click

func has_enough_pats(amount: float) -> bool:
	return pats >= amount

func spend_pats(amount: float) -> void:
	pats = pats - amount
