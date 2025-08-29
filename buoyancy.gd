extends RigidBody3D

@export_group("buoyancy variables")
@export var object_volume: float = 1
@export var water_damping_value: float = 1
var weight: float 
var gravity: float
var object_height: float

func _ready() -> void:
	object_height = (get_child(0) as Node3D).scale.y
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	weight = gravity * mass

func _physics_process(delta: float) -> void:
	var bottom: float = position.y - object_height / 2
	var sink_ratio: float = clamp((Fluid.instance.top - bottom) / object_height + .6, 0, 1)
	var poussee_archimede: float = - Fluid.instance.density * object_volume * gravity * sink_ratio
	
	linear_damp = water_damping_value * sink_ratio
	apply_force(Vector3(0, -poussee_archimede, 0))
