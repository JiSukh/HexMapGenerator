extends CharacterBody3D

@export var speed: float
@export var mouse_sensitivity: float = 0.002

var velocity_: Vector3 = Vector3.ZERO
var yaw: float = 0.0
var pitch: float = 0.0

@onready var cam = $Camera3D

@onready var coord = $"../Coordinate/x"


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -PI/2, PI/2)
		rotation.y = yaw
		cam.rotation.x = pitch

func _physics_process(delta):
	var input_dir = Vector3.ZERO
	coord.text = "Global Coordinates: \n x: %f\n z: %f" % [transform.origin.x, transform.origin.z]
	# Forward/backward/strafe movement
	if Input.is_action_pressed("move_forward"):
		input_dir -= transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += transform.basis.x
		
	if Input.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Vertical movement
	if Input.is_action_pressed("move_up"):
		input_dir += Vector3.UP
	if Input.is_action_pressed("move_down"):
		input_dir -= Vector3.UP


	input_dir = input_dir.normalized()
	velocity = input_dir * speed
	move_and_slide()
	
func get_pos():
	return transform.origin
	
func _input(event):
	if Input.is_action_just_pressed("debug_tile_info"):
		var hex_world = $"../GridMap"  # or wherever your chunks are
		for chunk in hex_world.get_children():
			if chunk is HexChunk:
				chunk.show_debug_labels(true)


			
			
