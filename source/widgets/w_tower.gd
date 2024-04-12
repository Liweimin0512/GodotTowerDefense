@tool
extends MarginContainer

@onready var sub_viewport: SubViewport = %SubViewport

@export var p_tower : PackedScene :
	set(value):
		p_tower = value
		if not sub_viewport : return
		update_display()
#var tower : Tower = null

signal released

func _ready() -> void:
	update_display()

func update_display() -> void:
	if not p_tower : return
	var tower = p_tower.instantiate()
	sub_viewport.add_child(tower)
	tower.position = Vector2(32, 32)
	tower.scale = Vector2.ONE * 0.5	


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			released.emit()
