extends Node2D
class_name Main

@onready var ui = $UI

func _ready() -> void:
	Global.main = self
	Global.cursor_manager.set_default_cursor() # Change. I guess it's better to set the default cursor in cursor manager


func _on_timer_timeout() -> void:
	Global.pats_manager.pats += Global.pats_manager.passive_income
