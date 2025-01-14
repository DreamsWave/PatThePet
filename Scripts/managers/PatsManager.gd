extends Node
class_name PatsManager

@export var pats: int = 0
@export var pats_per_click: int = 1

func set_pats(new_pats: int) -> void:
	pats = new_pats
	SignalBus.pats_changed.emit(new_pats)

func make_click() -> void:
	set_pats(pats + pats_per_click)
