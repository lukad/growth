class_name Bullet
extends Area

export var velocity := 10.0

func _process(delta: float) -> void:
	translate(Vector3.FORWARD * velocity * delta)

func _on_Bullet_body_entered(body: Node) -> void:
	queue_free()
