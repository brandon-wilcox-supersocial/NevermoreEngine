--- Utility functions for constructing rays from input objects
-- @module InputObjectRayUtils

local Workspace = game:GetService("Workspace")

local DEFAULT_RAY_DISTANCE = 1000

local InputObjectRayUtils = {}

function InputObjectRayUtils.cameraRayFromInputObject(inputObject, distance, offset, camera)
	assert(inputObject, "Bad inputObject")
	offset = offset or Vector3.new()

	return InputObjectRayUtils.cameraRayFromScreenPosition(inputObject.Position + offset, distance, camera)
end

function InputObjectRayUtils.cameraRayFromMouse(mouse, distance, offset, camera)
	assert(mouse, "Bad mouse")
	offset = offset or Vector3.new(0, 0, 0)

	return InputObjectRayUtils.cameraRayFromScreenPosition(
		Vector2.new(mouse.x + offset.x, mouse.y + offset.y),
		distance,
		camera)
end

function InputObjectRayUtils.cameraRayFromInputObjectWithOffset(inputObject, distance, offset, camera)
	assert(inputObject, "Bad inputObject")

	return InputObjectRayUtils.cameraRayFromScreenPosition(
		inputObject.Position + offset,
		distance,
		camera)
end

function InputObjectRayUtils.cameraRayFromScreenPosition(position, distance, camera)
	distance = distance or DEFAULT_RAY_DISTANCE
	camera = camera or Workspace.CurrentCamera

	local baseRay = camera:ScreenPointToRay(position.X, position.Y)
	return Ray.new(baseRay.Origin, baseRay.Direction.unit * distance)
end

function InputObjectRayUtils.cameraRayFromViewportPosition(position, distance, camera)
	distance = distance or DEFAULT_RAY_DISTANCE
	camera = camera or Workspace.CurrentCamera

	local baseRay = camera:ViewportPointToRay(position.X, position.Y)
	return Ray.new(baseRay.Origin, baseRay.Direction.unit * distance)
end


-- Generates a circle of rays including the center ray
function InputObjectRayUtils.generateCircleRays(ray, count, radius)
	local rays = { }

	local origin = ray.Origin
	local direction = ray.Direction

	local cframePointing = CFrame.new(origin, origin + direction)

	for i=1, count do
		local angle = math.pi*2*(i-1)/count
		local offset = cframePointing:vectorToWorldSpace(Vector3.new(
			math.cos(angle)*radius,
			math.sin(angle)*radius,
			0))
		table.insert(rays, Ray.new(origin + offset, direction))
	end

	return rays
end

return InputObjectRayUtils