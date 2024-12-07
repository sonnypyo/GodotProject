extends RigidBody2D

var speed = 100
var direction = Vector2.ZERO

func _ready():
	linear_velocity = direction * speed

func _integrate_forces(state):
	# RigidBody2D는 충돌 데이터를 가져오기 위해 콜백이나 신호를 사용해야 함
	if test_move(global_transform, direction * speed * state.step):
		print("Collision detected!")  # 디버그용 메시지
		# 충돌에 대한 처리 추가 필요
