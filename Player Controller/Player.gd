extends KinematicBody2D
const UNIT_SIZE = 50
const SPEED = 4*UNIT_SIZE
const MAX_JUMP_HEIGHT = 4*UNIT_SIZE
const MIN_JUMP_HEIGHT = 1*UNIT_SIZE
const FLOOR = Vector2(0, -1)

var jump_duration = 0.5
var max_jump_velocity
var min_jump_velocity

var velocity = Vector2()
var is_jumping = false
var gravity

func _ready():
	$AnimatedSprite.play("run")
	gravity = 2*MAX_JUMP_HEIGHT / pow(jump_duration, 2)      # s = 1/2 at^2
	max_jump_velocity = -sqrt(2 * gravity * MAX_JUMP_HEIGHT) # v^2 = 2as
	min_jump_velocity = -sqrt(2 * gravity * MIN_JUMP_HEIGHT) # v^2 = 2as

func _physics_process(delta):
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$AnimatedSprite.flip_h = true
	else:
		velocity.x = 0
	
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			is_jumping = true
			velocity.y = max_jump_velocity
	
	if Input.is_action_just_released("ui_accept") && velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
	
	if velocity.y > 0 :
		is_jumping = false
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, FLOOR)