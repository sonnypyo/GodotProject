extends Area2D
#by 민성
# 속도를 저장할 변수
@export var LineDrawScene: PackedScene
var velocity = Vector2.ZERO
var speed = 1500  # 속도의 크기

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
