extends Node

var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

func _ready():
	# AudioStreamPlayer 노드를 동적으로 생성
	bgm_player = AudioStreamPlayer.new()
	sfx_player = AudioStreamPlayer.new()
	add_child(bgm_player)
	add_child(sfx_player)

func play_bgm(stream: AudioStream, loop: bool = true):
	bgm_player.stream = stream
	bgm_player.loop = loop
	bgm_player.play()

func stop_bgm():
	bgm_player.stop()

func play_sfx(stream: AudioStream):
	sfx_player.stream = stream
	sfx_player.play()
