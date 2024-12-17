extends CharacterBody2D
#손준표
@onready var Necromancer = $"../NecromancerSprite2D"

var NecromHP = 20

func _ready():
	# 기본 애니메이션 실행
	Necromancer.play("Idel")  # Idel 애니메이션 실행
	
func _process(delta: float) -> void:
	if(NecromHP<=0):
		Necromancer.play("Dead")
		await get_tree().create_timer(1.0).timeout
		queue_free()
		print("죽음")
	

func NecromDamage():
	if(NecromHP > 0):
		Necromancer.play("Sick")
		
		await get_tree().create_timer(1.0).timeout
		Necromancer.play("Idel")
		NecromHP -= 10
		print(NecromHP)
		
	
