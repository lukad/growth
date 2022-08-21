class_name Building
extends MeshInstance

export var max_health := 50
var _health := 50

func _ready() -> void:
	add_to_group("Buildings")
	_health = max_health

func _attack(damage: int) -> int:
	_health -= damage
	scale = 1.0 / float(max_health) * float(_health) * Vector3.ONE
	if _health <= 0:
		queue_free()
	return damage
