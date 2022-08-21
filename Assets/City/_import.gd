tool
extends EditorScenePostImport

func post_import(scene: Object) -> Object:
	var node := scene as Node
	var tmp := node.get_child(0)
	var mesh_instance := tmp.get_child(0) as MeshInstance
	var body := StaticBody.new()
	var collision_shape := CollisionShape.new()

	tmp.remove_child(mesh_instance)
	mesh_instance.transform.origin = Vector3.ZERO
	mesh_instance.name = node.name
	mesh_instance.use_in_baked_light = true
	(mesh_instance.mesh as ArrayMesh).lightmap_unwrap(Transform.IDENTITY, 0.05)
	mesh_instance.set_script(preload("res://Src/Building/Building.gd"))

	mesh_instance.add_child(body)
	body.owner = mesh_instance

	body.add_child(collision_shape)
	collision_shape.owner = mesh_instance
	var shape := mesh_instance.mesh.create_trimesh_shape()
	collision_shape.shape = shape
	collision_shape.scale = mesh_instance.scale
	collision_shape.visible = false

	return mesh_instance
