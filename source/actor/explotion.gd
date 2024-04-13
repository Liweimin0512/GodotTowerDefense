extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
## 伤害，由上层子弹提供
@export var damage : float = 10

signal exploted

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(
		func() -> void:
			_explote()
	)

## 爆炸
func _explote() -> void:
	for area : Area2D in area_2d.get_overlapping_areas():
		area.owner.damage(damage)
	queue_free()
	get_parent().remove_child(self)
	exploted.emit()
