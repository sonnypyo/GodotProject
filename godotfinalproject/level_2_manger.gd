extends Node

var enemy_list = []  # 수동으로 추가할 적 노드 리스트

func _ready():
	# 수동으로 리스트에 적 노드 추가
	enemy_list.append($Enemys/RangedEnemy2/RangeEnemy)
	enemy_list.append($Enemys/CloseEnemy3/CloseEnemy)
	enemy_list.append($Enemys/CloseEnemy2/CloseEnemy)
	enemy_list.append($Enemys/RangedEnemy/RangeEnemy)
	

	print("Enemy list initialized: ", enemy_list.size(), " enemies")

func _process(delta):
	# 리스트에서 삭제된 노드를 제거
	enemy_list = enemy_list.filter(func(e): return is_instance_valid(e))
	
	# 모든 적이 삭제되었는지 확인
	if enemy_list.size() == 0:
		print("All enemies defeated! Proceeding to next stage...")
		go_to_next_stage()

func go_to_next_stage():
	# 다음 스테이지로 넘어가는 코드
	print("Loading next stage...")
	get_tree().change_scene_to_file("res://RealLevel_3.tscn")
