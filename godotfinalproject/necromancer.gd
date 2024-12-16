extends CharacterBody2D
#손준표
@onready var Necromancer = $"../NecromancerSprite2D"



func _ready():
	# 기본 애니메이션 실행
	Necromancer.play("Idel")  # Idel 애니메이션 실행
