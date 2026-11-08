extends Node

const NPCS = [
	{
		"pos": Vector3(3, 0, -2),
		"color": Color(0.8, 0.5, 0.2),
		"name": "Villageois",
		"type": "talk",
		"lines": [
			"Bienvenue à Bourg-Feuille, aventurier !",
			"La forêt à l'est grouille de monstres...",
			"Le vieux cristal au centre du village sauve les voyageurs. Utilise-le !"
		]
	},
	{
		"pos": Vector3(-4, 0, 3),
		"color": Color(0.6, 0.3, 0.5),
		"name": "Marchande",
		"type": "talk",
		"lines": [
			"J'ai vendu ma dernière potion, désolée !",
			"Les gluants sont faibles, mais les loups... fais attention."
		]
	},
	{
		"pos": Vector3(0, 0, 4),
		"color": Color(0.5, 0.3, 0.9),
		"name": "Cristal de sauvegarde",
		"type": "save",
		"lines": []
	}
]

const FOREST_TREES = [
	Vector3(12, 0, -8), Vector3(15, 0, -3), Vector3(18, 0, -7), Vector3(21, 0, -2),
	Vector3(13, 0, 4), Vector3(16, 0, 8), Vector3(20, 0, 5), Vector3(23, 0, 9),
	Vector3(11, 0, 0), Vector3(24, 0, -6), Vector3(14, 0, -6), Vector3(19, 0, 2)
]

const ENCOUNTER_RECT = Rect2(10, -10, 15, 20)
const ENCOUNTER_RATE = 0.35

var player
var hud_label
var encounter_cooldown = 0.0
var npc_nodes = []

func _ready():
	_check_battle_result()
	_build_environment()
	_build_world()
	_build_player()
	_build_ui()

func _check_battle_result():
	if GameState.battle_result == "defeat":
		GameState.hp = GameState.max_hp
		GameState.mp = GameState.max_mp
		GameState.player_pos = Vector3(0, 1, 0)
		GameState.battle_result = ""
		var d = Dialogue.new("Cristal", [
			"Vous reprenez connaissance au village...",
			"Quelqu'un vous a soigné pendant votre sommeil."
		])
		add_child(d)
	elif GameState.battle_result != "":
		GameState.battle_result = ""
	encounter_cooldown = 2.0

func _build_environment():
	var env = Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.5, 0.65, 0.85)
	var we = WorldEnvironment.new()
	we.environment = env
	add_child(we)

	var light = DirectionalLight.new()
	light.rotation_degrees = Vector3(-55, -30, 0)
	light.light_energy = 1.0
	add_child(light)

func _build_world():
	var floor_body = StaticBody.new()
	add_child(floor_body)
	var floor_mi = MeshInstance.new()
	var floor_mesh = CubeMesh.new()
	floor_mesh.size = Vector3(60, 0.2, 60)
	floor_mi.mesh = floor_mesh
	floor_mi.material_override = Models.mat(Color(0.35, 0.55, 0.3))
	floor_mi.translation = Vector3(0, -0.1, 0)
	floor_body.add_child(floor_mi)
	var floor_shape = CollisionShape.new()
	var floor_box = BoxShape.new()
	floor_box.extents = Vector3(30, 0.1, 30)
	floor_shape.shape = floor_box
	floor_shape.translation = Vector3(0, -0.1, 0)
	floor_body.add_child(floor_shape)

	var patch = MeshInstance.new()
	var patch_mesh = CubeMesh.new()
	patch_mesh.size = Vector3(15, 0.05, 20)
	patch.mesh = patch_mesh
	patch.material_override = Models.mat(Color(0.25, 0.42, 0.22))
	patch.translation = Vector3(17.5, 0.03, 0)
	add_child(patch)

	var house = Models.house()
	house.translation = Vector3(-8, 0, -6)
	add_child(_make_static(house, 2.0))

	var crystal_light = OmniLight.new()
	crystal_light.translation = Vector3(0, 1.5, 4)
	crystal_light.light_color = Color(0.5, 0.3, 0.9)
	crystal_light.omni_range = 5
	add_child(crystal_light)

	for tree_pos in [[Vector3(-12, 0, 2)], [Vector3(6, 0, -8)], [Vector3(-6, 0, 8)]]:
		var t = Models.tree()
		t.translation = tree_pos[0]
		add_child(_make_static(t, 1.0))

	for pos in FOREST_TREES:
		var tree = Models.tree()
		tree.translation = pos
		add_child(_make_static(tree, 1.0))

	for npc_data in NPCS:
		var node
		if npc_data["type"] == "save":
			node = Models.crystal()
		else:
			node = Models.npc(npc_data["color"])
		node.translation = npc_data["pos"]
		add_child(node)
		npc_nodes.append({"node": node, "data": npc_data})

