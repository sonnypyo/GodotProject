class_name OptionMenu
extends Control

func _on_exit_botton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
