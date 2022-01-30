extends Node3D
class_name RingMaker

const ring_max = 100
const ringSpacing = 10
const ring_min_height = 25
const ring_max_height = 50
const ring_spawn_chance = 10

var ringSpawnRadius
var rings = []
var rng
var ringScene
var nodeRoot

func _init(_nodeRoot, chunk_size):
	self.ringSpawnRadius = chunk_size
	self.nodeRoot = _nodeRoot
	self.rng = RandomNumberGenerator.new()
	ringScene = preload("res://Scenes/ring.tscn")
	
func spawnRings(pos):
	# Spawn around the players position
	randomize()
	var p_x = int(pos.x)
	var p_z = int(pos.z)
	for x in range(p_x - ringSpawnRadius, p_x + ringSpawnRadius, ringSpacing):
		for z in range(p_z - ringSpawnRadius, p_z + ringSpawnRadius, ringSpacing):
			if len(rings) < ring_max:
				if (self.rng.randi() % ring_spawn_chance == 0):
					var y = self.rng.randi_range(ring_min_height, ring_max_height)
					self.placeRing(x,y,z)
			else:
				break

func placeRing(x,y,z):
	var ring = ringScene.instantiate()
	ring.position = (Vector3(x,y,z))
	ring.rotation.y = self.rng.randi_range(0,180)
	self.rings.append(ring)
	self.nodeRoot.add_child(ring)
