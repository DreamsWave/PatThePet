extends Control

@onready var total_pats_number_label: Label = %TotalPatsNumberLabel
@onready var pats_per_click_number_label: Label = %PatsPerClickNumberLabel
@onready var pats_per_second_number_label: Label = %PatsPerSecondNumberLabel

func _ready() -> void:
	init_stats()
	
	SignalBus.total_pats_changed.connect(_on_total_pats_changed)
	SignalBus.pats_per_click_changed.connect(_on_pats_per_click_changed)
	SignalBus.passive_income_per_second_changed.connect(_on_passive_income_per_second_changed)

func _on_total_pats_changed(total_pats: float) -> void:
	set_total_pats(total_pats)
func _on_pats_per_click_changed(ppc: float) -> void:
	set_pats_per_click(ppc)
func _on_passive_income_per_second_changed(pps: float) -> void:
	set_pats_per_second(pps)

func init_stats() -> void:
	var total_pats: float = StatsManager.game_stats.total_pats
	var pps: float = StatsManager.game_stats.calculate_passive_income()
	var ppc: float = StatsManager.game_stats.calculate_pats_per_click()
	set_total_pats(total_pats)
	set_pats_per_click(ppc)
	set_pats_per_second(pps)

func set_total_pats(total_pats: float) -> void:
	total_pats_number_label.text = str(Utils.to_scientific_notation(total_pats, true))
func set_pats_per_click(ppc: float) -> void:
	pats_per_click_number_label.text = str(Utils.to_scientific_notation(ppc))
func set_pats_per_second(pps: float) -> void:
	pats_per_second_number_label.text = str(Utils.to_scientific_notation(pps))
