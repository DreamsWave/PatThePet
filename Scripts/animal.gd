extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_mouse_entered() -> void:
	Global.cursor_manager.change_cursor_state(Utils.CURSOR_STATES.HAND_PATTING)

func _on_mouse_exited() -> void:
	Global.cursor_manager.change_cursor_state(Utils.CURSOR_STATES.DEFAULT)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Global.pats_manager.make_click()
