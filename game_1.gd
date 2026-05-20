extends Node3D

const PLAYER_SCENE = preload("res://Player.tscn")

func _ready():
	print("My peer id: ", multiplayer.get_unique_id(), " | am I authority: ", is_multiplayer_authority())
	if multiplayer.is_server():
		_spawn_player(1)  # spawn host's player, host is always id 1
	else:
		#Tell server we're ready
		notify_server_ready.rpc_id(1)
@rpc("any_peer", "reliable")
func notify_server_ready():
	var id = multiplayer.get_remote_sender_id()
	_spawn_player(id)

func _spawn_player(id: int):
	var player = PLAYER_SCENE.instantiate()
	player.name = str(id)  # IMPORTANT: name must match peer id for ownership to work
	player.set_multiplayer_authority(id)
	add_child(player)
	print("Spawned player for peer: ", id, " | authority: ", player.get_multiplayer_authority())
