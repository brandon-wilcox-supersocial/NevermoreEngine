---
-- @module CameraStoryUtils
-- @author Quenty

local require = require(script.Parent.loader).load(script)

local RunService = game:GetService("RunService")

local InsertServiceUtils = require("InsertServiceUtils")
local Promise = require("Promise")
local Math = require("Math")

local CameraStoryUtils = {}

function CameraStoryUtils.reflectCamera(maid, topCamera)
	local camera = Instance.new("Camera")
	camera.Name = "ReflectedCamera"
	maid:GiveTask(camera)

	local function update()
		camera.FieldOfView = topCamera.FieldOfView
		camera.CFrame = topCamera.CFrame
	end
	maid:GiveTask(topCamera:GetPropertyChangedSignal("CFrame"):Connect(update))
	maid:GiveTask(topCamera:GetPropertyChangedSignal("FieldOfView"):Connect(update))

	update()

	return camera
end

function CameraStoryUtils.setupViewportFrame(maid, target)
	local viewportFrame = Instance.new("ViewportFrame")
	viewportFrame.ZIndex = 0
	viewportFrame.BorderSizePixel = 0
	viewportFrame.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	viewportFrame.Size = UDim2.new(1, 0, 1, 0)
	maid:GiveTask(viewportFrame)

	local reflectedCamera = CameraStoryUtils.reflectCamera(maid, workspace.CurrentCamera)
	reflectedCamera.Parent = viewportFrame
	viewportFrame.CurrentCamera = reflectedCamera

	viewportFrame.Parent = target

	return viewportFrame
end

function CameraStoryUtils.promiseCrate(maid, viewportFrame, properties)
	return maid:GivePromise(InsertServiceUtils.promiseAsset(182451181)):Then(function(model)
		maid:GiveTask(model)

		local crate = model:GetChildren()[1]
		if not crate then
			return Promise.rejected()
		end

		if properties then
			for _, item in pairs(crate:GetDescendants()) do
				if item:IsA("BasePart") then
					for property, value in pairs(properties) do
						item[property] = value
					end
				end
			end
		end

		crate.Parent = viewportFrame

		local camera = viewportFrame.CurrentCamera
		if camera then
			local cameraCFrame = camera.CFrame
			local cframe = CFrame.new(cameraCFrame.Position + cameraCFrame.lookVector*25)
			crate:SetPrimaryPartCFrame(cframe)
		end

		return Promise.resolved(crate)
	end)
end

function CameraStoryUtils.getInterpolationFactory(maid, viewportFrame, low, high, period, toCFrame)
	assert(maid, "Bad maid")
	assert(viewportFrame, "Bad viewportFrame")
	assert(type(low) == "number", "Bad low")
	assert(type(high) == "number", "Bad high")
	assert(type(period) == "number", "Bad period")
	assert(type(toCFrame) == "function", "Bad toCFrame")

	return function(interpolate, color)
		assert(type(interpolate) == "function", "Bad interpolate")
		assert(typeof(color) == "Color3", "Bad color")

		maid:GivePromise(CameraStoryUtils.promiseCrate(maid, viewportFrame, {
			Color = color;
			Transparency = 0.5
		}))
			:Then(function(crate)
				maid:GiveTask(RunService.RenderStepped:Connect(function()
					local t = (os.clock()/period % 2/period)*period
					if t >= 1 then
						t = 1 - (t % 1)
					end

					t = Math.map(t, 0, 1, low, high)
					t = math.clamp(t, low, high)

					local cframe = toCFrame(interpolate(t))
					crate:SetPrimaryPartCFrame(cframe)
				end))
			end)
	end
end

return CameraStoryUtils