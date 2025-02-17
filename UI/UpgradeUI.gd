extends Control

@onready var purchase_button: Button = %PurchaseButton
@onready var upgrade_icon: TextureRect = %UpgradeIcon
@onready var upgrade_name_label: Label = %UpgradeNameLabel
@onready var upgrade_level_label: Label = %UpgradeLevelLabel
@onready var upgrade_passive_income_label: Label = %UpgradePassiveIncomeLabel
@onready var upgrade_pats_per_click_label: Label = %UpgradePatsPerClickLabel
@onready var upgrade_price_label: Label = %UpgradePriceLabel
@onready var buy_upgrade_label: Label = %BuyUpgradeLabel
@onready var upgrade_passive_income_hbox_container: HBoxContainer = %UpgradePassiveIncomeHBoxContainer
@onready var passive_income_center_container: CenterContainer = %PassiveIncomeCenterContainer
@onready var pats_per_click_center_container: CenterContainer = %PatsPerClickCenterContainer

@export var upgrade_stats: UpgradeStats
@export var is_button_disabled: bool = false
@export var buy_lvl_amount: Utils.BuyLvlAmount = Utils.BuyLvlAmount.LVL_1

func _ready() -> void:
	if upgrade_stats:
		update_ui()
		
	_update_purchase_button_state()
	SignalBus.total_pats_changed.connect(_on_total_pats_changed)
	SignalBus.upgrade_level_changed.connect(_on_upgrade_level_changed)
	SignalBus.selected_buy_lvl_changed.connect(_on_selected_buy_lvl_changed)

func _on_selected_buy_lvl_changed(buy_lvl: Utils.BuyLvlAmount) -> void:
	buy_lvl_amount = buy_lvl
	update_ui()
	_update_purchase_button_state()

func _on_total_pats_changed(_total_pats: float) -> void:
	update_ui()
	_update_purchase_button_state()

func _on_upgrade_level_changed(_new_level: int, changed_upgrade: UpgradeStats) -> void:
	if changed_upgrade == upgrade_stats:
		update_ui()
		_update_purchase_button_state()

func _update_purchase_button_state() -> void:
	if upgrade_stats:
		var current_level: int = StatsManager.game_stats.get_upgrade_level(upgrade_stats)
		var upgrade_price: float = get_upgrade_price()
		var can_afford: bool = StatsManager.game_stats.has_sufficient_pats(upgrade_price)
		is_button_disabled = !can_afford or !upgrade_stats.can_purchase(current_level)
		purchase_button.disabled = is_button_disabled

func _on_purchase_button_pressed() -> void:
	if can_purchase_upgrade():
		var levels_bought: int = UpgradeManager.purchase_upgrade(upgrade_stats.name, buy_lvl_amount)
		if levels_bought > 0:
			update_ui()  # Refresh the UI to show new upgrade level and price
			# Optionally, emit a signal to notify other parts of the game
			SignalBus.upgrade_purchased.emit(upgrade_stats.name, levels_bought)

func update_ui() -> void:
	if upgrade_stats:
		passive_income_center_container.visible = false
		pats_per_click_center_container.visible = false
		
		var upgrade_current_level: int = StatsManager.game_stats.get_upgrade_level(upgrade_stats)
		var upgrade_passive_income: float = UpgradeManager.get_upgrade_passive_income(upgrade_stats)
		var upgrade_ppc: float = UpgradeManager.get_upgrade_pats_per_click(upgrade_stats)
		var upgrade_price: int = snapped(get_upgrade_price(), 1)
		var lvl_amount: int = Utils.get_upgrade_multiplier_for_buy_lvl(upgrade_stats, buy_lvl_amount)
		
		if (upgrade_passive_income > 0.0): 
			passive_income_center_container.visible = true
		
		if (upgrade_ppc > 0.0): 
			pats_per_click_center_container.visible = true
		
		upgrade_icon.texture = upgrade_stats.icon
		upgrade_name_label.text = str(upgrade_stats.name)
		upgrade_level_label.text = "Lvl " + str(upgrade_current_level) if upgrade_current_level > 0 else ""
		upgrade_level_label.visible = upgrade_current_level > 0
		upgrade_passive_income_label.text = "+" + Utils.to_scientific_notation(upgrade_passive_income)
		upgrade_pats_per_click_label.text = "+" + Utils.to_scientific_notation(upgrade_ppc)
		buy_upgrade_label.text = "Buy " + (str("MAX") if buy_lvl_amount == Utils.BuyLvlAmount.LVL_MAX else str(lvl_amount))
		upgrade_price_label.text = Utils.to_scientific_notation(upgrade_price)
		upgrade_passive_income_hbox_container.visible = upgrade_current_level > 0

func get_upgrade_price() -> float:
	if !upgrade_stats: return 0
	var current_level: int = StatsManager.game_stats.get_upgrade_level(upgrade_stats)

	if buy_lvl_amount == Utils.BuyLvlAmount.LVL_MAX:
		return get_max_upgrade_price(current_level)
	else:
		return get_bulk_upgrade_price(current_level)

func get_max_upgrade_price(current_level: int) -> float:
	var available_pats: float = StatsManager.game_stats.total_pats
	var total_price: float = 0.0
	var levels_to_buy: int = 0
	
	while available_pats >= upgrade_stats.get_price(current_level + levels_to_buy):
		total_price += upgrade_stats.get_price(current_level + levels_to_buy)
		available_pats -= upgrade_stats.get_price(current_level + levels_to_buy)
		levels_to_buy += 1
		if upgrade_stats.max_level != -1 and current_level + levels_to_buy >= upgrade_stats.max_level:
			break
	
	# If no levels can be bought, show price for just the first level
	return total_price if levels_to_buy > 0 else upgrade_stats.get_price(current_level)

func get_bulk_upgrade_price(current_level: int) -> float:
	var levels_to_buy: int = Utils.get_upgrade_multiplier_for_buy_lvl(upgrade_stats, buy_lvl_amount)
	var total_price: float = 0.0
	var current_price: float = 0

	for i in range(levels_to_buy):
		# Here we're calculating the price for each level individually
		if current_level + i < upgrade_stats.max_level or upgrade_stats.max_level == -1:
			current_price = upgrade_stats.get_price(current_level + i)
			total_price += current_price

	return total_price

func can_purchase_upgrade() -> bool:
	if !upgrade_stats: return false
	var current_level: int = StatsManager.game_stats.get_upgrade_level(upgrade_stats)
	var upgrade_price: float = get_upgrade_price()
	return StatsManager.game_stats.has_sufficient_pats(upgrade_price) and upgrade_stats.can_purchase(current_level)
