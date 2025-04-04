extends CanvasLayer

signal start_game

@onready var start_message: TextureRect = $StartMenu/StartMessage
@onready var score_label: Label = $GameOverMenu/VBoxContainer/ScoreLabel
@onready var high_score_label: Label = $GameOverMenu/VBoxContainer/HighScoreLabel
@onready var game_over_menu: Control = $GameOverMenu
@onready var texture_button: TextureButton = $StartMenu/TextureButton

var game_started = false
var shop_open = false

func _input(event):
	if event.is_action_pressed("restart") and game_over_menu.visible:
		_on_RestartButton_pressed()
	
	if event.is_action_pressed("flap") and not game_started:
		if !get_viewport().gui_get_hovered_control() == texture_button:
			emit_signal("start_game")
			
			# Create and use a tween dynamically
			var tween = create_tween()
			tween.tween_property(start_message, "modulate:a", 0.0, 0.5)

			game_started = true
		else:
			return
	

func init_game_over_menu(score, highscore):
	score_label.text = "SCORE: " + str(score)
	high_score_label.text = "BEST: " + str(highscore)
	game_over_menu.visible = true

func _on_RestartButton_pressed():
	get_tree().reload_current_scene()
