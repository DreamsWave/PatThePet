extends PanelContainer

@onready var purchase_button = %Button

@export var disabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	purchase_button.disabled = disabled


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
