extends GeometryInstance3D
class_name WaterManager

@export var density: float = 1

static var instance: WaterManager
var shader_material: ShaderMaterial

var height_map_image: Image
var water_noise_scale: float
var water_time_scale: float
var water_height_scale: float

func _ready() -> void:
	instance = self
	shader_material = material_override as ShaderMaterial
	
	var height_map: NoiseTexture2D = get_water_parameter(WaterManager.WaterParameters.WAVE)
	await height_map.changed
	height_map_image = height_map.get_image()
	water_noise_scale = get_water_parameter(WaterManager.WaterParameters.NOISE_SCALE)
	water_time_scale = get_water_parameter(WaterManager.WaterParameters.TIME_SCALE)
	water_height_scale = get_water_parameter(WaterManager.WaterParameters.HEIGHT_SCALE)

func _process(_delta: float) -> void:
	shader_material.set_shader_parameter("gdscript_time", Time.get_ticks_msec() / 1000.)

func set_water_parameter(waterparam: WaterParameters, value) -> void:
	shader_material.set_shader_parameter(water_param_enum_to_string(waterparam), value)

func get_water_parameter(waterparam: WaterParameters):
	return shader_material.get_shader_parameter(water_param_enum_to_string(waterparam))

func water_param_enum_to_string(waterparam: WaterParameters) -> String:
	return (WaterParameters.keys()[waterparam] as String).to_lower()

func get_water_height_at_pos_v(pos_xz: Vector2) -> float:
	var position_offseted: Vector2 = Vector2(pos_xz.x, pos_xz.y) / water_noise_scale + Vector2(water_time_scale * Time.get_ticks_msec() / 1000.0, water_time_scale * Time.get_ticks_msec() / 1000.)
	position_offseted = (position_offseted * height_map_image.get_width()).posmod(height_map_image.get_width()) 
	
	return height_map_image.get_pixelv(position_offseted).r * water_height_scale

func get_water_height_at_pos(pos_x: float, pos_z: float) -> float:
	var position_offseted: Vector2 = Vector2(pos_x, pos_z) / water_noise_scale + Vector2(water_time_scale * Time.get_ticks_msec() / 1000.0, water_time_scale * Time.get_ticks_msec() / 1000.)
	position_offseted = (position_offseted * height_map_image.get_width()).posmod(height_map_image.get_width()) 
	
	return height_map_image.get_pixelv(position_offseted).r * water_height_scale

func is_height_map_image_null() -> bool:
	return height_map_image == null


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
