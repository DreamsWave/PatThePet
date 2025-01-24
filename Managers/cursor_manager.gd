extends CanvasLayer

var cursor_textures := {
	Utils.CURSOR_STATES.EMPTY: load("res://assets/images/cursors/cursor-empty.png"),
	Utils.CURSOR_STATES.DEFAULT: load("res://assets/images/cursors/cursor-arrow.png"),
	Utils.CURSOR_STATES.HAND: load("res://assets/images/cursors/cursor-hand.png"),
	Utils.CURSOR_STATES.HAND_POINTER: load("res://assets/images/cursors/cursor-hand-pointer.png"),
	Utils.CURSOR_STATES.HAND_PATTING: load("res://assets/images/cursors/cursor-hand-patting.png")
}
var base_cursor_dimensions := Vector2(16, 16)
var initial_cursor_mode: Utils.CURSOR_STATES = Utils.CURSOR_STATES.DEFAULT
var current_cursor_mode: Utils.CURSOR_STATES
var base_screen_size: Vector2

func _ready():
	$Sprite2D.hide()
	# Set base_screen_size to the initial viewport size
	base_screen_size = get_viewport().get_visible_rect().size
	set_cursor(initial_cursor_mode)
	get_window().size_changed.connect(_update_cursor)

func _process(_delta):
	$Sprite2D.global_position = $Sprite2D.get_global_mouse_position()

func _update_cursor(cursor_mode: Utils.CURSOR_STATES = Utils.CURSOR_STATES.DEFAULT):
	var cursor = cursor_textures.get(cursor_mode)
	if cursor == null: 
		return
	var scaled_image = scale_cursor(cursor.get_image())
	Input.set_custom_mouse_cursor(ImageTexture.create_from_image(scaled_image), Input.CURSOR_ARROW)

func scale_cursor(image: Image) -> Image:
	var scale_factor = min(
		floor(get_window().size.x / base_screen_size.x), 
		floor(get_window().size.y / base_screen_size.y)
	)
	image.resize(
		base_cursor_dimensions.x * scale_factor, 
		base_cursor_dimensions.y * scale_factor, 
		Image.INTERPOLATE_NEAREST
	)
	return image

func set_cursor(cursor_mode: Utils.CURSOR_STATES) -> void:
	if current_cursor_mode != cursor_mode:
		current_cursor_mode = cursor_mode
		_update_cursor(cursor_mode)
