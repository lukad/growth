class_name GUI
extends CanvasLayer

func _ready() -> void:
	# warning-ignore:return_value_discarded
	Global.connect("score_changed", self, "_on_score_changed")
	visible = false

func _on_score_changed(score: int) -> void:
	$Label.text = str(score)
