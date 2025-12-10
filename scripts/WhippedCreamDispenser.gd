extends Node2D

var is_dispensing = false
var cream_amount = 0.0
const MAX_CREAM = 1.0
const DISPENSE_SPEED = 0.5

signal cream_dispensed(amount)
signal cream_complete

@onready var dispenser_area = $DispenserArea
@onready var cream_visual = $CreamVisual

func _ready():
	dispenser_area.input_event.connect(_on_dispenser_input)
	cream_visual.visible = false

func _process(delta):
	if is_dispensing and cream_amount < MAX_CREAM:
		cream_amount += delta * DISPENSE_SPEED
		update_cream_visual()

		if cream_amount >= MAX_CREAM:
			is_dispensing = false
			emit_signal("cream_complete")

func update_cream_visual():
	cream_visual.visible = cream_amount > 0
	cream_visual.scale = Vector2(cream_amount, cream_amount)

func _on_dispenser_input(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		is_dispensing = event.pressed
		if is_dispensing:
			emit_signal("cream_dispensed", cream_amount)

func reset():
	cream_amount = 0.0
	is_dispensing = false
	cream_visual.visible = false
