extends Node

var main_theme: Theme = preload("res://main_theme.tres")

func display_number(value: float, position: Vector2, is_critical: bool = false, to_scientific_notation: bool = true) -> void:
	var number: Label = Label.new()
	number.global_position = Vector2(position.x + randf_range(-5, 15), position.y - 15)
	number.text = Utils.to_scientific_notation(value) if to_scientific_notation else str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color: Color = "#ffffff"
	if (is_critical):
		color = "#f2f9fd"
	if (value == 0):
		color = "#f8f8f8"
	
	number.theme = main_theme
	number.label_settings.font_color = color
	number.label_settings.outline_color = "#8495b8"
	number.label_settings.outline_size = 1
	number.label_settings.font_size = 16
	
	call_deferred("add_child", number)

	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(number, "position:y", number.position.y - randf_range(20, 40), 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property(number, "position:x", number.position.x - randf_range(-30, 30), 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property(number, "modulate:a", 0, 0.25).set_ease(Tween.EASE_IN).set_delay(0.25)
	await tween.finished
	number.queue_free()
