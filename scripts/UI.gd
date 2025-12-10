extends CanvasLayer

@onready var day_label = $TopBar/DayLabel
@onready var orders_label = $TopBar/OrdersLabel
@onready var order_panel = $OrderPanel
@onready var order_details = $OrderPanel/OrderDetails

var current_day = 1
var orders_completed = 0
var total_orders = 5

func _ready():
	var game_manager = get_node("/root/Main/GameManager")
	if game_manager:
		game_manager.order_received.connect(_on_order_received)
		game_manager.order_completed.connect(_on_order_completed)

	update_ui()
	order_panel.visible = false

func update_ui():
	day_label.text = "Day " + str(current_day)
	orders_label.text = str(orders_completed) + "/" + str(total_orders)

func _on_order_received(order_type):
	order_panel.visible = true

	match order_type:
		"whipped_cream_crepe":
			order_details.text = "Whipped Cream Crepe\n\n1. Pour batter\n2. Spread it\n3. Flip when cooked\n4. Add whipped cream\n5. Serve!"

func _on_order_completed():
	orders_completed += 1
	update_ui()
	order_panel.visible = false
