extends Area2D

signal coin_collected

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	body_entered.connect(_on_body_entered)
	
	if animated_sprite:
		animated_sprite.play("spin")

func _on_body_entered(body):
	if body.name == "Player":
		play_collection_effect()
		
		coin_collected.emit()

func play_collection_effect():
	if animated_sprite:
		animated_sprite.stop()
	
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2(1.5, 1.5), 0.15)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.15)
	
	await tween.finished
	queue_free()
