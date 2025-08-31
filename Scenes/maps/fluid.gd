extends MeshInstance3D
class_name Fluid

@export var density: float = 1
static var instance: Fluid
var top: float = 0

func _ready() -> void:
	instance = self
	top = global_position.y + (self.mesh.get_aabb().size[1] / 2) 
