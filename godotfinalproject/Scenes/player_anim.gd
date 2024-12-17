extends Node2D
#손준표
@onready var animated_sprite = $AnimatedSprite2DPlayer  # 정확한 경로를 지정

func _ready():
	# 기본 애니메이션 실행
	animated_sprite.play("Idel")  # Idel 애니메이션 실행
	Globals.player = self

func _process(delta: float) -> void:
	# 조건에 따라 애니메이션 변경
	if Input.is_action_pressed("ui_right"):  # 공격 시 Light 애니메이션 실행
		animated_sprite.play("Light")
	elif Input.is_action_pressed("ui_left"):  # 공격을 당했을 때 Hit 애니메이션 실행
		animated_sprite.play("Hit")
	elif Input.is_action_pressed("ui_up"):  # Hurt 애니메이션 실행
		animated_sprite.play("Hurt")
	elif Input.is_action_pressed("ui_down"): # 사망 상태일 때 Dead 애니메이션 실행
		animated_sprite.play("Dead")
	else:
		animated_sprite.play("Idel")  # 아무 입력이 없으면 기본 애니메이션 실행

# 사망 상태 확인 함수
func is_dead() -> bool:
	# 실제 게임 로직에 따라 캐릭터 사망 상태를 확인하는 조건 추가
	return false  # 기본값은 false
