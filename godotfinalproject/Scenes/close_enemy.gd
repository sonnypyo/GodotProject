extends CharacterBody2D
#손준표
@onready var CloseEnemySprite2D = $CloseEnemySprit2D
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
@export var WALL_LAYER: int = 1  # 충돌 레이어 ID 설정

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

func _ready():
	
	# 기본 애니메이션 실행
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
		CloseEnemySprite2D.play("sick")
		
		CloseHP -= 10
		print(CloseHP)
		
	elif(CloseHP == 0):
		print("죽음")
	
func _process(delta):
	# 스페이스바 입력 처리
	if Input.is_action_just_pressed("ui_accept"):  # 스페이스바 기본 바인딩 키
		# 플레이어의 현재 위치를 기준으로 목표 지점 갱신
		var player_global_pos = player.global_position
		target_pos = Vector2i(
			int(player_global_pos.x / TILE_SIZE),
			int(player_global_pos.y / TILE_SIZE)
		)
		print("Target Node:", target_pos.x, target_pos.y)
		# 경로 탐색
		pathfinding()
		
		# 다음 노드로 이동
		move_to_next_node()

func pathfinding():
	size_x = top_right.x - bottom_left.x + 1
	size_y = top_right.y - bottom_left.y + 1
	node_array = []

	for i in range(size_x):
		var row = []
		for j in range(size_y):
			var is_wall = false
			var grid_position = Vector2(
				i + bottom_left.x,
				j + bottom_left.y
			)

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

		if neighbor_x >= bottom_left.x and neighbor_x <= top_right.x and neighbor_y >= bottom_left.y and neighbor_y <= top_right.y:
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
	# 다음 노드로 이동
	var next_node = final_node_list.pop_front()
	start_pos = Vector2i(next_node.x, next_node.y)
	var world_position = Vector2(next_node.x, next_node.y) * TILE_SIZE
	position = world_position + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)

func _draw():
	"""
	for row in node_array:
		for node in row:
			var position = Vector2(node.x, node.y) * TILE_SIZE + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
			if node.is_wall:
				draw_rect(Rect2(position - Vector2(TILE_SIZE / 2, TILE_SIZE / 2), Vector2(TILE_SIZE, TILE_SIZE)), Color.BLACK)
			elif open_list.has(node):
				draw_circle(position, TILE_SIZE / 4, Color.GREEN)
			elif closed_list.has(node):
				draw_circle(position, TILE_SIZE / 4, Color.BLUE)
	"""

	# 원의 색상 및 반지름 설정
	var circle_color = Color.RED  # 원 색상 (빨간색)
	var circle_radius = TILE_SIZE / 4  # 타일 크기에 맞는 반지름

	# 경로의 각 노드 위치에 원 그리기
	for node in final_node_list:
		var position = Vector2(node.x, node.y) * TILE_SIZE + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
		draw_circle(position, circle_radius, circle_color)
		
