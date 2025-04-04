extends Node2D

@onready var hud = $HUD
@onready var obstacle_spawner = $ObstacleSpawner
@onready var ground = $Ground
@onready var menu_layer = $MenuLayer

#const SAVE_FILE_PATH = "user://score_data.tres"
#var score_data: ScoreData

var score = 0: set = set_score
var highscore = 0

func _ready():
	obstacle_spawner.connect("obstacle_created", Callable(self, "_on_obstacle_created"))
	load_highscore()
	print("Loaded highscore: ", highscore)

func new_game():
	self.score = 0
	obstacle_spawner.start()

func player_score():
	self.score += 1

func set_score(new_score):
	score = new_score
	hud.update_score(score)

func _on_obstacle_created(obs):
	obs.connect("score", Callable(self, "player_score"))

func _on_DeathZone_body_entered(body):
	if body is Player:
		if body.has_method("die"):
			body.die()

func _on_Player_died():
	game_over()

func game_over():
	obstacle_spawner.stop()
	ground.get_node("AnimationPlayer").stop()
	get_tree().call_group("obstacles", "set_physics_process", false)
	
	if score > highscore:
		highscore = score
		ScoreData.save_score(score)
	menu_layer.init_game_over_menu(score, highscore)

func _on_MenuLayer_start_game():
	new_game()

func load_highscore():
	var loaded_score = ScoreData.load_score()

	highscore = loaded_score.highscore
