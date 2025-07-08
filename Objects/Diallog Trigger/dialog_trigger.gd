class_name DialogTrigger extends Area2D


@export var dialog: Dialog


func start_dialog() -> void:
	Globals.main.dialog_started(dialog)
