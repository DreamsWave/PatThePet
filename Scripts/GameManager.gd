extends Node


@export var pats: int
@export var pats_per_click: int = 1

# CURSOR
enum CursorState {
	NORMAL,
	POINTER,
	PATTING
}
@onready var cursor_sheet = load("res://assets/images/cursorsheet.png")
var cursor_size = Vector2(48, 48)
var cursor_positions = {
	CursorState.NORMAL: Vector2(0, 0),
	CursorState.POINTER: Vector2(1, 0),
	CursorState.PATTING: Vector2(2, 0)
}
var cursor_hotspot = Vector2(24, 24)
var current_cursor_state = CursorState.NORMAL

signal pats_changed(pats)
signal pats_per_click_changed(pats)

func _ready() -> void:
	pats = 0
	Input.set_custom_mouse_cursor(get_cursor_from_sheet(cursor_positions[CursorState.NORMAL]), Input.CURSOR_ARROW, cursor_hotspot)

# EVENTS
func _on_animal_animal_pressed() -> void:
	var new_pats: int = pats + pats_per_click
	set_pats(new_pats)
	
	
func _on_animal_mouse_entered() -> void:
	change_cursor_state(CursorState.PATTING)


func _on_animal_mouse_exited() -> void:
	change_cursor_state(CursorState.NORMAL)
	
func _on_corgi_animal_animal_pressed() -> void:
	var new_pats: int = pats + pats_per_click
	set_pats(new_pats)
	
	
func _on_corgi_animal_mouse_entered() -> void:
	change_cursor_state(CursorState.PATTING)


func _on_corgi_animal_mouse_exited() -> void:
	change_cursor_state(CursorState.NORMAL)

func set_pats(new_pats: int) -> void:
	pats = new_pats
	pats_changed.emit(pats)
	

func change_cursor_state(new_state: int):
	if current_cursor_state != new_state:
		current_cursor_state = new_state
		var cursor = get_cursor_from_sheet(cursor_positions[new_state])
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, cursor_hotspot)

func get_cursor_from_sheet(cursor_position: Vector2) -> Texture:
	var atlas = AtlasTexture.new()
	atlas.atlas = cursor_sheet
	atlas.region = Rect2(cursor_position * cursor_size, cursor_size)
	return atlas
