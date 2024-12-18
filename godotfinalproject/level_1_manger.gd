extends Node

var enemy_list = []  # 첫 번째 적 노드 리스트
var enemy_list2 = []  # 두 번째 적 노드 리스트
var enemy_list3 = []  # 세 번째 적 노드 리스트
var enemys2  # Enemys2 노드 참조 변수
var enemys3  # Enemys3 노드 참조 변수
var enemys4  # Enemys4 노드 참조 변수
var enemys2_activated = false  # Enemys2 활성화 여부 체크
var enemys3_activated = false  # Enemys3 활성화 여부 체크
var enemys4_activated = false  # Enemys4 활성화 여부 체크

func _ready():
	# 리스트에 첫 번째 적 노드 추가
	enemy_list.append($Enemys/RangedEnemy2/RangeEnemy)
	enemy_list.append($Enemys/CloseEnemy3/CloseEnemy)
	enemy_list.append($Enemys/CloseEnemy2/CloseEnemy)
	enemy_list.append($Enemys/RangedEnemy/RangeEnemy)
	
	# 리스트에 두 번째 적 노드 추가
	enemy_list2.append($Enemys2/RangedEnemy/RangeEnemy)
	enemy_list2.append($Enemys2/RangedEnemy2/RangeEnemy)
	enemy_list2.append($Enemys2/RangedEnemy3/RangeEnemy)
	enemy_list2.append($Enemys2/RangedEnemy4/RangeEnemy)
	enemy_list2.append($Enemys2/CloseEnemy2/CloseEnemy)
	enemy_list2.append($Enemys2/CloseEnemy3/CloseEnemy)
	enemy_list2.append($Enemys2/CloseEnemy4/CloseEnemy)
	enemy_list2.append($Enemys2/CloseEnemy5/CloseEnemy)
	
	# 리스트에 세 번째 적 노드 추가
	enemy_list3.append($Enemys3/RangedEnemy/RangeEnemy)
	enemy_list3.append($Enemys3/RangedEnemy2/RangeEnemy)
	enemy_list3.append($Enemys3/RangedEnemy3/RangeEnemy)
	enemy_list3.append($Enemys3/RangedEnemy4/RangeEnemy)
	enemy_list3.append($Enemys3/CloseEnemy2/CloseEnemy)
	enemy_list3.append($Enemys3/CloseEnemy3/CloseEnemy)
	enemy_list3.append($Enemys3/CloseEnemy4/CloseEnemy)
	enemy_list3.append($Enemys3/CloseEnemy5/CloseEnemy)
	enemy_list3.append($Enemys3/Necromancer2/Necromancer)
	enemy_list3.append($Enemys3/Necromancer1/Necromancer)

	# Enemys2 노드 비활성화 상태로 준비
	enemys2 = $Enemys2
	enemys2.visible = false
	enemys2.process_mode = Node.PROCESS_MODE_DISABLED

	# Enemys3 노드 비활성화 상태로 준비
	enemys3 = $Enemys3
	enemys3.visible = false
	enemys3.process_mode = Node.PROCESS_MODE_DISABLED

	# Enemys4 노드 비활성화 상태로 준비
	enemys4 = $Enemys4
	enemys4.visible = false
	enemys4.process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta):
	# 리스트에서 삭제된 노드를 제거
	enemy_list = enemy_list.filter(func(e): return is_instance_valid(e))
	enemy_list2 = enemy_list2.filter(func(e): return is_instance_valid(e))
	enemy_list3 = enemy_list3.filter(func(e): return is_instance_valid(e))
	
	# 모든 적이 삭제되었고, Enemys2가 아직 활성화되지 않은 경우
	if enemy_list.size() == 0 and not enemys2_activated:
		print("All enemies defeated! Activating Enemys2...")
		activate_enemys2()
		enemys2_activated = true
	
	# Enemys2 적이 모두 삭제되었고, Enemys3가 아직 활성화되지 않은 경우
	if enemy_list2.size() == 0 and enemys2_activated and not enemys3_activated:
		print("All Enemys2 defeated! Activating Enemys3...")
		activate_enemys3()
		enemys3_activated = true
	
	# Enemys3 적이 모두 삭제되었고, Enemys4가 아직 활성화되지 않은 경우
	if enemy_list3.size() == 0 and enemys3_activated and not enemys4_activated:
		print("All Enemys3 defeated! Activating Enemys4...")
		activate_enemys4()
		enemys4_activated = true

func activate_enemys2():
	
	enemys2.process_mode = Node.PROCESS_MODE_INHERIT
	enemys2.visible = true
	Globals.PlayerHP += 1
	Globals.health_ui.update_health(Globals.PlayerHP)
	print("Enemys2 activated!")

func activate_enemys3():
	# Enemys3 노드를 활성화 (5초 지연)
	await get_tree().create_timer(5.0).timeout
	Globals.PlayerHP += 1
	Globals.health_ui.update_health(Globals.PlayerHP)
	enemys3.process_mode = Node.PROCESS_MODE_INHERIT
	enemys3.visible = true
	print("Enemys3 activated!")

func activate_enemys4():
	# Enemys4 노드를 활성화 (5초 지연)
	await get_tree().create_timer(5.0).timeout
	Globals.PlayerHP += 1
	Globals.health_ui.update_health(Globals.PlayerHP)
	enemys4.process_mode = Node.PROCESS_MODE_INHERIT
	enemys4.visible = true
	print("Enemys4 activated!")
