extends Node2D
class_name Main

@onready var ui := $UI

func _ready() -> void:
	Global.main = self

func _on_timer_timeout() -> void:
	StatsManager.accrue_passive_income()
	if (Global.SAVING_ENABLED): 
		StatsManager.save_game_stats()
