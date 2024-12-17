extends HBoxContainer

@onready var SickSound = $Sick
@onready var DeadSound = $Dead

enum modes {SIMPLE, EMPTY, PARTIAL}

var heart_full = preload("res://Images/hudHeart_full.png")
var heart_empty = preload("res://Images/hudHeart_empty.png")
var heart_half = preload("res://Images/hudHeart_half.png")

@export var mode : modes
var PlayerHP: int = 6  # 플레이어 체력 초기값 설정
var is_dead_played: bool = false  # Dead 사운드 재생 여부 확인

func _ready():
	Globals.health_ui = self
	# 처음에 체력을 UI에 반영
	update_health(PlayerHP)

func update_health(value):
	print("Updating health UI:", value)
	match mode:
		modes.SIMPLE:
			update_simple(value)
		modes.EMPTY:
			update_empty(value)
		modes.PARTIAL:
			update_partial(value)

func update_simple(value):
	for i in range(get_child_count()):
		get_child(i).visible = value > i

func update_empty(value):
	for i in range(get_child_count()):
		if value > i:
			get_child(i).texture = heart_full
		else:
			get_child(i).texture = heart_empty

func update_partial(value):
	for i in range(get_child_count()):
		if value > i * 2 + 1:
			get_child(i).texture = heart_full
		elif value > i * 2:
			get_child(i).texture = heart_half
		else:
			get_child(i).texture = heart_empty
			
signal health_decreased(amount)

# 체력 감소 메서드
func decrease_health(amount):
	PlayerHP -= amount
	Globals.player.PlayerHurt()
	if PlayerHP < 0:
		PlayerHP = 0  # 체력이 0 이하로 내려가지 않도록 설정
	print("PlayerHP:", PlayerHP)
	SickSound.play()
	update_health(PlayerHP)  # 체력 상태 업데이트
	

func _process(delta: float) -> void:
	# PlayerHP가 0이 되고 사운드가 아직 재생되지 않은 경우
	if PlayerHP <= 0 and not is_dead_played:
		is_dead_played = true  # Dead 사운드 재생 플래그 설정
		print("Playing Dead Sound...")
		Globals.player.PlaerDead()
		DeadSound.play()
		await DeadSound.finished  # 사운드 재생이 끝날 때까지 대기
		get_tree().reload_current_scene()  # 씬 다시 시작
