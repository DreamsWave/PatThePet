class_name CursorManager
extends Node

var cursor_size = Vector2(48, 48)
var cursor_positions = {
	Utils.CURSOR_STATES.DEFAULT: Vector2(0, 0),
	Utils.CURSOR_STATES.HAND: Vector2(0, 1),
	Utils.CURSOR_STATES.HAND_POINTER: Vector2(1, 1),
	Utils.CURSOR_STATES.HAND_PATTING: Vector2(2, 1)
}
var cursor_hotspot = Vector2(0, 0)
var current_cursor_state: Utils.CURSOR_STATES

func _ready() -> void:
	#set_default_cursor()
	pass

func get_cursor_from_sheet(cursor_position: Vector2) -> Texture:
	var atlas = AtlasTexture.new()
	atlas.atlas = load("res://assets/images/cursors/cursors-test.png")
	#atlas.atlas = load("res://assets/images/cursors/cursors.png")
	atlas.region = Rect2(cursor_position * cursor_size, cursor_size)
	return atlas
	
func change_cursor_state(new_state: Utils.CURSOR_STATES):
	if current_cursor_state != new_state:
		current_cursor_state = new_state
		var cursor = get_cursor_from_sheet(cursor_positions[new_state])
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, cursor_hotspot)

func set_default_cursor() -> void:
	var cursor_default = get_cursor_from_sheet(cursor_positions[Utils.CURSOR_STATES.DEFAULT])
	var cursor_hand_pointer = get_cursor_from_sheet(cursor_positions[Utils.CURSOR_STATES.HAND_POINTER])
	Input.set_custom_mouse_cursor(cursor_default, Input.CURSOR_ARROW, cursor_hotspot)
	Input.set_custom_mouse_cursor(cursor_hand_pointer, Input.CURSOR_POINTING_HAND , cursor_hotspot)
