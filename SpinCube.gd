extends MeshInstance3D
class_name SpinCube

@export var cubeIndex = Vector2(0, 0)
var spinning = false

func startSpinning():
	spinning = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spinning:
		self.rotate(Vector3(0, 0, 1), cubeIndex.x * delta)
		self.rotate(Vector3(1, 0, 0), cubeIndex.y * delta)
