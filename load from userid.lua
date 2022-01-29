local userId = 2






function colorToTable(clr) return {tostring(clr.R*255),tostring(clr.G*255),tostring(clr.B*255)} end

local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage")
local Constants = require(l__ReplicatedStorage__2:WaitForChild("Constants"))
local Connection = l__ReplicatedStorage__2:WaitForChild("Connection")
local ConnectionEvent = l__ReplicatedStorage__2:WaitForChild("ConnectionEvent")

local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing

local humdes = game:GetService("Players"):GetHumanoidDescriptionFromUserId(userId)

local ava = {}


for _,v in pairs({"WidthScale", "HeadScale","HeightScale","DepthScale","BodyTypeScale","ProportionScale"}) do
	ava[v] = humdes[v]
end

for _,v in pairs({"Face","Head","LeftArm","RightArm","LeftLeg","RightLeg","Torso"}) do
	ava[v] = humdes[v]
end

for _,v in pairs({"HeadColor","LeftArmColor","RightArmColor","LeftLegColor","RightLegColor","TorsoColor"}) do
	ava[v] = colorToTable(humdes[v])
end

for _,v in pairs({"GraphicTShirt","Shirt","Pants"}) do
	ava[v] = humdes[v]
end

for _,v in pairs({"ClimbAnimation","FallAnimation","IdleAnimation","JumpAnimation","RunAnimation","SwimAnimation","WalkAnimation"}) do
	ava[v] = humdes[v]
end


for _,v in pairs({"Hat","Hair","Back","Face","Front","Neck","Shoulders","Waist"}) do
	ava[v .. "Accessory"] = humdes[v .. "Accessory"]
end

ava.Emotes = humdes:GetEmotes()

ConnectionEvent:FireServer(315,ava,true)