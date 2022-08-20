tool
extends EditorScenePostImport


func post_import(scene: Object) -> Object:
	var node := scene as Node
	for child in node.get_children():
		var mesh_instance := child as MeshInstance
		var body := StaticBody.new()
		var collision_shape := CollisionShape.new()

		mesh_instance.transform.origin = Vector3.ZERO
		mesh_instance.use_in_baked_light = true
		(mesh_instance.mesh as ArrayMesh).lightmap_unwrap(Transform.IDENTITY, 0.05)

		mesh_instance.add_child(body)
		body.owner = scene

		body.add_child(collision_shape)
		collision_shape.owner = scene
		var shape := mesh_instance.mesh.create_trimesh_shape()
		collision_shape.shape = shape
		collision_shape.scale = mesh_instance.scale
		collision_shape.visible = false

	return node
