extends Area2D

@export var speed = 400

func _physics_process(delta):
	$"..".progress += speed *delta
