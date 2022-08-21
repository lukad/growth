class_name Bullet
extends Area

export var velocity := 1.0
export var damage := 10

func _process(delta: float) -> void:
	translate(Vector3.FORWARD * velocity * delta)

func _on_Bullet_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.is_in_group("Snacks") and body is Snack:
		body.hit(10)
	queue_free()
