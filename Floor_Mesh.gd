extends MeshInstance3D

@export var xNum = 11
@export var yNum = 11

@export var obj: PackedScene

var cubes: Array[SpinCube] = []
var sim: Array[bool] = []
var boxMesh = (self.mesh as BoxMesh)
var simRunning = false

var runCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var size = boxMesh.size
	size.x = xNum
	size.z = yNum
	boxMesh.size = size
	const scene = preload("res://spincube.tscn")
	
	var basePos = Vector3( - xNum / 2.0, 0, -yNum / 2.0)

	
	for x in range(xNum):
		for y in range(yNum):
			cubes.append(null)
			sim.append(false)
	
	
	for x in range(xNum):
		for y in range(yNum):
			var objInstance: SpinCube = scene.instantiate()
			var BoxSize = (objInstance.mesh as BoxMesh).size
			objInstance.position = basePos + Vector3(x + BoxSize.x / 2.0, (size.y + BoxSize.y) / 2.0, y + BoxSize.z / 2.0)
			objInstance.cubeIndex = Vector2(x, y)
			objInstance.visible = false
			var idx = getArrayIndex(x,y)
			cubes[idx] = objInstance
			
			add_child(objInstance)

func getArrayIndex(x:int, y:int) -> int:
	return (y * yNum) + x

func isValidCoord(x: int, y: int):
	return (x >= 0 and x<xNum) and (y >= 0 and y<yNum)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if simRunning:
		if runCount == 30:
			updateSim()
			runCount = 0
		else:
			runCount = runCount + 1
		updateDisplay()
	if Input.is_action_just_pressed("start"):
		initSim()
		simRunning = true
		updateDisplay()
	if Input.is_action_just_pressed("toggleVisible"):
		if false in sim:
			sim.fill(true)
		else:
			sim.fill(false)
		updateDisplay()

func updateDisplay():
	for x in range(xNum):
			for y in range(yNum):
				var idx = getArrayIndex(x,y)
				cubes[idx].visible = sim[idx]

func initSim():
	sim.fill(false)
	
	var rng = RandomNumberGenerator.new()
	for i in range((xNum * yNum) / 4):
		var x = rng.randi_range(0, xNum - 1)
		var y = rng.randi_range(0, yNum - 1)
		var idx = getArrayIndex(x,y)
		sim[idx] = true
	
func updateSim():
	var startTime = Time.get_ticks_msec()
	var newSim = sim.duplicate()
	for x in xNum:
		for y in yNum:
			var nCount = 0
			for dx in range(-1,2):
				for dy in range(-1,2):
					if isValidCoord(x + dx,y + dy):
						if(dx == 0 and dy == 0): continue
						if(sim[getArrayIndex(x + dx,y + dy)]):
							nCount = nCount + 1
			var idx = getArrayIndex(x,y)
			if(nCount == 3):
				pass
			if sim[idx]:
				if nCount < 2:
					newSim[idx] = false
				elif nCount < 4:
					newSim[idx] = true
				elif nCount > 3:
					newSim[idx] = false
			else:
				if nCount == 3:
					newSim[idx] = true
	sim = newSim
	var endTime = Time.get_ticks_msec()
	print(endTime - startTime)
