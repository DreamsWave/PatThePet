extends Node

var pats_data: PatsData

func _ready() -> void:
	pats_data = PatsData.new()
	load_pats_data()
	SignalBus.total_pats_changed.connect(_pats_data_changed)
	SignalBus.passive_income_rate_changed.connect(_pats_data_changed)
	SignalBus.pats_per_click_changed.connect(_pats_data_changed)
	
func click() -> void:
	increase_pats(get_pats_per_click())

func has_enough_pats(amount: float) -> bool:
	return get_total_pats() >= amount

func add_passive_income() -> void:
	increase_pats(get_passive_income_rate())

func increase_pats(amount: float) -> void:
	set_total_pats(get_total_pats() + amount)

func spend_pats(amount: float) -> void:
	increase_pats(-amount)

func get_total_pats() -> float:
	return pats_data.total_pats

func set_total_pats(value: float) -> void:
	if get_total_pats() == value: 
		return
	pats_data.total_pats = value
	SignalBus.total_pats_changed.emit(value)

func get_passive_income_rate() -> float:
	return pats_data.passive_income_rate

func set_passive_income_rate(value: float) -> void:
	if get_passive_income_rate() == value:
		return
	pats_data.passive_income_rate = value
	SignalBus.passive_income_rate_changed.emit(value)

func get_pats_per_click() -> float:
	return pats_data.pats_per_click

func set_pats_per_click(value: float) -> void:
	if get_pats_per_click() == value:
		return
	pats_data.pats_per_click = value
	SignalBus.pats_per_click_changed.emit(value)

# Saving and loading functions
func _pats_data_changed(_new_value: float) -> void:
	save_pats_data()
	
func save_pats_data() -> void:
	var save_path: String = "res://Resources/pats_data.tres"
	ResourceSaver.save(pats_data, save_path)

func load_pats_data() -> void:
	var load_path: String = "res://Resources/pats_data.tres"
	if ResourceLoader.exists(load_path):
		pats_data = ResourceLoader.load(load_path) as PatsData
	else:
		pats_data = PatsData.new()
