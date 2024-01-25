extends Node3D

@onready var book_rings: Array[Node3D] = [$BookRing_001, $BookRing_002, $BookRing_003]
@onready var shell = $Shell_Outer
@onready var cage = $Shell_Middle


@export var book_ring_speed: float = 0.05
@export var shell_speed: float = 0.01
@export var cage_speed: float= -0.01


var rng = RandomNumberGenerator.new()

func _ready():
	for br in book_rings:
		br.rotation.x = rng.randf_range(-180.0, 180.0)
		br.rotation.y = rng.randf_range(-180.0, 180.0)
		br.rotation.z = rng.randf_range(-180.0, 180.0)

func _process(delta):
	var n = 0
	for br in book_rings:
		n += 1
		var brs = book_ring_speed * 1/n * delta
		br.rotation.x += brs
		br.rotation.y += brs
		br.rotation.z += brs
	shell.rotation.z += shell_speed * delta
	cage.rotation.x += cage_speed * delta * 0.5
	cage.rotation.y += cage_speed * delta * 0.2
	cage.rotation.z += cage_speed * delta
	
