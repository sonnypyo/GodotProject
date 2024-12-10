extends Node2D


@onready var BossSprite2D = $BossSprit2D



func _ready():
	# 기본 애니메이션 실행
	BossSprite2D.play("Idel")  # Idel 애니메이션 실행
