@tool
extends ColorRect

@export var dark : bool = false :
	set(v):
		dark = v
		color = Color.BLACK if dark else Color.WHITE
