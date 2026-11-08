extends Node

func _ready():
	var layer = CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var bg = ColorRect.new()
	bg.color = Color(0.08, 0.08, 0.16)
	UI.set_anchors_full(bg)
	layer.add_child(bg)

	var title = UI.label("TEST RPG", 64, Color(1, 0.9, 0.4))
	title.align = Label.ALIGN_CENTER
	title.set_anchors_preset(Control.PRESET_CENTER_TOP)
	title.margin_top = 70
	layer.add_child(title)

	var subtitle = UI.label("Un RPG fantasy low-poly pour PS Vita", 22, Color(0.7, 0.7, 0.8))
	subtitle.align = Label.ALIGN_CENTER
	subtitle.set_anchors_preset(Control.PRESET_CENTER_TOP)
	subtitle.margin_top = 150
	layer.add_child(subtitle)

	var box = VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_CENTER)
	box.add_constant_override("separation", 14)
	layer.add_child(box)

	var new_btn = UI.button("Nouvelle partie", 26, self, "_on_new")
	box.add_child(new_btn)

	var continue_btn = UI.button("Continuer", 26, self, "_on_continue")
	if not GameState.has_save_file():
		continue_btn.disabled = true
	box.add_child(continue_btn)

	var quit_btn = UI.button("Quitter", 26, self, "_on_quit")
	box.add_child(quit_btn)

	new_btn.grab_focus()

func _change_to_overworld():
	get_tree().change_scene("res://scenes/Overworld.tscn")

func _on_new():
	GameState.reset()
	_change_to_overworld()

func _on_continue():
	if GameState.load_game():
		_change_to_overworld()

func _on_quit():
	get_tree().quit()
