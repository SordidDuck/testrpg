class_name Models

static func mat(color, emission = Color(0, 0, 0)):
	var m = SpatialMaterial.new()
	m.albedo_color = color
	if emission != Color(0, 0, 0):
		m.emission_enabled = true
		m.emission = emission
		m.emission_energy = 0.8
	return m

static func mesh_instance(mesh, color, pos, emission = Color(0, 0, 0)):
	var mi = MeshInstance.new()
	mi.mesh = mesh
	mi.material_override = mat(color, emission)
	mi.translation = pos
	return mi

static func hero():
	var root = Spatial.new()
	var body = CapsuleMesh.new()
	body.radius = 0.35
	body.mid_height = 1.0
	root.add_child(mesh_instance(body, Color(0.2, 0.35, 0.75), Vector3(0, 0.8, 0)))
	var head = SphereMesh.new()
	head.radius = 0.22
	head.height = 0.44
	root.add_child(mesh_instance(head, Color(0.95, 0.8, 0.65), Vector3(0, 1.55, 0)))
	var sword = CubeMesh.new()
	sword.size = Vector3(0.08, 0.9, 0.08)
	root.add_child(mesh_instance(sword, Color(0.8, 0.8, 0.85), Vector3(0.45, 1.0, 0.2)))
	var guard = CubeMesh.new()
	guard.size = Vector3(0.25, 0.06, 0.06)
	root.add_child(mesh_instance(guard, Color(0.6, 0.45, 0.15), Vector3(0.45, 1.35, 0.2)))
	return root

static func npc(color):
	var root = Spatial.new()
	var body = CapsuleMesh.new()
	body.radius = 0.32
	body.mid_height = 1.0
	root.add_child(mesh_instance(body, color, Vector3(0, 0.8, 0)))
	var head = SphereMesh.new()
	head.radius = 0.2
	head.height = 0.4
	root.add_child(mesh_instance(head, Color(0.95, 0.8, 0.65), Vector3(0, 1.5, 0)))
	return root

static func tree():
	var root = Spatial.new()
	var trunk = CylinderMesh.new()
	trunk.top_radius = 0.15
	trunk.bottom_radius = 0.2
	trunk.height = 1.5
	root.add_child(mesh_instance(trunk, Color(0.4, 0.25, 0.12), Vector3(0, 0.75, 0)))
	var leaves = CylinderMesh.new()
	leaves.top_radius = 0.0
	leaves.bottom_radius = 1.0
	leaves.height = 2.2
	root.add_child(mesh_instance(leaves, Color(0.15, 0.45, 0.2), Vector3(0, 2.4, 0)))
	return root

static func house():
	var root = Spatial.new()
	var walls = CubeMesh.new()
	walls.size = Vector3(3.5, 2.5, 3.0)
	root.add_child(mesh_instance(walls, Color(0.75, 0.65, 0.5), Vector3(0, 1.25, 0)))
	var roof = PrismMesh.new()
	roof.size = Vector3(4.2, 1.6, 3.7)
	root.add_child(mesh_instance(roof, Color(0.6, 0.2, 0.15), Vector3(0, 3.3, 0)))
	var door = CubeMesh.new()
	door.size = Vector3(0.8, 1.4, 0.1)
	root.add_child(mesh_instance(door, Color(0.35, 0.2, 0.1), Vector3(0, 0.7, 1.52)))
	return root

static func crystal():
	var root = Spatial.new()
	var gem = PrismMesh.new()
	gem.size = Vector3(0.8, 1.8, 0.8)
	root.add_child(mesh_instance(gem, Color(0.5, 0.3, 0.9), Vector3(0, 0.9, 0), Color(0.4, 0.2, 0.9)))
	var base = CylinderMesh.new()
	base.top_radius = 0.5
	base.bottom_radius = 0.7
	base.height = 0.25
	root.add_child(mesh_instance(base, Color(0.4, 0.4, 0.42), Vector3(0, 0.12, 0)))
	return root

static func slime(color):
	var root = Spatial.new()
	var body = SphereMesh.new()
	body.radius = 0.55
	body.height = 1.1
	var mi = mesh_instance(body, color, Vector3(0, 0.55, 0))
	mi.scale = Vector3(1.0, 0.7, 1.0)
	root.add_child(mi)
	var eye_l = SphereMesh.new()
	eye_l.radius = 0.08
	eye_l.height = 0.16
	root.add_child(mesh_instance(eye_l, Color(0.1, 0.1, 0.1), Vector3(0.2, 0.7, 0.45)))
	var eye_r = SphereMesh.new()
	eye_r.radius = 0.08
	eye_r.height = 0.16
	root.add_child(mesh_instance(eye_r, Color(0.1, 0.1, 0.1), Vector3(-0.2, 0.7, 0.45)))
	return root

static func goblin(color):
	var root = Spatial.new()
	var body = CapsuleMesh.new()
	body.radius = 0.3
	body.mid_height = 0.9
	root.add_child(mesh_instance(body, color, Vector3(0, 0.6, 0)))
	var head = SphereMesh.new()
	head.radius = 0.24
	head.height = 0.48
	root.add_child(mesh_instance(head, Color(0.55, 0.75, 0.4), Vector3(0, 1.25, 0)))
	var club = CylinderMesh.new()
	club.top_radius = 0.08
	club.bottom_radius = 0.14
	club.height = 1.0
	var club_mi = mesh_instance(club, Color(0.35, 0.22, 0.1), Vector3(0.42, 0.9, 0.15))
	club_mi.rotation_degrees = Vector3(0, 0, 25)
	root.add_child(club_mi)
	return root

static func wolf(color):
	var root = Spatial.new()
	var body = CapsuleMesh.new()
	body.radius = 0.3
	body.mid_height = 1.2
	var body_mi = mesh_instance(body, color, Vector3(0, 0.6, 0))
	body_mi.rotation_degrees = Vector3(90, 0, 0)
	root.add_child(body_mi)
	var head = CubeMesh.new()
	head.size = Vector3(0.4, 0.35, 0.5)
	root.add_child(mesh_instance(head, color, Vector3(0, 0.75, 0.75)))
	var snout = CubeMesh.new()
	snout.size = Vector3(0.2, 0.18, 0.3)
	root.add_child(mesh_instance(snout, Color(0.7, 0.7, 0.72), Vector3(0, 0.68, 1.05)))
	return root

static func make_enemy(kind, color):
	if kind == "slime":
		return slime(color)
	elif kind == "goblin":
		return goblin(color)
	else:
		return wolf(color)
