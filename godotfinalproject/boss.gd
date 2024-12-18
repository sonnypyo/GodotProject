extends CharacterBody2D
#손준표
@onready var BossSprite2D = $"../BossSprit2D"
@onready var HPBar = $"../Label"
var BossHP = 100

func _ready():
	# 기본 애니메이션 실행
	BossSprite2D.play("Idel")  # Idel 애니메이션 실행
	_update_hp_label()  # 처음 체력 표시 업데이트

func BossDamage():
	BossHP -= 10  # 체력 감소 (수정: -= 사용)
	_update_hp_label()  # 체력 표시 업데이트
	if BossHP <= 0:
		get_tree().change_scene_to_file("res://Scenes/GodotCredits.tscn")

# 체력 라벨 업데이트 메서드
func _update_hp_label():
	HPBar.text = "Boss HP: %d" % BossHP
