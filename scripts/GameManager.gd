extends Node

enum GameState {
	WAITING_FOR_ORDER,
	COOKING,
	SERVING
}

var current_state = GameState.WAITING_FOR_ORDER
var current_day = 1
var orders_completed = 0
var current_order = null

signal order_received(order_type)
signal order_completed
signal game_state_changed(new_state)

func _ready():
	start_day()

func start_day():
	print("Starting Day ", current_day)
	spawn_order()

func spawn_order():
	current_state = GameState.WAITING_FOR_ORDER
	await get_tree().create_timer(2.0).timeout
	current_order = "whipped_cream_crepe"
	emit_signal("order_received", current_order)
	current_state = GameState.COOKING
	emit_signal("game_state_changed", current_state)

func complete_order():
	orders_completed += 1
	current_state = GameState.SERVING
	emit_signal("order_completed")
	emit_signal("game_state_changed", current_state)

	await get_tree().create_timer(2.0).timeout

	if orders_completed < 5:
		spawn_order()
	else:
		print("Day complete!")
