extends Node3D
class_name Chunk

var mesh_instance
var noise
var seed
var x
var z
var chunk_size
var should_remove = true

func _init(_noise, _x, _z, _chunk_size,seed):
	self.noise = _noise
	self.x = _x
	self.z = _z
	self.chunk_size = _chunk_size
	self.seed = seed
	
func _ready():
	generate_chunk()

func generate_chunk():
	noise = OpenSimplexNoise.new()
	noise.period = 200
	noise.octaves = 7
	noise.seed = self.seed
	print(noise.seed)
	var plane_mesh = PlaneMesh.new() # Base mesh we are modifying
	plane_mesh.size = Vector2(chunk_size,chunk_size)
	plane_mesh.subdivide_depth = chunk_size * 0.25
	plane_mesh.subdivide_width = chunk_size * 0.25
	
	# MATERIAL
	#plane_mesh.material = preload("res://cloud.material")
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh, 0)
	
	var array_plane = surface_tool.commit()
	
	var data_tool = MeshDataTool.new()
	data_tool.create_from_surface(array_plane,0)
	
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		vertex.y = noise.get_noise_3d(vertex.x + x,vertex.y,vertex.z + z) * 120 # Randomly set y values to make spiky
		data_tool.set_vertex(i,vertex)
		
	for i in range(array_plane.get_surface_count()):
		array_plane.clear_surfaces()#i)
		
	data_tool.commit_to_surface(array_plane)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_plane,0)
	surface_tool.generate_normals()
	
	self.mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = surface_tool.commit()
	
	add_child(self.mesh_instance)
