--- Main injection point
-- @script ClientMain
-- @author Quenty

local packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")

local serviceBag = require(packages.ServiceBag).new()
serviceBag:GetService(require(packages.CmdrServiceClient))

serviceBag:Init()
serviceBag:Start()