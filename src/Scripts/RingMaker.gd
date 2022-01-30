extends Node3D
class_name RingMaker

const ring_max = 100
const ringSpacing = 10
const ringSpawnRadius = 20
var rings = []
var rng
var ringScene
var nodeRoot

func _init(_nodeRoot):
	# Pass in player location
	self.nodeRoot = _nodeRoot
	self.rng = RandomNumberGenerator.new()
	ringScene = preload("res://Scenes/ring.tscn")
	
func spawnRings(pos):
	# Spawn around the players position
	randomize()
	var p_x = int(pos.x)/ringSpacing
	var p_z = int(pos.z)/ringSpacing
	for x in range(p_x - ringSpawnRadius, p_x + ringSpawnRadius):
		for z in range(p_z - ringSpawnRadius, p_z + ringSpawnRadius):
			if len(rings) < ring_max:
				if (self.rng.randi() % 10 == 0):
					var y = self.rng.randi_range(20,40)
					self.placeRing(x*ringSpawnRadius,y,z*ringSpawnRadius)
			else:
				break

func placeRing(x,y,z):
	var ring = ringScene.instantiate()
	ring.position = (Vector3(x,y,z))
	ring.rotation.y = self.rng.randi_range(0,180)
	# YEEEEEEE
	print(ring.position)
	self.rings.append(ring)
	self.nodeRoot.add_child(ring)
