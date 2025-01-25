extends Sprite2D

var cursor_textures: Dictionary = {
	Utils.CURSOR_STATES.EMPTY: load("res://assets/images/cursors/cursor-empty.png") as Texture,
	Utils.CURSOR_STATES.DEFAULT: load("res://assets/images/cursors/cursor-arrow.png") as Texture,
	Utils.CURSOR_STATES.HAND: load("res://assets/images/cursors/cursor-hand.png") as Texture,
	Utils.CURSOR_STATES.HAND_POINTER: load("res://assets/images/cursors/cursor-hand-pointer.png") as Texture,
	Utils.CURSOR_STATES.HAND_PATTING: load("res://assets/images/cursors/cursor-hand-patting.png") as Texture
}
var base_cursor_dimensions := Vector2(16, 16)
var initial_cursor_mode: Utils.CURSOR_STATES = Utils.CURSOR_STATES.DEFAULT
var current_cursor_mode: Utils.CURSOR_STATES
var base_screen_size: Vector2

func _ready() -> void:
	# Set base_screen_size to the initial viewport size
	base_screen_size = get_viewport().get_visible_rect().size
	set_cursor(initial_cursor_mode)
	get_window().size_changed.connect(_update_cursor)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

func _update_cursor(cursor_mode: Utils.CURSOR_STATES = Utils.CURSOR_STATES.DEFAULT) -> void:
	var cursor: CompressedTexture2D = cursor_textures.get(cursor_mode)
	if cursor == null: 
		return
	var scaled_image: Image = scale_cursor(cursor.get_image())
	Input.set_custom_mouse_cursor(ImageTexture.create_from_image(scaled_image), Input.CURSOR_ARROW)

func scale_cursor(image: Image) -> Image:
	var scale_factor: int = min(
		int(floor(get_window().size.x / base_screen_size.x)), 
		int(floor(get_window().size.y / base_screen_size.y))
	)
	image.resize(
		int(base_cursor_dimensions.x * scale_factor), 
		int(base_cursor_dimensions.y * scale_factor), 
		Image.INTERPOLATE_NEAREST
	)
	return image

func set_cursor(cursor_mode: Utils.CURSOR_STATES) -> void:
	if current_cursor_mode != cursor_mode:
		current_cursor_mode = cursor_mode
		_update_cursor(cursor_mode)
