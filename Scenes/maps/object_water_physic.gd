extends Node3D

var height_map: NoiseTexture2D
var water_noise_scale: float
var water_time_scale: float
var water_height_scale: float

func _ready() -> void:
	height_map = WaterManager.instance.get_water_parameter(WaterManager.WaterParameters.WAVE)
	
	water_noise_scale = WaterManager.instance.get_water_parameter(WaterManager.WaterParameters.NOISE_SCALE)
	water_time_scale = WaterManager.instance.get_water_parameter(WaterManager.WaterParameters.TIME_SCALE)
	water_height_scale = WaterManager.instance.get_water_parameter(WaterManager.WaterParameters.HEIGHT_SCALE)

func _process(delta: float) -> void:
	var position_offseted: Vector2 = Vector2(global_position.x, global_position.z) / water_noise_scale + Vector2(water_time_scale * Time.get_ticks_msec() / 1000.0, water_time_scale * Time.get_ticks_msec() / 1000.)
	position_offseted *= Vector2(height_map.get_width(), height_map.get_height())
	position_offseted.x = fmod(position_offseted.x, height_map.get_width())
	position_offseted.y = fmod(position_offseted.y, height_map.get_height())
	
#	position.y = Vector2(global_position.x, global_position.z) / water_noise_scale + 
	position.y = height_map.get_image().get_pixel(position_offseted.x, position_offseted.y).r * water_height_scale
