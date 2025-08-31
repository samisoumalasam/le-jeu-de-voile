extends GeometryInstance3D
class_name WaterManager

enum WaterParameters {
	ALBEDO,  
	ALBEDO_2,
	METALLIC,
	ROUGHNESS,
	WAVE,
	TEXTURE_NORMAL,
	TEXTURE_NORMAL2,
	WAVE_DIRECTION,
	WAVE_DIRECTION2,
	TIME_SCALE,
	NOISE_SCALE,
	HEIGHT_SCALE,
	COLOR_DEEP,
	COLOR_SHALLOW,
}

static var instance: WaterManager
var shader_material: ShaderMaterial


func _ready() -> void:
	instance = self
	shader_material = material_override as ShaderMaterial

func _process(delta: float) -> void:
	shader_material.set_shader_parameter("gdscript_time", Time.get_ticks_msec() / 1000.)

func set_water_parameter(waterparam: WaterParameters, value) -> void:
	shader_material.set_shader_parameter(water_param_enum_to_string(waterparam), value)

func get_water_parameter(waterparam: WaterParameters):
	return shader_material.get_shader_parameter(water_param_enum_to_string(waterparam))

func water_param_enum_to_string(waterparam: WaterParameters) -> String:
	return (WaterParameters.keys()[waterparam] as String).to_lower()
