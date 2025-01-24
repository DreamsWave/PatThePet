extends Node2D
class_name Main

@onready var ui = $UI

func _ready() -> void:
	Global.main = self

func _on_timer_timeout() -> void:
	Global.pats_manager.pats += Global.pats_manager.passive_income
