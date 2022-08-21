class_name Blaster
extends Spatial

var BulletScene := preload("res://Src/Bullet/Bullet.tscn")

onready var _anim_player: AnimationPlayer = $AnimationPlayer
onready var _bullet_start: Spatial = $BulletStart

func fire() -> void:
	var bullet: Bullet = BulletScene.instance()
	get_tree().root.add_child(bullet)
	bullet.global_translation = _bullet_start.global_translation
	bullet.global_rotation = global_rotation

func start_firing() -> void:
	_anim_player.play("Fire")

func stop_firing() -> void:
	_anim_player.stop()
