extends Node

var enemies = []
var state = "intro"
var end_result = ""
var target_callback = null
var hero_node
var stats_label
var enemy_label
var log_label
var actions_box
var target_box
var action_buttons = []

func _ready():
	_build_arena()
	_spawn_enemies()
	_build_ui()
	_refresh()
	_log("Des ennemis surgissent !")
	state = "player"
	_refresh()

func _build_arena():
	var env = Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.12, 0.1, 0.2)
	var we = WorldEnvironment.new()
	we.environment = env
	add_child(we)

	var light = DirectionalLight.new()
	light.rotation_degrees = Vector3(-50, -30, 0)
	add_child(light)

	var floor_mi = MeshInstance.new()
	var floor_mesh = CylinderMesh.new()
	floor_mesh.top_radius = 9
	floor_mesh.bottom_radius = 9
	floor_mesh.height = 0.5
	floor_mi.mesh = floor_mesh
	floor_mi.material_override = Models.mat(Color(0.3, 0.3, 0.38))
	floor_mi.translation = Vector3(0, -0.25, 0)
	add_child(floor_mi)

	hero_node = Models.hero()
	hero_node.translation = Vector3(-4, 0.5, 0)
	hero_node.rotation_degrees = Vector3(0, 90, 0)
	add_child(hero_node)

	var cam = Camera.new()
	cam.translation = Vector3(-1, 5, 11)
	add_child(cam)
	cam.look_at(Vector3(0, 1, 0), Vector3.UP)

func _spawn_enemies():
	var defs = EnemyData.ENEMIES
	var i = 0
	for key in GameState.pending_enemies:
		var d = defs[key]
		var node = Models.make_enemy(key, d["color"])
		node.translation = Vector3(2.5 + i * 2.8, 0.5, 0)
		node.rotation_degrees = Vector3(0, -90, 0)
		add_child(node)
		enemies.append({
			"key": key,
			"name": d["name"],
			"hp": d["hp"],
			"max_hp": d["hp"],
			"atk": d["atk"],
			"def": d["def"],
			"xp": d["xp"],
			"gold": d["gold"],
			"node": node
		})
		i += 1

func _build_ui():
	var layer = CanvasLayer.new()
	add_child(layer)

	stats_label = UI.label("", 22, Color(1, 1, 1))
	stats_label.margin_left = 14
	stats_label.margin_top = 12
	layer.add_child(stats_label)

	enemy_label = UI.label("", 22, Color(1, 0.6, 0.6))
	enemy_label.align = Label.ALIGN_RIGHT
	enemy_label.anchor_left = 1.0
	enemy_label.anchor_right = 1.0
	enemy_label.margin_left = -330
	enemy_label.margin_right = -14
	enemy_label.margin_top = 12
	layer.add_child(enemy_label)

	log_label = UI.label("", 24, Color(1, 1, 1))
	log_label.autowrap = true
	log_label.rect_min_size = Vector2(900, 60)
	log_label.anchor_top = 1.0
	log_label.anchor_bottom = 1.0
	log_label.margin_left = 30
	log_label.margin_top = -230
	log_label.margin_bottom = -170
	layer.add_child(log_label)

	actions_box = HBoxContainer.new()
	actions_box.alignment = BoxContainer.ALIGN_CENTER
	actions_box.anchor_left = 0.0
	actions_box.anchor_right = 1.0
	actions_box.anchor_top = 1.0
	actions_box.anchor_bottom = 1.0
	actions_box.margin_top = -100
	actions_box.margin_bottom = -20
	actions_box.add_constant_override("separation", 16)
	layer.add_child(actions_box)

	var btn_attack = UI.button("Attaquer", 24, self, "_on_attack")
	var btn_magic = UI.button("Magie", 24, self, "_on_magic")
	var btn_item = UI.button("Objet", 24, self, "_on_item")
	var btn_flee = UI.button("Fuir", 24, self, "_on_flee")
	action_buttons = [btn_attack, btn_magic, btn_item, btn_flee]
	for btn in action_buttons:
		actions_box.add_child(btn)

	target_box = VBoxContainer.new()
	target_box.add_constant_override("separation", 8)
	target_box.anchor_left = 1.0
	target_box.anchor_right = 1.0
	target_box.anchor_top = 0.0
	target_box.anchor_bottom = 0.0
	target_box.margin_left = -280
	target_box.margin_right = -20
	target_box.margin_top = 120
	target_box.visible = false
	layer.add_child(target_box)

func _refresh():
	stats_label.text = "PV %d/%d   PM %d/%d   Potions %d" % [
		GameState.hp, GameState.max_hp, GameState.mp, GameState.max_mp, GameState.potions
	]
	var lines = []
	for e in enemies:
		if e["hp"] <= 0:
			lines.append("%s : vaincu" % e["name"])
		else:
			lines.append("%s : %d/%d PV" % [e["name"], e["hp"], e["max_hp"]])
	enemy_label.text = "\n".join(PoolStringArray(lines))
	actions_box.visible = state == "player"

