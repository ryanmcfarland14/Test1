--[[
StarterPlayerScripts
	[SCRIPT]
ReplicatedStorage
	PlayerGui
		FrameTest(1,0,1,0)
]]

--Services
local VRService = game:GetService("VRService")
local repStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local localSpace = game.Workspace.CurrentCamera

--(WHICH IS SMOOTHER? WE DON"T NEED BOTH)
--Setup
--Bound?
local part_bound = Instance.new("Part")
part_bound.Name("part_GuiReference")
part_bound.Parent = localSpace
part_bound.Anchored = true
--Edit more properties

--Smooth?
local part_smooth = Instance.new("Part")
part_smooth.Name("part_GuiSmoothing")
part_smooth.Parent = localSpace
Instance.new("BodyPosition").Parent = localSpace
Instance.new("BodyGyro").Parent = localSpace

part_smooth.BrickColor = BrickColor.new("Really red")

--Functions
local function bind()
	local newCFrame = VRService.GetUserCFrame(UserCFrame.Head)
	--Bound
	part_bound.CFrame = newCFrame
	
	--Smooth
	local x,y,z = newCFrame.X,newCFrame.Y,newCFrame.Z
	local newPos = Vector3.new(x,y,z)
	part_smooth.BodyPosition.Value = newPos
	part_smooth.BodyGyro.Value = newCFrame
end

--Connection
runService:BindToRenderStep("tempBinding", bind)