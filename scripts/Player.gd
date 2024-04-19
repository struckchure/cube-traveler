extends CharacterBody3D

const PLAYER_SPEED := 6
const JUMP_VELOCITY := 4

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")

const TILE = preload("res://scenes/Tile.tscn")
@onready var animation_player: AnimationPlayer = $Body/Model/AnimationPlayer

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	var tile_instance := TILE.instantiate()
	var tile_width = tile_instance.size.x

	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := Vector3(input.x, 0, 0).normalized()

	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	if animation_player.current_animation != "running":
		animation_player.play("running", -1, 1.15)

	velocity.z = -PLAYER_SPEED

	if direction:
		velocity.x = clamp(direction.x, -tile_width, tile_width) * PLAYER_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, PLAYER_SPEED)

	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	move_and_slide()
