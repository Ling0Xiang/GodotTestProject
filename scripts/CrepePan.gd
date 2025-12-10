extends Node2D

enum CookingStage {
	EMPTY,
	BATTER_POURED,
	SPREADING,
	COOKING,
	COOKED,
	FLIPPED,
	READY
}

var current_stage = CookingStage.EMPTY
var batter_spread_progress = 0.0
var cook_time = 0.0
var flip_cook_time = 0.0

const SPREAD_SPEED = 1.5
const COOK_DURATION = 3.0
const FLIP_COOK_DURATION = 2.0

signal crepe_ready
signal stage_changed(stage)

@onready var pan_area = $PanArea
@onready var batter_sprite = $BatterSprite
@onready var crepe_sprite = $CrepeSprite
@onready var spread_indicator = $SpreadIndicator

var is_dragging = false
var drag_start_pos = Vector2.ZERO

func _ready():
	batter_sprite.visible = false
	crepe_sprite.visible = false
	spread_indicator.visible = false

	pan_area.input_event.connect(_on_pan_input_event)

func _process(delta):
	match current_stage:
		CookingStage.SPREADING:
			if is_dragging:
				batter_spread_progress += delta * SPREAD_SPEED
				update_spread_visual()

				if batter_spread_progress >= 1.0:
					current_stage = CookingStage.COOKING
					emit_signal("stage_changed", current_stage)
					is_dragging = false
					spread_indicator.visible = false

		CookingStage.COOKING:
			cook_time += delta
			if cook_time >= COOK_DURATION:
				current_stage = CookingStage.COOKED
				emit_signal("stage_changed", current_stage)

		CookingStage.FLIPPED:
			flip_cook_time += delta
			if flip_cook_time >= FLIP_COOK_DURATION:
				current_stage = CookingStage.READY
				emit_signal("stage_changed", current_stage)
				emit_signal("crepe_ready")

func pour_batter():
	if current_stage == CookingStage.EMPTY:
		current_stage = CookingStage.BATTER_POURED
		batter_sprite.visible = true
		batter_sprite.modulate.a = 0.3
		batter_sprite.scale = Vector2(0.5, 0.5)
		emit_signal("stage_changed", current_stage)

func start_spreading():
	if current_stage == CookingStage.BATTER_POURED:
		current_stage = CookingStage.SPREADING
		spread_indicator.visible = true
		emit_signal("stage_changed", current_stage)

func update_spread_visual():
	var scale_val = lerp(0.5, 1.0, batter_spread_progress)
	batter_sprite.scale = Vector2(scale_val, scale_val)
	batter_sprite.modulate.a = lerp(0.3, 0.8, batter_spread_progress)

func flip_crepe():
	if current_stage == CookingStage.COOKED:
		current_stage = CookingStage.FLIPPED
		batter_sprite.visible = false
		crepe_sprite.visible = true
		crepe_sprite.modulate = Color(0.9, 0.8, 0.6)
		emit_signal("stage_changed", current_stage)

func get_cooked_crepe():
	if current_stage == CookingStage.READY:
		reset_pan()
		return true
	return false

func reset_pan():
	current_stage = CookingStage.EMPTY
	batter_spread_progress = 0.0
	cook_time = 0.0
	flip_cook_time = 0.0
	batter_sprite.visible = false
	crepe_sprite.visible = false
	spread_indicator.visible = false
	emit_signal("stage_changed", current_stage)

func _on_pan_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			if current_stage == CookingStage.BATTER_POURED:
				start_spreading()
				is_dragging = true
				drag_start_pos = event.position
			elif current_stage == CookingStage.COOKED:
				flip_crepe()
		else:
			is_dragging = false

	if event is InputEventScreenDrag or (event is InputEventMouseMotion and is_dragging):
		if current_stage == CookingStage.SPREADING:
			is_dragging = true
