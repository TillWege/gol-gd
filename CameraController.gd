extends CharacterBody3D
const SPEED = 5.0

@onready var camera_3d = $Camera3D
@export var mouse_sensitivity: float = 0.1

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta):
	if Input.is_action_just_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# Handle jump.
	if Input.is_action_pressed("Up"):
		velocity.y = SPEED
	elif Input.is_action_pressed("Down"):
		velocity.y = -SPEED
	else:
		velocity.y = 0

	var velocity_plane = Vector2.ZERO
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity_plane.x = direction.x * SPEED
		velocity_plane.y = direction.z * SPEED
	else:
		velocity_plane.x = move_toward(velocity.x, 0, SPEED)
		velocity_plane.y = move_toward(velocity.z, 0, SPEED)
		
	velocity_plane = velocity_plane.rotated( - camera_3d.rotation.y)
	
	velocity.x = velocity_plane.x
	velocity.z = velocity_plane.y

	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_3d.rotation_degrees.y -= event.relative.x * mouse_sensitivity
		camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensitivity
