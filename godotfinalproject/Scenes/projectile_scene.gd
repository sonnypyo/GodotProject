extends RigidBody2D

var direction = Vector2.ZERO  # 이동 방향
var speed = 400  # 이동 속도

func _ready():
	linear_velocity = direction * speed  # 초기 속도 설정

func set_direction_and_speed(new_direction: Vector2, new_speed: float):
	direction = new_direction.normalized()
	speed = new_speed
	linear_velocity = direction * speed
