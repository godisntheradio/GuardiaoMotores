tool
extends Spatial

export(String, FILE, "*.mlgmc") var layer_config

var _dict = {"A": false, "B": false, "C": false}
export(Dictionary) var dict : Dictionary = _dict.duplicate() setget set_dict

func set_dict(val : Dictionary):
	for k in val.keys():
		if val.get(k) == true:
			print(k)
	dict = {"C": false, "B": false, "A": false}
	
func get_dict():
	return dict

var layers : Array = []
var gridmaps : Array = []

var LayerFileIO = preload("res://addons/MultiLayer GridMap/LayerFileIO.gd").new()

func get_materials_from_mesh(mesh : Mesh) -> Array:
	var res = []
	for sm in range(mesh.get_surface_count()):
		res.push_back(mesh.surface_get_material(sm))
	
	return res

func _ready():
	var btn = Button.new()
	btn.text = "AAAAA"
	
	var eip = EditorInspectorPlugin.new()
	eip.add_custom_control(btn)
	
	var file : File = File.new()
	if !file.file_exists(layer_config):
		printerr("Config file not found!")
		return
		
	file.open(layer_config, file.READ)
	if !file.is_open():
		printerr("Could not open config file!")
		return
	
	var layer_count = file.get_32()
	for l in range(layer_count):
		layers.append(LayerFileIO.read_from_stream(file))
	
	for l in layers:
		var curr = GridMap.new()
		gridmaps.append(curr)
		add_child(curr)
		if l.use_meshlib:
			var mlib = load(l.meshlib_path)
			curr.mesh_library = mlib
		else:
			curr.mesh_library = MeshLibrary.new()
		if l.use_as_properties:
			var mlib = curr.mesh_library
			for p in range(l.properties.size()):
				if mlib.get_last_unused_item_id() > p:
					mlib.set_item_name(p, mlib.get_item_name(p) + " - " + l.properties[p].name)
				else:
					mlib.create_item(p)
					var mesh = CubeMesh.new()
					mesh.material = SpatialMaterial.new()
					mesh.material.flags_transparent = true
					mesh.material.albedo_color = l.properties[p].mesh_colour
					mlib.set_item_mesh(p, mesh)
					mlib.set_item_name(p, l.properties[p].name)


