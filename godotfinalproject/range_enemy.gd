extends CharacterBody2D

@onready var RangeIdel = $Id
@onready var RangeHit = $HitAniSprite
@onready var RangeDead = $DeadAniSprite

func _ready():
	# 기본 애니메이션 실행 전, 모든 스프라이트를 끔
	RangeIdel.visible = false
	RangeHit.visible = false
	RangeDead.visible = false
	
	# 기본 애니메이션 실행 (RangeIdel만 켬)
	RangeIdel.visible = true
	RangeIdel.play("Idel")  # Idel 애니메이션 실행
