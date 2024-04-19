extends Node3D

@export var tile: PackedScene
@export var obstacle: PackedScene

@onready var player: CharacterBody3D = $"../Player"

var TILE_WIDTH: int
var TILE_HEIGHT: int
var INITIAL_TERRAIN_DISTANCE: int
const TERRAIN_SPEED = 7

var random = RandomNumberGenerator.new()


func _ready():
	var tile_instance := tile.instantiate()

	TILE_WIDTH = tile_instance.size.x
	TILE_HEIGHT = tile_instance.size.z
	INITIAL_TERRAIN_DISTANCE = TILE_HEIGHT * 10

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	extend_terrain(-player.position.z)


func _on_timer_timeout():
	add_obstacle()

func _process(delta):
	player.position.z -= TERRAIN_SPEED * delta
	if player.position.z < TERRAIN_SPEED + 5:
		extend_terrain(-player.position.z + INITIAL_TERRAIN_DISTANCE)

func extend_terrain(length: int):
	var tile_instance := tile.instantiate()
	tile_instance.position.z = -1 * (length * TILE_HEIGHT * 4.5)

	add_child(tile_instance)


func add_obstacle(gap: int = 10):
	var obstacle_instance = obstacle.instantiate()
	var x_pos = random.randi_range(-gap / TILE_WIDTH, gap / TILE_WIDTH) * 0.3075
	var z_pos = player.position.z + TILE_HEIGHT + gap

	obstacle_instance.position.x = x_pos
	obstacle_instance.position.z = z_pos * 1.8

	add_child(obstacle_instance)
