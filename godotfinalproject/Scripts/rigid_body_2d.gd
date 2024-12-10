extends RigidBody2D

# 이동 속도 및 방향
var speed = 400  # 발사체 속도
var direction = Vector2.ZERO  # 발사체 방향

# 발사체 프리팹 (에디터에서 설정)
@export var projectile_scene: PackedScene

func _ready():
	# 초기 속도 설정
	linear_velocity = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# 마우스 클릭 방향으로 이동 설정
		var target_position = event.position
		direction = (target_position - global_position).normalized()
		linear_velocity = direction * speed

# 충돌 시 새로운 물체 생성
func _on_body_shape_entered(body_id: int, body: Node, shape_id: int, local_shape: int):
	print("Collided with:", body.name)

	# 충돌 법선 벡터 계산
	var collision_normal = get_collision_normal(body)
	if collision_normal != null:
		var new_direction = direction.bounce(collision_normal)
		print("New direction:", new_direction)

		# 새로운 물체 생성
		create_new_projectile(global_position, new_direction)

# 새로운 발사체 생성 함수
func create_new_projectile(position: Vector2, new_direction: Vector2):
	if projectile_scene:
		var new_projectile = projectile_scene.instance() as RigidBody2D
		get_parent().add_child(new_projectile)  # 부모 노드에 추가
		new_projectile.global_position = position
		new_projectile.set_direction_and_speed(new_direction, speed)

# 충돌 법선 계산 함수
func get_collision_normal(body: Node) -> Vector2:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsTestMotionResult2D.new()
	if space_state.intersect_motion(global_transform, query):
		return query.normal  # 충돌 법선 반환
	return Vector2.ZERO

# 새 발사체 설정 함수
func set_direction_and_speed(new_direction: Vector2, new_speed: float):
	direction = new_direction
	linear_velocity = direction * new_speed
