extends Node

const SAVE_PATH = "user://save.dat"

var player_name = "Héros"
var level = 1
var xp = 0
var hp = 30
var max_hp = 30
var mp = 10
var max_mp = 10
var atk = 8
var def = 4
var mag = 6
var gold = 0
var potions = 3
var player_pos = Vector3(0, 1, 0)
var pending_enemies = []
var battle_result = ""

func _ready():
	randomize()

func reset():
	level = 1
	xp = 0
	max_hp = 30
	hp = max_hp
	max_mp = 10
	mp = max_mp
	atk = 8
	def = 4
	mag = 6
	gold = 0
	potions = 3
	player_pos = Vector3(0, 1, 0)
	pending_enemies = []
	battle_result = ""

func xp_to_next():
	return 10 + level * 10

func gain_xp(amount):
	xp += amount
	var lines = []
	while xp >= xp_to_next():
		xp -= xp_to_next()
		level += 1
		max_hp += 6
		max_mp += 2
		atk += 2
		def += 1
		mag += 1
		hp = max_hp
		mp = max_mp
		lines.append("Niveau %d atteint ! Stats améliorées." % level)
	return lines

func has_save_file():
	var f = File.new()
	return f.file_exists(SAVE_PATH)

func save_game():
	var f = File.new()
	if f.open(SAVE_PATH, File.WRITE) != OK:
		return false
	f.store_var(to_dict())
	f.close()
	return true

func load_game():
	var f = File.new()
	if not f.file_exists(SAVE_PATH):
		return false
	f.open(SAVE_PATH, File.READ)
	var d = f.get_var()
	f.close()
	if d == null:
		return false
	from_dict(d)
	return true

func to_dict():
	return {
		"player_name": player_name,
		"level": level,
		"xp": xp,
		"hp": hp,
		"max_hp": max_hp,
		"mp": mp,
		"max_mp": max_mp,
		"atk": atk,
		"def": def,
		"mag": mag,
		"gold": gold,
		"potions": potions,
		"player_pos": player_pos
	}

func from_dict(d):
	player_name = d.get("player_name", player_name)
	level = int(d.get("level", 1))
	xp = int(d.get("xp", 0))
	max_hp = int(d.get("max_hp", 30))
	hp = int(d.get("hp", max_hp))
	max_mp = int(d.get("max_mp", 10))
	mp = int(d.get("mp", max_mp))
	atk = int(d.get("atk", 8))
	def = int(d.get("def", 4))
	mag = int(d.get("mag", 6))
	gold = int(d.get("gold", 0))
	potions = int(d.get("potions", 3))
	player_pos = d.get("player_pos", Vector3(0, 1, 0))
