extends Control

var _font_cache = {}

func font(size):
	if not _font_cache.has(size):
		var df = DynamicFont.new()
		df.font_data = load("res://assets/fonts/DejaVuSans.ttf")
		df.size = size
		_font_cache[size] = df
	return _font_cache[size]

func label(text, size, color = Color(1, 1, 1)):
	var l = Label.new()
	l.text = text
	l.add_font_override("font", font(size))
	l.add_color_override("font_color", color)
	return l

func button(text, size, target, method):
	var b = Button.new()
	b.text = text
	b.add_font_override("font", font(size))
	b.rect_min_size = Vector2(150, 46)
	if target != null:
		b.connect("pressed", target, method)
	return b

func set_anchors_full(c):
	c.anchor_left = 0.0
	c.anchor_top = 0.0
	c.anchor_right = 1.0
	c.anchor_bottom = 1.0
