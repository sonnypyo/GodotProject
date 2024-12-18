extends CharacterBody2D
#손준표
@onready var CloseEnemySprite2D = $CloseEnemySprit2D
@onready var CloseRange = $Area2D
@onready var CloseDead = $"../../../BackGound/CloseDead"
const TILE_SIZE = 60  # TileMap의 타일 크기

class PathFindingNode:
	var is_wall: bool
	var parent_node: PathFindingNode = null
	var x: int
	var y: int
	var g: int = 0
	var h: int = 0

	func initialize(_is_wall: bool, _x: int, _y: int):
		is_wall = _is_wall
		x = _x
		y = _y

	func f() -> int:
		return g + h

@export var bottom_left: Vector2i  # 격자 좌표 기준 하단 좌측
@export var top_right: Vector2i   # 격자 좌표 기준 상단 우측
@export var start_pos: Vector2i   # 시작 위치 (격자 좌표)
@export var target_pos: Vector2i  # 목표 위치 (격자 좌표)
@export var allow_diagonal: bool = true
@export var dont_cross_corner: bool = true
@export var WALL_LAYER: int = 3  # 충돌 레이어 ID 설정

var size_x: int
var size_y: int
var node_array: Array = []
var open_list: Array = []
var closed_list: Array = []
var final_node_list: Array = []
var start_node: PathFindingNode
var target_node: PathFindingNode
var cur_node: PathFindingNode


var CloseHP = 30
var player: Node2D
var move_speed = 100  # 이동 속도 (픽셀/초)
var target_world_position: Vector2 = Vector2.ZERO  # 목표 세계 좌표

func _ready():
	print("시작 노드 계산 디버깅cc:")
	print("bottom_left:", bottom_left)
	print("top_right:", top_right)
	print("start_pos:", start_pos)
	print("size_x:", size_x)
	print("size_y:", size_y)
	# 기본 애니메이션 실행
	CloseRange.visible = false
	CloseEnemySprite2D.stop()
	CloseEnemySprite2D.play("Idel")  # Idel 애니메이션 실행
	player = Globals.player
	
	var enemy_global_pos = global_position
	start_pos = Vector2i(
		int(enemy_global_pos.x / TILE_SIZE),
		int(enemy_global_pos.y / TILE_SIZE)
	)
	
	var player_global_pos = player.global_position
	target_pos = Vector2i(
		int(player_global_pos.x / TILE_SIZE),
		int(player_global_pos.y / TILE_SIZE)
	)
	print("Start Node:", start_pos.x, start_pos.y)
	print("Target Node:", target_pos.x, target_pos.y)
	

	# 초기 경로 탐색
	pathfinding()

func damage():
	if(CloseHP > 0):
		CloseEnemySprite2D.play("Sick")
		await get_tree().create_timer(1.0).timeout
		CloseEnemySprite2D.play("Idel")
		CloseHP -= 10
		

func _process(delta):
	# 스페이스바 입력 처리
	if (CloseHP <= 0):
		CloseEnemySprite2D.play("Dead")
		CloseDead.play()
		await get_tree().create_timer(1.0).timeout
		queue_free()
		print("죽음")

	if Input.is_action_just_pressed("ui_accept"):  # 스페이스바 기본 바인딩 키
		# 플레이어의 현재 위치를 기준으로 목표 지점 갱신
		CloseRange.visible = true
		var player_global_pos = player.global_position
		target_pos = Vector2i(
			int(player_global_pos.x / TILE_SIZE),
			int(player_global_pos.y / TILE_SIZE)
		)
		print("Target Node:", target_pos.x, target_pos.y)
		# 경로 탐색
		pathfinding()
		var next_node = final_node_list.front()
		var next_pos = Vector2i(next_node.x, next_node.y)
		if next_pos == target_pos:
			CloseEnemySprite2D.play("Hit")
			await get_tree().create_timer(1.0).timeout
			CloseEnemySprite2D.play("Idel")
			Globals.health_ui.decrease_health(0.5)
			
			print("Next node is target. Dealing damage.")
			# 여기 공격겨겨격겨겨겨겨겨겨격겨겨격겨겨격겨겨격겨겨겨격겨겨겨격겨겨겨겨ㅕㄱ
			apply_damage_to_target()
		# 다음 노드로 이동
		else :
			move_to_next_node()
		
func _physics_process(delta):
	# 목표 지점으로 천천히 이동
	if target_world_position != Vector2.ZERO:
		var direction = (target_world_position - global_position).normalized()
		velocity = direction * move_speed
		
		# 목표 위치에 거의 도달했으면 위치 고정
		if global_position.distance_to(target_world_position) < 2.0:
			global_position = target_world_position
			velocity = Vector2.ZERO  # 속도 초기화
			target_world_position = Vector2.ZERO  # 목표 초기화
		
		move_and_slide()

