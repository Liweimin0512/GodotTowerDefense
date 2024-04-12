extends PathFollow2D

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var speed : float = 120
@export var max_hp : float = 100
var current_hp : float : set = _current_hp_setter

func _ready() -> void:
	current_hp = max_hp
	progress_bar.hide()

func _process(delta: float) -> void:
	progress += speed * delta
	#progress_bar.rotation_degrees = -rotation_degrees
	#_rotation_sprite()
	sprite_2d.rotation = rotation
	rotation = 0

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner is Bullet:
		current_hp -= area.owner.damage
		area.owner.queue_free()

func _current_hp_setter(value : float) -> void:
	current_hp = value
	progress_bar.value = value
	if current_hp < max_hp and not progress_bar.visible:
		progress_bar.show()
	if current_hp <= 0:
		queue_free()

func _rotation_sprite() -> void:
	# 获取当前offset的切线方向
	var path = get_parent() if get_parent() is Path2D else null
	if path and path.curve:
		var tangent = path.curve.get_tangent_at_offset(progress_ratio)
		sprite_2d.rotation = tangent.angle()
