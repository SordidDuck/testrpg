class_name Dialogue
extends CanvasLayer

var speaker = ""
var lines = []
var idx = 0
var label
var hint_label

func _init(speaker_name, dialog_lines):
	speaker = speaker_name
	lines = dialog_lines

func _ready():
	add_to_group("dialogue")

	var panel = PanelContainer.new()
	panel.anchor_left = 0.0
	panel.anchor_right = 1.0
	panel.anchor_top = 1.0
	panel.anchor_bottom = 1.0
	panel.margin_left = 24
	panel.margin_right = -24
	panel.margin_top = -170
	panel.margin_bottom = -24
	add_child(panel)

	var vb = VBoxContainer.new()
	vb.add_constant_override("separation", 6)
	panel.add_child(vb)

	var name_label = UI.label(speaker, 22, Color(1, 0.85, 0.3))
	vb.add_child(name_label)

	label = UI.label(lines[0], 24, Color(1, 1, 1))
	label.autowrap = true
	label.rect_min_size = Vector2(860, 0)
	vb.add_child(label)

	hint_label = UI.label("E / Entrée pour continuer", 16, Color(0.6, 0.6, 0.6))
	vb.add_child(hint_label)

func _input(event):
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		get_tree().set_input_as_handled()
		idx += 1
		if idx >= lines.size():
			queue_free()
		else:
			label.text = lines[idx]