func pathfinding():
	size_x = top_right.x - bottom_left.x + 1
	size_y = top_right.y - bottom_left.y + 1
	node_array = []

	for i in range(size_x):
		var row = []
		for j in range(size_y):
			var is_wall = false
			var grid_position = Vector2(i + bottom_left.x, j + bottom_left.y)

			# 격자 중심을 기준으로 충돌 감지 (픽셀 좌표 변환 적용)
			var world_position = grid_position * TILE_SIZE + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
			var collision_rect = RectangleShape2D.new()
			collision_rect.extents = Vector2(TILE_SIZE / 2, TILE_SIZE / 2)  # 타일 크기
			var query = PhysicsShapeQueryParameters2D.new()
			query.shape = collision_rect
			query.transform = Transform2D(0, world_position)

			var colliders = get_world_2d().direct_space_state.intersect_shape(query)
			
			for col in colliders:
				
				if col.collider.collision_layer & (1 << WALL_LAYER) != 0:
				
					is_wall = true

			var new_node = PathFindingNode.new()
			new_node.initialize(is_wall, grid_position.x, grid_position.y)
			row.append(new_node)
		node_array.append(row)
	print("여기다")
	print(start_pos.x - bottom_left.x)
	print(start_pos.y - bottom_left.y)
	print(size_x)
	print(size_y)
	start_node = node_array[start_pos.x - bottom_left.x][start_pos.y - bottom_left.y]
	target_node = node_array[target_pos.x - bottom_left.x][target_pos.y - bottom_left.y]
	if target_node.is_wall:
		print("Target is a wall. Pathfinding aborted.")
		return
	open_list = [start_node]
	closed_list = []
	final_node_list = []
	
	while open_list.size() > 0:
		cur_node = open_list[0]
		for node in open_list:
			if node.f() < cur_node.f() or (node.f() == cur_node.f() and node.h < cur_node.h):
				cur_node = node
		
		open_list.erase(cur_node)
		closed_list.append(cur_node)
		
		if cur_node == target_node:
			var temp_node = target_node
			while temp_node != null and temp_node != start_node:  # 시작 노드는 제외
				final_node_list.append(temp_node)
				temp_node = temp_node.parent_node
			final_node_list.reverse()
			print("Path coordinates:")
			for node in final_node_list:
				print("(", node.x, ", ", node.y, ")")
			
			return
		add_neighbors(cur_node)


func add_neighbors(current_node: PathFindingNode):
	var directions = [
		Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)
	]
	if allow_diagonal:
		directions += [
			Vector2i(1, 1), Vector2i(-1, 1), Vector2i(-1, -1), Vector2i(1, -1)
		]

	for direction in directions:
		var neighbor_x = current_node.x + direction.x
		var neighbor_y = current_node.y + direction.y

		if neighbor_x >= bottom_left.x and neighbor_x < top_right.x + 1 and neighbor_y >= bottom_left.y and neighbor_y < top_right.y + 1:
			var neighbor = node_array[neighbor_x - bottom_left.x][neighbor_y - bottom_left.y]
			if neighbor.is_wall or closed_list.has(neighbor):
				continue 

			var move_cost = current_node.g + (10 if direction.x == 0 or direction.y == 0 else 14)
			if move_cost < neighbor.g or not open_list.has(neighbor):
				neighbor.g = move_cost
				neighbor.h = (abs(neighbor.x - target_node.x) + abs(neighbor.y - target_node.y)) * 10
				neighbor.parent_node = current_node
				open_list.append(neighbor)

func move_to_next_node():
	# 경로가 비어 있으면 아무것도 하지 않음
	if final_node_list.size() <= 1:
		return

	# 다음 노드를 확인
	var next_node = final_node_list.pop_front()
	var next_pos = Vector2i(next_node.x, next_node.y)
	
	var next_set = final_node_list.front()
	var next_xy = Vector2i(next_set.x, next_set.y)

	# 바로 다음 노드가 목표 노드인지 확인
	print(next_pos.x)
	print(next_pos.y)
	
	# 타겟이 아니면 다음 노드로 이동
	final_node_list.pop_front()  # 다음 노드를 경로에서 제거
	start_pos = Vector2i(next_node.x, next_node.y)
	target_world_position = Vector2(next_node.x, next_node.y) * TILE_SIZE + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)

	print("Moving towards: (", start_pos.x, ", ", start_pos.y, ")")
	await get_tree().create_timer(2.0).timeout
	CloseRange.visible = false

func apply_damage_to_target():
	# Physics 검사로 해당 타일에 있는 Area2D 확인
	var world_position = target_pos * TILE_SIZE + Vector2i(TILE_SIZE / 2, TILE_SIZE / 2)

	var query = PhysicsShapeQueryParameters2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = TILE_SIZE / 2

	query.shape = circle_shape
	query.transform = Transform2D(0, world_position)
	query.collide_with_areas = true

	#var results = get_world_2d().direct_space_state.intersect_shape(query)
	
	# 결과에서 "ball" 그룹에 속한 노드에 데미지 적용
	#for result in results:
	#	if result.collider.is_in_group("ball"):
	#		if result.collider.has_method("PlayerDamage"):				
	#			result.collider.PlayerDamage()
	#			print("Damage applied to target at: ", target_pos)
	
	#await get_tree().create_timer(2.0).timeout
	#CloseRange.visible = false
