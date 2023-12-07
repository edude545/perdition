extends CharacterBody3D

@onready var head = $Head
@onready var camera = $Head/Camera

@export var move_speed: float = 1.0
@export var sprint_mult: float = 3.0
@export var look_sensitivity: float = 1.0
@export var gravity: float = 0.1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89.9), deg_to_rad(89.9))

func _process(delta):
	var inp = Vector3(0,0,0)
	inp += head.global_transform.basis.z * (1 if Input.is_action_pressed("move_backward") else (-1 if Input.is_action_pressed("move_forward") else 0))
	inp += head.global_transform.basis.x * (1 if Input.is_action_pressed("move_right") else (-1 if Input.is_action_pressed("move_left") else 0))
	inp *= move_speed * (sprint_mult if Input.is_action_pressed("sprint") else 1) * self.scale.length()
	inp.y = velocity.y - gravity
	velocity = inp
	#velocity.y = vy
	move_and_slide()
