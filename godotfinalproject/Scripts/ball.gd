extends Area2D
#by 민성
# 속도를 저장할 변수
@export var LineDrawScene: PackedScene
var mapSizeX = 4
var mapSizeY = 4
var velocity = Vector2.ZERO
var speed = 300  # 속도의 크기
var isOnCollider = false
var transformlist: Array = []
var turn = 0
var max_turn = 5
var lindDraw: Line2D
var isRunning = false

func _ready():
	# 초기화 코드
	transformlist.append(global_position)
	print(turn, global_position.x, global_position.y)
	
func _physics_process(delta):
	get_parent().get_node("LineDraw").clear_points()
	if turn >= max_turn:
		$PlayerAnim.visible = true
		transformlist.clear()	
		turn = 0
		var tunedPos = global_position
		if velocity.x < 0:
			tunedPos.x += 15
		elif velocity.x > 0:
			tunedPos.x -= 15
		if velocity.y < 0:
			tunedPos.y += 15
		elif velocity.y > 0:
			tunedPos.y -= 15
		var vec = get_tile_coordinates(tunedPos)
		if global_position.x>0:
			global_position.x = (vec.x-0.5)*60
		elif true:
			global_position.x = (vec.x+0.5)*60
		if global_position.y>0:
			global_position.y = (vec.y-0.5)*60
		elif true:
			global_position.y = (vec.y+0.5)*60
		transformlist.append(global_position)
		
		
	
	# 키 입력으로 속도 조정
	#velocity = Vector2.ZERO  # 기본적으로 멈춤
	get_local_mouse_position()
	if !isRunning:
		if Input.is_key_pressed(KEY_R):
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				isRunning = true
				$PlayerAnim.visible = false
				velocity = get_local_mouse_position()
	# 속도 크기 조정
	velocity = velocity.normalized() * speed

	# 위치 업데이트
	global_position += velocity * delta  # 현재 위치에 속도를 곱해 업데이트	
	for i in range(turn+1):
		if i==turn:
			get_parent().get_node("LineDraw").draw_line_between_points(transformlist[i],global_position)
		elif true:
			get_parent().get_node("LineDraw").draw_line_between_points(transformlist[i], transformlist[i+1])

		
func _on_area_entered(area: Area2D) -> void:
	if !isOnCollider:
		isOnCollider = true
		set_physics_process(false)
		if area.name == "wallX":
			get_parent().get_node("LineDraw").clear_points()
			velocity.x *= -1
			transformlist.append(global_position)
			turn+=1
			if turn >= max_turn:
				velocity = Vector2.ZERO
				isRunning = false
			set_physics_process(true)
			print(turn, global_position.x, global_position.y)
		elif area.name == "wallY":
			get_parent().get_node("LineDraw").clear_points()
			velocity.y *= -1
			transformlist.append(global_position)
			turn+=1
			if turn >= max_turn:
				velocity = Vector2.ZERO
				isRunning = false
			set_physics_process(true)
			print(turn, global_position.x, global_position.y)
		elif area.name == "obstacle":
			get_parent().get_node("LineDraw").clear_points()
			transformlist.append(global_position)
			turn = max_turn
			if turn >= max_turn:
				velocity = Vector2.ZERO
				isRunning = false
			set_physics_process(true)
		elif area.name == "몹":
			print("몹 건드림")
			set_physics_process(true)
			
func _on_body_entered(body: Node2D) -> void:
	if body.name == "몹":
		print("몹 건드림")

func _on_area_exited(area: Area2D) -> void:
	print("탈출")
	isOnCollider = false			

# 특정 좌표가 어떤 타일에 있는지 계산하는 함수
func get_tile_coordinates(XYposition: Vector2) -> Vector2:
	var tile_x
	var tile_y
	if XYposition.x > 0:
		tile_x = -floor(-XYposition.x / 60)
	elif true:
		tile_x = floor(XYposition.x / 60)
	if XYposition.y > 0:
		tile_y = -floor(-XYposition.y / 60)
	elif true:
		tile_y = floor(XYposition.y / 60)
	tile_x = clamp(tile_x, -mapSizeX, mapSizeX)
	tile_y = clamp(tile_y, -mapSizeY, mapSizeY)#이탈방지
	print("%n",tile_x, tile_y)
	
	return Vector2(tile_x, tile_y)
