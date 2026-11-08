extends KinematicBody

const SPEED = 6.0
const TURN_SPEED = 2.8
const GRAVITY = 20.0
const BOUND = 28.0

var velocity = Vector3.ZERO

func _ready():
	add_to_group("player")
	add_child(Models.hero())
	var cam = Camera.new()
	cam.translation = Vector3(0, 5, 8)
	cam.rotation_degrees = Vector3(-32, 0, 0)
	add_child(cam)
	var shape = CollisionShape.new()
	var capsule = CapsuleShape.new()
	capsule.radius = 0.4
	capsule.height = 1.6
	shape.shape = capsule
	shape.translation = Vector3(0, 0.9, 0)
	add_child(shape)

func _dialogue_active():
	return get_tree().get_nodes_in_group("dialogue").size() > 0

func _physics_process(delta):
	var dir = Vector3.ZERO
	if not _dialogue_active():
		var turn = 0
		if Input.is_action_pressed("move_left"):
			turn += 1
		if Input.is_action_pressed("move_right"):
			turn -= 1
		rotate_y(turn * TURN_SPEED * delta)

		var forward = 0
		if Input.is_action_pressed("move_up"):
			forward += 1
		if Input.is_action_pressed("move_down"):
			forward -= 1

		var basis_z = -global_transform.basis.z
		dir = basis_z * forward

	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= GRAVITY * delta

	velocity.x = dir.x * SPEED
	velocity.z = dir.z * SPEED
	move_and_slide(velocity, Vector3.UP)

	var origin = global_transform.origin
	origin.x = clamp(origin.x, -BOUND, BOUND)
	origin.z = clamp(origin.z, -BOUND, BOUND)
	global_transform.origin = origin
	GameState.player_pos = origin
