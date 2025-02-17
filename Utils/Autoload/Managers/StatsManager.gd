extends Node

@export var game_stats: GameStats

func _ready() -> void:
	load_game_stats()

func accrue_passive_income() -> void:
	game_stats.accrue_passive_income()

func handle_click() -> void:
	game_stats.add_pats_from_click()

func reset_game_stats() -> void:
	game_stats.total_pats = 0
	game_stats._passive_income_per_second = 0
	game_stats.passive_income_multiplier = 1.0
	game_stats._pats_per_click = 1
	game_stats.pats_per_click_multiplier = 1

func save_game_stats() -> void:
	var save_path: String = "res://Resources/game_stats.tres"
	ResourceSaver.save(game_stats, save_path)

func load_game_stats() -> void:
	var load_path: String = "res://Resources/game_stats.tres"
	if ResourceLoader.exists(load_path):
		game_stats = ResourceLoader.load(load_path) as GameStats
	else:
		game_stats = GameStats.new()
