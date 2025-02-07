extends Control

# Container for displaying upgrades
@onready var upgrade_container: VBoxContainer = %UpgradesVBoxContainer

# Array to hold references to all level selection buttons
@onready var lvl_buttons: Array[Button] = []
# Dictionary to map level groups to buttons
var lvl_button_dict: Dictionary = {}
# Variable to keep track of the currently selected level group
var selected_buy_lvl: Utils.BuyLvlAmount = Utils.BuyLvlAmount.LVL_1

# Array of preload resources for upgrades
var upgrades_stats: Array[UpgradeStats] = [
	preload("res://Resources/upgrades/PatUpgrade.tres"),
	preload("res://Resources/upgrades/PettingMachineUpgrade.tres"),
	preload("res://Resources/upgrades/TreatDispenserUpgrade.tres")
]

func _ready() -> void:
	initialize_lvl_buttons()
	display_upgrades()

# Initialize all level buttons
func initialize_lvl_buttons() -> void:
	var names: Array[String] = ["LvlButton1", "LvlButton10", "LvlButton25", "LvlButton100", "LvlButtonMAX"]
	for i in names.size():
		var button: Button = find_child(names[i], true, false)
		if button:
			# Add the button to our array and dictionary
			lvl_buttons.append(button)
			lvl_button_dict[Utils.BuyLvlAmount.values()[i]] = button
		else:
			# Log a warning if a button is not found
			print("Warning: Button named ", names[i], " not found.")

	# Check if all expected buttons were found and initialized
	if lvl_buttons.size() != Utils.BuyLvlAmount.size():
		print("Error: Not all level buttons were found or initialized.")
	
	# Set the initial selected level button
	set_lvl_button_pressed(selected_buy_lvl)
	
# Update the UI to reflect which level button is pressed
func set_lvl_button_pressed(lvl: Utils.BuyLvlAmount) -> void:
	for button_key: Utils.BuyLvlAmount in lvl_button_dict:
		if lvl_button_dict.has(button_key):
			lvl_button_dict[button_key].button_pressed = (button_key == lvl)
	change_selected_lvl(lvl)

# Change the selected level and emit the signal
func change_selected_lvl(buy_lvl: Utils.BuyLvlAmount) -> void:
	selected_buy_lvl = buy_lvl
	SignalBus.selected_buy_lvl_changed.emit(buy_lvl)

# Display all upgrades in the container
func display_upgrades() -> void:
	reset_upgrade_container()
	for upgrade in upgrades_stats:
		var upgrade_ui := preload("res://UI/UpgradeUI.tscn").instantiate()
		upgrade_ui.upgrade_stats = upgrade
		upgrade_ui.buy_lvl_amount = selected_buy_lvl
		upgrade_container.add_child(upgrade_ui)

# Reset all upgrades to their initial state
func reset_all_upgrades() -> void:
	for upgrade in upgrades_stats:
		upgrade.current_level = 0
		SignalBus.upgrade_level_changed.emit(0, upgrade)
	display_upgrades()
	
# Clear the upgrade container
func reset_upgrade_container() -> void:
	var children := upgrade_container.get_children()
	for c in children:
		upgrade_container.remove_child(c)

# Handle when a level button is toggled
func _on_level_button_toggled(button: Button, toggled_on: bool) -> void:
	if toggled_on:
		for lvl: Utils.BuyLvlAmount in Utils.BuyLvlAmount.values():
			if lvl_button_dict[lvl] == button:
				set_lvl_button_pressed(lvl)
				break

# Specific handlers for each level button toggle, forwarding to the generic handler
func _on_lvl_button_1_toggled(toggled_on: bool) -> void:
	_on_level_button_toggled(lvl_button_dict[Utils.BuyLvlAmount.LVL_1], toggled_on)
func _on_lvl_button_10_toggled(toggled_on: bool) -> void:
	_on_level_button_toggled(lvl_button_dict[Utils.BuyLvlAmount.LVL_10], toggled_on)
func _on_lvl_button_25_toggled(toggled_on: bool) -> void:
	_on_level_button_toggled(lvl_button_dict[Utils.BuyLvlAmount.LVL_25], toggled_on)
func _on_lvl_button_100_toggled(toggled_on: bool) -> void:
	_on_level_button_toggled(lvl_button_dict[Utils.BuyLvlAmount.LVL_100], toggled_on)
func _on_lvl_button_max_toggled(toggled_on: bool) -> void:
	_on_level_button_toggled(lvl_button_dict[Utils.BuyLvlAmount.LVL_MAX], toggled_on)
