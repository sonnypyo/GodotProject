extends RigidBody2D

var speed = 400  # 이동 속도
var direction = Vector2.ZERO  # 이동 방향

func _ready():
	linear_velocity = Vector2.ZERO  # 초기 속도를 0으로 설정

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# 마우스 클릭 시 방향 설정
		var target_position = event.position
		direction = (target_position - global_position).normalized()  # 클릭 방향 계산
		linear_velocity = direction * speed  # 이동 속도 설정

# 충돌 시 반사 처리
func _on_body_shape_entered(body_id: int, body: Node, shape_id: int, local_shape: int):
	print("Collided with:", body.name)

	# 충돌 법선 벡터 계산
	var collision_normal = get_collision_normal(body)
	if collision_normal != null:
		direction = direction.bounce(collision_normal)  # 반사 방향 계산
		linear_velocity = direction * speed  # 새로운 속도 설정

# 충돌 법선 벡터 계산 함수
func get_collision_normal(body: Node) -> Vector2:
	# DirectSpaceState로 충돌 데이터를 가져옵니다.
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsTestMotionResult2D.new()
	
	# 충돌 테스트를 실행하고 결과 반환
	if space_state.intersect_motion(self.global_transform, query):
		return query.normal  # 충돌 법선 반환
	return Vector2.ZERO  # 충돌이 없으면 기본값 반환
