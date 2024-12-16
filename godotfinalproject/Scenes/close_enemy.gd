extends CharacterBody2D
#손준표
@onready var CloseEnemySprite2D = $CloseEnemySprit2D


var CloseHP = 30

func _ready():
	# 기본 애니메이션 실행
	CloseEnemySprite2D.play("Idel")  # Idel 애니메이션 실행

func damage():
	if(CloseHP > 0):
		CloseEnemySprite2D.play("sick")
		
		CloseHP -= 10
		print(CloseHP)
		
	elif(CloseHP == 0):
		print("죽음")
	
	
