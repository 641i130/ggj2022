extends Spatial
class_name Drop

var mesh_instance
var noise
var x
var z
var chunk_size = 128
var should_remove = true

func _init(x, z):
	self.x = x
	self.z = z
	
func _ready():
	genDrop(x,z)
	
func _physics_process(delta):
	# Handle drop falling
	self.translation
	
	
func genDrop(x,z):
	randomize()
	# Make capsule mesh
	var capsule = MeshInstance.new()
	var drop = CapsuleMesh.new() # Base mesh we are modifying
	drop.size = Vector2(5,5)
	
	
	# MATERIAL
	drop.material = preload("res://cloud.material")
	
	capsule.mesh = drop
	
	
	
	add_child(capsule)
	
