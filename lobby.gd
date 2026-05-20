extends Control

const PORT = 7000
const MAX_CLIENTS = 3  # host + 3 = 4 players

@onready var ip_input = $VBoxContainer/LineEdit

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

func host_game():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	print("Hosting on port ", PORT)

func join_game():
	var peer = ENetMultiplayerPeer.new()
	var address = ip_input.text
	var parts = address.split(":")
	var host = parts[0]
	var port = parts[1].to_int() if parts.size() > 1 else PORT
	peer.create_client(ip_input.text, PORT)
	multiplayer.multiplayer_peer = peer
	print("Joining ", host, " on port ", port)

func _on_peer_connected(id):
	print("Peer connected: ", id)

func _on_peer_disconnected(id):
	print("Peer disconnected: ", id)

func _on_connected_to_server():
	print("Connected to server!")
	get_tree().change_scene_to_file("res://Game1.tscn")

func _on_connection_failed():
	print("Connection failed.")


func start_game():
	if multiplayer.is_server():
		change_scene.rpc()

@rpc("any_peer", "call_local", "reliable")
func change_scene():
	print("Changing scene on peer: ", multiplayer.get_unique_id())
	get_tree().change_scene_to_file("res://Game1.tscn")
