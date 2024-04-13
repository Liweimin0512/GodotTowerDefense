extends MarginContainer

@onready var btn_quit: Button = %btn_quit
@onready var btn_replay: Button = %btn_replay

signal btn_replay_pressed

func _ready() -> void:
	btn_quit.pressed.connect(
		func() -> void:
			get_tree().quit()
	)
	btn_replay.pressed.connect(
		func() -> void:
			btn_replay_pressed.emit()
	)
