tool
extends Control



func _enter_tree():
	layer_list = get_node("Layers/LayerList")
	property_list = get_node("Layers/Properties/PropertyList")
	
	layer_name = get_node("Layers/LayerName")
	property_name = get_node("Layers/Properties/PropertyName")
	
	visibility_check = get_node("Layers/VisibilityCheck")
	use_meshlib_check = get_node("Layers/UseMeshLibCheck")
	meshlib_button = get_node("Layers/UseMeshLibCheck/MeshLibButton")
	use_as_properties_check = get_node("Layers/UseAsPropertiesCheck")
	
	mesh_colour_picker = get_node("Layers/Properties/MeshColour")
	property_type = get_node("Layers/Properties/PropertyType")
	property_value = get_node("Layers/Properties/PropertyValue")
	
func layer_name_changed(text : String):
	var sel_layers = layer_list.get_selected_items()
	if sel_layers.size() == 0:
		return
	var idx = sel_layers[0]
	layers[idx].name = text
	layer_list.set_item_text(idx, get_layer_name())
	
func property_name_changed(text : String):
	get_selected_property().name = text
	property_list.set_item_text(p_idx, get_property_name())
	
func get_property(idx : int) -> Property:
	var sel_layers = layer_list.get_selected_items()
	if sel_layers.size() == 0:
		return null
	var l_idx = sel_layers[0]
	return layers[l_idx].properties[idx]
	
func get_selected_property() -> Property:
	var sel_properties = property_list.get_selected_items()
	if sel_properties.size() == 0:
		return null
	var p_idx = sel_properties[0]
	return get_property(p_idx)

func get_property_name(include_empty : bool = false):
	if include_empty:
		return property_name.text
	else:
		if property_name.text == "":
			return "<Unnamed>"
		else:
			return property_name.text

func add_layer():
	layer_list.add_item("<Unnamed>")
	layers.append(Layer.new())
	
func set_selected_layer(layer : Layer):
	layer_name.text = layer.name
	visibility_check.pressed = layer.visible_in_game
	use_meshlib_check.pressed = layer.use_mesh_lib
	meshlib_button.set_current_file(layer.mesh_lib_path)
	use_as_properties_check.pressed = layer.use_as_properties
