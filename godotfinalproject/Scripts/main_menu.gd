extends Control

func _ready():
	pass

func _process(delta):
	pass

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://level_0.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Options_Menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
