extends Node3D

@export_group("buoyancy variables")
@export var object_volume: float = 1
@export var water_damping_value: float = 1
var weight: float 
var gravity: float
var object_height: float

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
	var water_height: float = get_water_height_at_pos_xz()
	
	position.y = water_height

func get_water_height_at_pos_xz() -> float:
	var position_offseted: Vector2 = Vector2(global_position.x, global_position.z) / water_noise_scale + Vector2(water_time_scale * Time.get_ticks_msec() / 1000.0, water_time_scale * Time.get_ticks_msec() / 1000.)
	position_offseted = (position_offseted * height_map.get_width()).posmod(height_map.get_width()) 
	
	return height_map.get_image().get_pixel(position_offseted.x, position_offseted.y).r * water_height_scale
