extends Node

@onready var game_timer = $GameTimer
@onready var timer_label = $UI/TimerLabel
@onready var coin_counter_label = $UI/CoinCounterLabel

@onready var win_overlay = $UI/WinOverlay
@onready var play_again_button = $UI/WinOverlay/PlayAgainButton

var total_coins = 0
var collected_coins = 0
var coins_remaining = 0
var can_win = false

var total_time = 60.0

func _ready():
	game_timer.wait_time = total_time
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()
	update_timer_display()
	
	win_overlay.visible = false
	play_again_button.pressed.connect(_on_play_again_pressed)
	
	await get_tree().process_frame
	
	count_coins()
	connect_coins()
	update_coin_counter()

func count_coins():
	var coins = get_tree().get_nodes_in_group("coins")
	total_coins = coins.size()
	coins_remaining = total_coins
	print("Found ", total_coins, " coins to collect")

func connect_coins():
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		if coin.has_signal("coin_collected"):
			coin.coin_collected.connect(_on_coin_collected)

func _on_coin_collected():
	collected_coins += 1
	coins_remaining = total_coins - collected_coins
	
	print("Coin collected! Remaining: ", coins_remaining)
	update_coin_counter()
	
	if coins_remaining == 0:
		can_win = true
		print("All coins collected! You can now win at the cherry blossom tree!")

func update_coin_counter():
	if coin_counter_label:
		coin_counter_label.text = "Coins Left: " + str(coins_remaining)

func _process(delta):
	update_timer_display()

func update_timer_display():
	if timer_label and game_timer:
		var time_left = game_timer.time_left
		var minutes = int(time_left) / 60
		var seconds = int(time_left) % 60
		timer_label.text = "Time: %02d:%02d" % [minutes, seconds]

func _on_game_timer_timeout():
	print("Time's up!")
	get_tree().reload_current_scene()

func check_win_condition():
	if can_win:
		print("You WIN!")
		show_win_overlay()
	else:
		print("Collect all coins first! Remaining: ", coins_remaining)

func show_win_overlay():	
	win_overlay.visible = true
	
	win_overlay.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(win_overlay, "modulate:a", 1.0, 0.3)

func _on_play_again_pressed():
	win_overlay.visible = false
	get_tree().paused = false
	
	get_tree().reload_current_scene()
