extends DirectionalLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	self.rotation = Vector3(-5,180,180)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.rotation.x += 0.04
