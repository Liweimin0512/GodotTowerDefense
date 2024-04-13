@tool
extends MarginContainer

@onready var sub_viewport: SubViewport = %SubViewport
@onready var lab_cost: Label = %lab_cost
@onready var tower: Tower = null

@export var p_tower : PackedScene :
	set(value):
		p_tower = value
		if not sub_viewport : return
		update_display()
#var tower : Tower = null

signal released

func _ready() -> void:
	var tower = sub_viewport.get_child(0)
	tower.queue_free()
	update_display()

func update_display() -> void:
	if not p_tower : return
	tower = p_tower.instantiate()
	sub_viewport.add_child(tower)
	tower.position = Vector2(32, 32)
	tower.scale = Vector2.ONE * 0.5	
	lab_cost.text = str(tower.cost)

func update_cost_display(coin : int) -> void:
	lab_cost.modulate = Color.RED if not can_place_tower(coin) else Color.WHITE

func can_place_tower(coin : int) -> bool:
	return tower.can_place_tower(coin)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			released.emit()
