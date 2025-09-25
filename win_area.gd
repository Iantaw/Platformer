extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		var main_node = get_owner()
		
		if main_node.can_win:
			main_node.show_win_overlay()
