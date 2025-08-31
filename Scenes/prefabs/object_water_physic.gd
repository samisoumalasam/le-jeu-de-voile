extends RigidBody3D

@export_group("buoyancy variables")
@export var object_volume: float = 1
@export var water_linear_damping: float = 1
var weight: float 
var gravity: float
var object_height: float

var corners: Array[Node3D]

func _ready() -> void:
	object_height = (get_child(0) as Node3D).scale.y

	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	weight = gravity * mass
	
	for i: int in range(0, 4):
		corners.append(find_child("Corners").get_child(i))

func _physics_process(_delta: float) -> void:
	if WaterManager.instance.is_height_map_image_null():
		apply_force(Vector3(0, -weight, 0))
		return
	
	var bottom_pos: float = (get_child(0) as Node3D).global_position.y - object_height / 2
	linear_damp = 0
	
	for corner in corners:
		var sink_ratio: float = clamp((WaterManager.instance.get_water_height_at_pos(corner.global_position.x, corner.global_position.z) - bottom_pos) / object_height, 0, 1)
		var poussee_archimede: float = -WaterManager.instance.density * object_volume * gravity * sink_ratio / 4
		linear_damp = water_linear_damping * linear_velocity.length() * sink_ratio
		apply_force(Vector3(0, -poussee_archimede, 0), corner.global_position)
