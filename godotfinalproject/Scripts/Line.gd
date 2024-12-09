extends Line2D
#by 민성
func _ready():
	width = 4  # 선의 두께 설정
	default_color = Color(1, 1, 0.8)  # 선 색상 설정

func draw_line_between_points(start: Vector2, end: Vector2):
	# 기존 점을 모두 지우기
	#clear_points()
	# 두 점을 연결하는 선 추가
	add_point(to_local(start))  # 시작점
	add_point(to_local(end))    # 끝점

func Clear_points():
	clear_points()
