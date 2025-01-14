extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	Global.cursor_manager.change_cursor_state(Utils.CURSOR_STATES.PATTING)
	
func _on_mouse_exited() -> void:
	Global.cursor_manager.change_cursor_state(Utils.CURSOR_STATES.DEFAULT)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Global.pats_manager.make_click()
