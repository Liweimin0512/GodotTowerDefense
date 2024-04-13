@tool
extends MarginContainer

## 子视口
@onready var sub_viewport: SubViewport = %SubViewport
## 费用标签
@onready var lab_cost: Label = %lab_cost
## 塔
@onready var tower: Tower = null
## 塔场景
@export var P_TOWER : PackedScene :
	set(value):
		P_TOWER = value
		if not sub_viewport : return
		update_display()
#var tower : Tower = null

signal released

func _ready() -> void:
	var tower = sub_viewport.get_child(0)
	if tower:
		tower.queue_free()
	update_display()
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			released.emit()

## 更新显示
func update_display() -> void:
	if not P_TOWER : return
	tower = P_TOWER.instantiate()
	sub_viewport.add_child(tower)
	tower.position = Vector2(32, 32)
	tower.scale = Vector2.ONE * 0.5
	lab_cost.text = str(tower.cost)
	tower.add_to_group("cant free")

## 更新花费显示
func update_cost_display(coin : int) -> void:
	lab_cost.modulate = Color.RED if not can_place_tower(coin) else Color.WHITE

## 能否摆放建筑
func can_place_tower(coin : int) -> bool:
	return tower.can_place_tower(coin)

