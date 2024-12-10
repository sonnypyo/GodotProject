extends Area2D
#by 민성
# 속도를 저장할 변수
@export var LineDrawScene: PackedScene
var velocity = Vector2.ZERO
var speed = 750  # 속도의 크기

var transformlist: Array = []
var turn = 0
var max_turn = 5
var lindDraw: Line2D
var isRunning = false
func _ready():
	# 초기화 코드
	transformlist.append(position)
	print(turn, position.x, position.y)
	
func _physics_process(delta):
	get_parent().get_node("LineDraw").clear_points()
	if turn == max_turn:
		isRunning = false
		transformlist.clear()
		turn = 0
		velocity = Vector2.ZERO
		var vec = get_tile_coordinates(position)
		if position.x>0:
			position.x = (vec.x-0.5)*60
		elif true:
			position.x = (vec.x+0.5)*60
		if position.y>0:
			position.y = (vec.y-0.5)*60
		elif true:
			position.y = (vec.y+0.5)*60
		transformlist.append(position)
		
		
	
	# 키 입력으로 속도 조정
	#velocity = Vector2.ZERO  # 기본적으로 멈춤
	get_local_mouse_position()
	if !isRunning:
		if Input.is_key_pressed(KEY_R):
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				isRunning = true
				velocity = get_local_mouse_position()
	# 속도 크기 조정
	velocity = velocity.normalized() * speed

	# 위치 업데이트
	position += velocity * delta  # 현재 위치에 속도를 곱해 업데이트	
	for i in range(turn+1):
		if i==turn:
			get_parent().get_node("LineDraw").draw_line_between_points(transformlist[i],position)
		elif true:
			get_parent().get_node("LineDraw").draw_line_between_points(transformlist[i], transformlist[i+1])

		
func _on_area_entered(area: Area2D) -> void:
	if area.name == "wallX":
		get_parent().get_node("LineDraw").clear_points()
		velocity.x *= -1
		transformlist.append(position)
		turn+=1
		print(turn, position.x, position.y)
	elif area.name == "wallY":
		get_parent().get_node("LineDraw").clear_points()
		velocity.y *= -1
		transformlist.append(position)
		turn+=1
		print(turn, position.x, position.y)
		
# 특정 좌표가 어떤 타일에 있는지 계산하는 함수
func get_tile_coordinates(XYposition: Vector2) -> Vector2:
	"""
	주어진 좌표가 어떤 타일에 위치하는지 계산합니다.
	:param position: 입력 좌표 (Vector2)
	:param tile_size: 타일의 한 변 크기 (픽셀 단위)
	:return: 타일 좌표 (Vector2) - 중심이 (0, 0)임
	"""
	# 좌표를 타일 크기로 나눈 뒤 반올림하여 타일 좌표 계산
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
	print("%n",tile_x, tile_y)
	
	return Vector2(tile_x, tile_y)
