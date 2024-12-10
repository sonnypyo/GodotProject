extends Node2D

@export var speed = 500  # 이동 속도

func _process(delta):
	# 마우스 위치 가져오기
	var mouse_pos = get_global_mouse_position()
	
	# 객체 위치를 마우스 위치로 보간하여 부드럽게 이동
	position = position.lerp(mouse_pos, speed * delta / position.distance_to(mouse_pos))
