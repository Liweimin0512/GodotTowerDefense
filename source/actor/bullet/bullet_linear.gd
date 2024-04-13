extends Bullet
class_name BulletLinear

@export var P_EXPLOTION : PackedScene = null
@export var explote_damage : float = 8
var target_position = Vector2()  # 目标位置
var explotion = null

func initialize(target: Enemy) -> void:
	target_position = target.global_position
	var direction = (target_position - global_position).normalized()
	rotation = direction.angle()

func _process(delta):
	var step = speed * delta
	var move_vector = (target_position - global_position).normalized() * step
	global_position += move_vector
	if position.distance_to(target_position) < step:
		queue_free()  # 到达目标或超过一定距离后销毁

## 创建爆炸物
func create_explotion() -> void:
	explotion = P_EXPLOTION.instantiate()
	explotion.damage = explote_damage
	get_parent().add_child(explotion)
	explotion.global_position = global_position

func hit(enemy : Enemy) -> void:
	create_explotion()
	super(enemy)
