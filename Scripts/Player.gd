extends KinematicBody2D


# Values of speed and force are in Pixels/Second
const HORIZONTAL_ACCEL = 100
const HORIZONTAL_MAX = 400
const HORIZONTAL_TOLERANCE = 150
const VERTICAL_MAX = 1000
const JUMP_FORCE = -1000
const GRAVITY = 50
const UP = Vector2(0,-1)

var motion = Vector2()

func _ready():
	pass

func _physics_process(delta):
	handle_movement()
	handle_animation()

func handle_movement():
	# Stores current actions pressed in variables
	var left = Input.is_action_pressed("ui_left") 
	var right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("ui_select")
	
	if left:
		motion.x -= HORIZONTAL_ACCEL
	if right:
		motion.x += HORIZONTAL_ACCEL
	if !left and !right:
		if motion.x > HORIZONTAL_TOLERANCE:
			motion.x -= HORIZONTAL_ACCEL
		elif motion.x <= -HORIZONTAL_TOLERANCE:
			motion.x += HORIZONTAL_ACCEL
		else:
			motion.x = 0
	if is_on_floor() and jump:
		motion.y = JUMP_FORCE
		
	# Applying gravity
	motion.y += GRAVITY
	
	# Makes sure the player does not reach speeds over the limit
	motion.x = clamp(motion.x, -HORIZONTAL_MAX, HORIZONTAL_MAX)
	motion.y = clamp(motion.y, -VERTICAL_MAX, VERTICAL_MAX)
	
	motion = move_and_slide(motion, UP)

func handle_animation():
	var new_anim = "idle"
	if motion.x != 0 and is_on_floor():
		new_anim = "walk"
	if motion.x < 0:
		$Sprite.flip_h = true
	if motion.x > 0:
		$Sprite.flip_h = false
	if $anim.current_animation != new_anim:
		$anim.play(new_anim)