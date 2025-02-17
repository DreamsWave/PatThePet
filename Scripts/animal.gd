extends CharacterBody2D

func _on_mouse_entered() -> void:
	CursorManager.set_cursor(Utils.CURSOR_STATES.HAND_PATTING)

func _on_mouse_exited() -> void:
	CursorManager.set_cursor(Utils.CURSOR_STATES.DEFAULT)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		StatsManager.handle_click()
		ClickNumbers.display_number(StatsManager.game_stats.calculate_pats_per_click(), get_global_mouse_position())
