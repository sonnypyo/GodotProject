extends CharacterBody2D
#손준표
@onready var CloseEnemySprite2D = $CloseEnemySprit2D



func _ready():
	# 기본 애니메이션 실행
	CloseEnemySprite2D.play("Idel")  # Idel 애니메이션 실행
