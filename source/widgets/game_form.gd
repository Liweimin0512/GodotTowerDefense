extends Control

@onready var h_box_container: HBoxContainer = %HBoxContainer
@onready var pb_health: ProgressBar = %pb_health
@onready var w_game_over: MarginContainer = $w_game_over
@onready var lab_coin: Label = %lab_coin

signal w_tower_released
signal replay_pressed

func _ready() -> void:
	for w_tower in h_box_container.get_children():
		w_tower.released.connect(
			func() -> void:
				if w_tower.can_place_tower(owner.coin):
					w_tower_released.emit(w_tower)
		)
	owner.health_changed.connect(
		func() -> void:
			update_pb_health_display()
	)
	w_game_over.btn_replay_pressed.connect(
		func() -> void:
			replay_pressed.emit()
	)
	replay()

## 重启游戏
func replay() -> void:
	update_pb_health_display()
	w_game_over.hide()

## 退出游戏
func game_over() -> void:
	w_game_over.show()

func update_pb_health_display() -> void:
	pb_health.value = owner.current_health
	pb_health.max_value = owner.max_health

func update_coin_display(coin : int) -> void:
	lab_coin.text = "金币： " + str(coin)
	for w_tower in h_box_container.get_children():
		w_tower.update_cost_display(coin)
