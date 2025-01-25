extends Node2D
class_name Main

@onready var ui := $UI

func _ready() -> void:
	Global.main = self

func _on_timer_timeout() -> void:
	PatsManager.add_passive_income()