func _log(text):
	log_label.text = text

func _alive_enemies():
	var alive = []
	for e in enemies:
		if e["hp"] > 0:
			alive.append(e)
	return alive

func _on_attack():
	if state != "player":
		return
	_show_targets("_do_attack")

func _on_magic():
	if state != "player":
		return
	if GameState.mp < 4:
		_log("Pas assez de PM !")
		return
	_show_targets("_do_magic")

func _show_targets(method):
	target_callback = funcref(self, method)
	for child in target_box.get_children():
		child.queue_free()
	var alive = _alive_enemies()
	for e in alive:
		var btn = UI.button("%s (%d PV)" % [e["name"], e["hp"]], 20, null, "")
		btn.connect("pressed", self, "_on_target_pressed", [e])
		btn.rect_min_size = Vector2(240, 40)
		target_box.add_child(btn)
	var cancel_btn = UI.button("Annuler", 20, self, "_cancel_target")
	cancel_btn.rect_min_size = Vector2(240, 40)
	target_box.add_child(cancel_btn)
	target_box.visible = true
	actions_box.visible = false

func _cancel_target():
	target_box.visible = false
	state = "player"
	_refresh()

func _on_target_pressed(enemy):
	target_box.visible = false
	target_callback.call_func(enemy)

func _do_attack(enemy):
	state = "resolve"
	var dmg = int(max(1, GameState.atk * (0.8 + 0.4 * randf()) - enemy["def"]))
	enemy["hp"] -= dmg
	_log("Vous frappez %s : %d dégâts !" % [enemy["name"], dmg])
	_flash(enemy["node"])
	_refresh()
	yield(get_tree().create_timer(0.6), "timeout")
	_after_player_action()

func _do_magic(enemy):
	state = "resolve"
	GameState.mp -= 4
	var dmg = int(max(1, GameState.mag * 1.6 * (0.9 + 0.2 * randf()) - enemy["def"] * 0.5))
	enemy["hp"] -= dmg
	_log("Boule de feu sur %s : %d dégâts !" % [enemy["name"], dmg])
	_flash(enemy["node"])
	_refresh()
	yield(get_tree().create_timer(0.6), "timeout")
	_after_player_action()

func _on_item():
	if state != "player":
		return
	if GameState.potions <= 0:
		_log("Plus de potions !")
		return
	state = "resolve"
	GameState.potions -= 1
	GameState.hp = int(min(GameState.max_hp, GameState.hp + 15))
	_log("Vous buvez une potion : +15 PV.")
	_refresh()
	yield(get_tree().create_timer(0.6), "timeout")
	_after_player_action()

func _on_flee():
	if state != "player":
		return
	state = "resolve"
	if randf() < 0.5:
		_log("Vous prenez la fuite !")
		yield(get_tree().create_timer(0.7), "timeout")
		_end("fled")
	else:
		_log("Fuite échouée !")
		yield(get_tree().create_timer(0.7), "timeout")
		if _all_dead():
			_victory()
			return
		_enemy_turn()

func _after_player_action():
	if _all_dead():
		_victory()
		return
	_enemy_turn()

func _all_dead():
	return _alive_enemies().size() == 0

func _enemy_turn():
	state = "enemy"
	_refresh()
	for e in enemies:
		if e["hp"] <= 0:
			continue
		var dmg = int(max(1, e["atk"] * (0.8 + 0.4 * randf()) - GameState.def))
		GameState.hp -= dmg
		_log("%s attaque : %d dégâts !" % [e["name"], dmg])
		_flash(hero_node)
		_refresh()
		if GameState.hp <= 0:
			GameState.hp = 0
			_refresh()
			_defeat()
			return
		yield(get_tree().create_timer(0.7), "timeout")
	state = "player"
	_refresh()

func _victory():
	state = "end"
	end_result = "victory"
	var total_xp = 0
	var total_gold = 0
	for e in enemies:
		total_xp += e["xp"]
		total_gold += e["gold"]
	GameState.gold += total_gold
	var lines = GameState.gain_xp(total_xp)
	var msg = "Victoire ! +%d XP, +%d or." % [total_xp, total_gold]
	if lines.size() > 0:
		msg += " " + " ".join(PoolStringArray(lines))
	_log(msg)
	_refresh()

func _defeat():
	state = "end"
	end_result = "defeat"
	_log("Vous êtes vaincu...")

func _end(result):
	GameState.battle_result = result
	get_tree().change_scene("res://scenes/Overworld.tscn")

func _flash(node):
	for i in range(3):
		node.visible = false
		yield(get_tree().create_timer(0.05), "timeout")
		node.visible = true
		yield(get_tree().create_timer(0.05), "timeout")

func _unhandled_input(event):
	if state == "end" and event.is_action_pressed("interact"):
		_end(end_result)
