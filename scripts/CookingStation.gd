extends Node2D

enum CookingStep {
	WAITING,
	POUR_BATTER,
	SPREAD_BATTER,
	WAIT_COOK,
	FLIP,
	WAIT_FLIP_COOK,
	TRANSFER_TO_PLATE,
	ADD_CREAM,
	SERVE
}

var current_step = CookingStep.WAITING
var has_crepe_on_plate = false

@onready var crepe_pan = $CrepePan
@onready var batter_bowl = $BatterBowl
@onready var plate = $Plate
@onready var cream_dispenser = $WhippedCreamDispenser
@onready var serving_area = $ServingArea
@onready var instruction_label = $UI/InstructionLabel

signal order_ready

func _ready():
	batter_bowl.input_event.connect(_on_batter_bowl_input)
	plate.input_event.connect(_on_plate_input)
	serving_area.input_event.connect(_on_serving_area_input)

	crepe_pan.stage_changed.connect(_on_crepe_stage_changed)
	cream_dispenser.cream_complete.connect(_on_cream_complete)

	update_instruction()

func start_new_order(order_type):
	current_step = CookingStep.POUR_BATTER
	update_instruction()

func update_instruction():
	match current_step:
		CookingStep.WAITING:
			instruction_label.text = "Waiting for order..."
		CookingStep.POUR_BATTER:
			instruction_label.text = "Tap the batter bowl to pour!"
		CookingStep.SPREAD_BATTER:
			instruction_label.text = "Drag to spread the batter!"
		CookingStep.WAIT_COOK:
			instruction_label.text = "Cooking..."
		CookingStep.FLIP:
			instruction_label.text = "Tap the pan to flip!"
		CookingStep.WAIT_FLIP_COOK:
			instruction_label.text = "Cooking the other side..."
		CookingStep.TRANSFER_TO_PLATE:
			instruction_label.text = "Tap the crepe to move to plate!"
		CookingStep.ADD_CREAM:
			instruction_label.text = "Hold the cream dispenser!"
		CookingStep.SERVE:
			instruction_label.text = "Tap the serving area to serve!"

func _on_batter_bowl_input(_viewport, event, _shape_idx):
	print("Batter bowl clicked! Event: ", event, " Current step: ", current_step)
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed and current_step == CookingStep.POUR_BATTER:
			print("Pouring batter!")
			crepe_pan.pour_batter()

func _on_crepe_stage_changed(stage):
	match stage:
		crepe_pan.CookingStage.BATTER_POURED:
			current_step = CookingStep.SPREAD_BATTER
			update_instruction()
		crepe_pan.CookingStage.COOKING:
			current_step = CookingStep.WAIT_COOK
			update_instruction()
		crepe_pan.CookingStage.COOKED:
			current_step = CookingStep.FLIP
			update_instruction()
		crepe_pan.CookingStage.FLIPPED:
			current_step = CookingStep.WAIT_FLIP_COOK
			update_instruction()
		crepe_pan.CookingStage.READY:
			current_step = CookingStep.TRANSFER_TO_PLATE
			update_instruction()

func _on_plate_input(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed and current_step == CookingStep.TRANSFER_TO_PLATE:
			if crepe_pan.get_cooked_crepe():
				has_crepe_on_plate = true
				plate.get_node("CrepeOnPlate").visible = true
				current_step = CookingStep.ADD_CREAM
				update_instruction()

func _on_cream_complete():
	current_step = CookingStep.SERVE
	update_instruction()

func _on_serving_area_input(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed and current_step == CookingStep.SERVE:
			serve_order()

func serve_order():
	plate.get_node("CrepeOnPlate").visible = false
	cream_dispenser.reset()
	has_crepe_on_plate = false
	current_step = CookingStep.WAITING
	update_instruction()
	emit_signal("order_ready")
