extends MarginContainer

## 退出游戏按钮
@onready var btn_quit: Button = %btn_quit
## 重新开始按钮
@onready var btn_replay: Button = %btn_replay

## 重新开始按钮按下时发出此信号
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
