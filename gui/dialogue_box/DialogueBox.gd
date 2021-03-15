extends CanvasLayer

onready var TypingTimer = $TypingTimer
onready var label = get_node("Panel/Label")
onready var label_rect = label.get_rect()  # Cache the original pos
# The max number of lines that the label can hold
const MAX_LINES = 3

var typing_finished : bool = false

func _ready() -> void:
	reposition_label(label.text)

func _on_TypingTimer_timeout():
	get_node("Panel/Label").visible_characters += 1
	if get_node("Panel/Label").visible_characters == get_node("Panel/Label").text.length():
		typing_finished = true
		TypingTimer.stop()

func reposition_label(text):
	var regex = RegEx.new()
	regex.compile("\\n")
	# Assumes that there are no trailing newlines.
	var linecount = len(regex.search_all(text)) + 1

	var line_offset = label_rect.size.y / MAX_LINES / 2
	var top_offset = line_offset * (MAX_LINES - linecount)
	# Adjust the margin by the computed amount
	label.set_margin(MARGIN_TOP, label_rect.position.y + top_offset)
