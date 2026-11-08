extends Node

func _ready():
	print("TEST: init hp=", GameState.hp, " xp=", GameState.xp)
	GameState.pending_enemies = ["slime"]
	var battle = load("res://scenes/Battle.tscn").instance()
	add_child(battle)
	yield(get_tree().create_timer(0.2), "timeout")

	battle._on_attack()
	yield(get_tree().create_timer(0.2), "timeout")
	battle._on_target_pressed(battle.enemies[0])
	yield(get_tree().create_timer(2.2), "timeout")
	print("TEST: after attack state=", battle.state, " enemy_hp=", battle.enemies[0]["hp"], " player_hp=", GameState.hp)
	if battle.state != "player":
		print("TEST FAIL: expected player turn")
		get_tree().quit(1)
		return

	var hp_before_save = GameState.hp
	GameState.save_game()
	GameState.reset()
	var loaded = GameState.load_game()
	print("TEST: save/load loaded=", loaded, " hp=", GameState.hp, " level=", GameState.level)
	if not loaded or GameState.hp != hp_before_save or GameState.level != 1:
		print("TEST FAIL: save/load")
		get_tree().quit(1)
		return

	battle.enemies[0]["hp"] = 1
	battle._on_attack()
	yield(get_tree().create_timer(0.2), "timeout")
	battle._on_target_pressed(battle.enemies[0])
	yield(get_tree().create_timer(2.5), "timeout")
	print("TEST: victory state=", battle.state, " xp=", GameState.xp, " gold=", GameState.gold)
	if battle.state != "end" or GameState.xp <= 0:
		print("TEST FAIL: victory flow")
		get_tree().quit(1)
		return

	battle._end("victory")
	print("TEST: battle_result=", GameState.battle_result)
	if GameState.battle_result != "victory":
		print("TEST FAIL: end result")
		get_tree().quit(1)
		return

	print("TEST OK")
	get_tree().quit()
