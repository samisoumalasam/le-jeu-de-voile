extends Camera3D

@export var player: RigidBody3D
@export var lerp_coefficient: float
@export var distance_to_player: Vector3 = Vector3(20, 10, 0)

func _ready() -> void:
	if (player == null):
		player = get_parent().find_child("Player")
	
	position = player.position - Vector3(cos(player.rotation.y) * distance_to_player.x, -distance_to_player.y, sin(player.rotation.y) * distance_to_player.z)

func _process(delta: float) -> void:
	position.lerp(player.position - Vector3(sin(player.rotation.y) * distance_to_player.x, -distance_to_player.y, cos(player.rotation.y) * distance_to_player.z), lerp_coefficient)
	look_at(player.position)
