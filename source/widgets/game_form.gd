extends Control

@onready var h_box_container: HBoxContainer = %HBoxContainer

signal w_tower_released

func _ready() -> void:
	for w_tower in h_box_container.get_children():
		w_tower.released.connect(
			func() -> void:
				w_tower_released.emit(w_tower)
		)
