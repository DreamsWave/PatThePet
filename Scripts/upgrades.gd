extends Control

@onready var upgrade_container = %UpgradeContainer

#func _ready():
	#Global.upgrade_manager.display_upgrades(upgrade_container)
#
#func _on_UpgradeUI_buy_button_pressed(upgrade_name):
	#if Global.upgrade_manager.purchase_upgrade(upgrade_name):
		## Refresh the UI or show purchase confirmation
		#Global.upgrade_manager.display_upgrades(upgrade_container)
	#else:
		## Display error or not enough points message
		#pass
