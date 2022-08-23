extends Spatial

onready var menu: Menu = $Menu
onready var gui: GUI = $GUI

var _player_spawn: PlayerSpawn
var PlayerScene := preload("res://Src/Player/Player.tscn")
var player: Player

func _ready() -> void:
	_player_spawn = _find_player_spawn()
	Global.buildings_left = get_tree().get_nodes_in_group("Buildings").size()
	# warning-ignore:return_value_discarded
	Global.connect("buildings_left_changed", self, "_on_buildings_left_changed")

func _on_Menu_start_game() -> void:
	menu.close()
	$MusicPlayer.playing = true
	gui.show()
	spawn_player()
	for spawner in get_tree().get_nodes_in_group("EnemySpawners"):
		var enemy_spawner := spawner as EnemySpawner
		enemy_spawner.start()

func spawn_player() -> void:
	if _player_spawn == null:
		return
	player = PlayerScene.instance() as Player
	player.global_transform = _player_spawn.global_transform
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_child(player)

func _on_Menu_quit_game() -> void:
	get_tree().quit()

func _find_player_spawn() -> PlayerSpawn:
	for child in get_children():
		if child is PlayerSpawn:
			return child

	return null

func _on_buildings_left_changed(buildings_left: int) -> void:
	if buildings_left <= 0:
		player.queue_free()

		for spawner in get_tree().get_nodes_in_group("EnemySpawners"):
			var enemy_spawner := spawner as EnemySpawner
			enemy_spawner.stop()
