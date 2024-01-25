extends RayCast3D

var timer: float = 0.0
@export var interval: float = 1.0

func _physics_process(delta):
	timer += delta
	if timer >= interval:
		timer -= interval
		do_heat_raycast()
		
func do_heat_raycast():
	self.global_position = %Player.global_position + Vector3(0,10,0)
	self.target_position = -self.global_position
	if self.is_colliding():
		print("In shadow")
	else:
		print("HOT!")
