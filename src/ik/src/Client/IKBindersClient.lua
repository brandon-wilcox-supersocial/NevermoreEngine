--- Holds binders
-- @classmod IKBindersClient
-- @author Quenty

local require = require(game:GetService("ReplicatedStorage"):WaitForChild("Nevermore"))

local BinderProvider = require("BinderProvider")
local Binder = require("Binder")

return BinderProvider.new(function(self, serviceBag)
	-- Rig
	self:Add(Binder.new("IKRig", require("IKRigClient"), serviceBag))

	-- Grips
	self:Add(Binder.new("IKRightGrip", require("IKRightGrip"), serviceBag))
	self:Add(Binder.new("IKLeftGrip", require("IKLeftGrip"), serviceBag))
end)