func _make_static(model, collision_radius):
	var body = StaticBody.new()
	body.translation = model.translation
	model.translation = Vector3.ZERO
	body.add_child(model)
	var shape = CollisionShape.new()
	var cylinder = CylinderShape.new()
	cylinder.radius = collision_radius
	cylinder.height = 2.0
	shape.shape = cylinder
	shape.translation = Vector3(0, 1.0, 0)
	body.add_child(shape)
	return body

func _build_player():
	var player_script = load("res://scripts/player.gd")
	player = player_script.new()
	player.translation = GameState.player_pos
	add_child(player)

func _build_ui():
	var layer = CanvasLayer.new()
	add_child(layer)
	hud_label = UI.label("", 20, Color(1, 1, 1))
	hud_label.margin_left = 12
	hud_label.margin_top = 10
	layer.add_child(hud_label)

	var help = UI.label("E / Entrée : parler", 16, Color(0.9, 0.9, 0.9))
	help.anchor_left = 1.0
	help.anchor_right = 1.0
	help.anchor_top = 1.0
	help.anchor_bottom = 1.0
	help.margin_left = -220
	help.margin_top = -28
	help.margin_bottom = -8
	layer.add_child(help)

func _process(delta):
	hud_label.text = "PV %d/%d   PM %d/%d   Niv %d   Or %d   Potions %d" % [
		GameState.hp, GameState.max_hp,
		GameState.mp, GameState.max_mp,
		GameState.level, GameState.gold, GameState.potions
	]
	encounter_cooldown -= delta
	if encounter_cooldown > 0 or _dialogue_open():
		return
	var pos = player.global_transform.origin
	if ENCOUNTER_RECT.has_point(Vector2(pos.x, pos.z)):
		if randf() < ENCOUNTER_RATE * delta:
			_start_battle()

func _dialogue_open():
	return get_tree().get_nodes_in_group("dialogue").size() > 0

func _start_battle():
	encounter_cooldown = 3.0
	var pool = ["slime", "slime", "slime", "goblin", "goblin", "wolf"]
	var count = 1
	if randf() < 0.35:
		count = 2
	GameState.pending_enemies = []
	for i in range(count):
		GameState.pending_enemies.append(pool[randi() % pool.size()])
	GameState.battle_result = ""
	get_tree().change_scene("res://scenes/Battle.tscn")

func _unhandled_input(event):
	if not event.is_action_pressed("interact"):
		return
	if _dialogue_open():
		return
	var npc = _nearest_npc()
	if npc == null:
		return
	var data = npc["data"]
	if data["type"] == "save":
		if GameState.save_game():
			add_child(Dialogue.new(data["name"], ["Votre progression a été sauvegardée."]))
		else:
			add_child(Dialogue.new(data["name"], ["Échec de la sauvegarde..."]))
	else:
		add_child(Dialogue.new(data["name"], data["lines"]))

func _nearest_npc():
	var player_pos = player.global_transform.origin
	var best = null
	var best_dist = 2.8
	for npc in npc_nodes:
		var dist = player_pos.distance_to(npc["node"].global_transform.origin)
		if dist < best_dist:
			best_dist = dist
			best = npc
	return best
