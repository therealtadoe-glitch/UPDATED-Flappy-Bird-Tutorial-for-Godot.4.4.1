# ScoreData.gd
extends Resource
class_name ScoreData

const SAVE_FILE_PATH = "user://score_data.tres"

@export var highscore: int = 0

static func save_score(score: int):
	var save_data = ScoreData.new()
	save_data.highscore = score
	ResourceSaver.save(save_data, SAVE_FILE_PATH)
	SignalBus.score_saved.emit(score)

static func load_score() -> Resource:
	var resource = ResourceLoader.load(SAVE_FILE_PATH)
	
	if resource:
		SignalBus.score_loaded.emit()
		return resource  # Return the loaded custom resource
	else:
		print("No save file found.\
		Creating a new save file.....")
		# If the file doesn't exist, create a new default one
		var default_resource = ScoreData.new()
		return default_resource
	
