extends Camera3D

var target: Object = get_parent()
var smooth_speed: float
var offset: Vector3
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(target != null):
		self.translation = lerp(self.translation, target.translation + offset, smooth_speed * delta)
