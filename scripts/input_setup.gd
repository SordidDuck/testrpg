extends Node

const ACTIONS = {
	"move_up": {"keys": [KEY_W, KEY_UP], "joy": [JOY_DPAD_UP]},
	"move_down": {"keys": [KEY_S, KEY_DOWN], "joy": [JOY_DPAD_DOWN]},
	"move_left": {"keys": [KEY_A, KEY_LEFT], "joy": [JOY_DPAD_LEFT]},
	"move_right": {"keys": [KEY_D, KEY_RIGHT], "joy": [JOY_DPAD_RIGHT]},
	"interact": {"keys": [KEY_E, KEY_ENTER, KEY_SPACE], "joy": [JOY_BUTTON_0]},
	"cancel": {"keys": [KEY_ESCAPE, KEY_BACKSPACE], "joy": [JOY_BUTTON_1]}
}

func _ready():
	for action in ACTIONS:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for key in ACTIONS[action]["keys"]:
			var ev = InputEventKey.new()
			ev.scancode = key
			InputMap.action_add_event(action, ev)
		for btn in ACTIONS[action]["joy"]:
			var jev = InputEventJoypadButton.new()
			jev.button_index = btn
			InputMap.action_add_event(action, jev)
