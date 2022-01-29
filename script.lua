-- MeepCity Avatar Cloner
-- made specially for Synapse X

-- synolope#7126


getgenv().stealth = getgenv().stealth or true -- saves avatar without exposing it to target if enabled


















if game.PlaceId == 370731277 then
	wait(3)
	local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage")
	local Constants = require(l__ReplicatedStorage__2:WaitForChild("Constants"))
	local Connection = l__ReplicatedStorage__2:WaitForChild("Connection")
	local ConnectionEvent = l__ReplicatedStorage__2:WaitForChild("ConnectionEvent")

	function indexOf(array, value)
		for i, v in ipairs(array) do
			if v == value then
				return i
			end
		end
		return nil
	end

	function colorToTable(clr) return {tostring(clr.R*255),tostring(clr.G*255),tostring(clr.B*255)} end

	function AddAccessories(typ,...)
		local ids = {...}
		local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
		local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
		local Accessory = wearing[typ.."Accessory"] or ""


		local t = string.split(Accessory,",")

		for _,id in pairs(ids) do
			if table.find(t,id) then
				table.remove(t,indexOf(t,id))
			end
			id = tostring(id)
			table.insert(t,id)
		end

		local dps = {}

		for _,id in pairs(t) do
			local duped = false
			for _,dip in pairs(dps) do
				if id == dip then
					duped = true
					break
				end
			end
			if not duped then
				table.insert(dps,id)
			end
		end

		t = dps

		Accessory = table.concat(t,",")

		wearing[typ.."Accessory"] = Accessory

		ConnectionEvent:FireServer(315,wearing,true)
	end

	function RemoveAccessories(typ,...)
		local ids = {...}
		local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
		local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
		local Accessory = wearing[typ.."Accessory"] or ""


		local t = string.split(Accessory,",")

		for _,id in pairs(ids) do
			id = tostring(id)
			table.remove(t,indexOf(t,id))
		end

		Accessory = table.concat(t,",")

		wearing[typ.."Accessory"] = Accessory

		ConnectionEvent:FireServer(315,wearing,true)
	end

	function RemoveAllAccessories(typ)
		local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
		local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing

		wearing[typ.."Accessory"] = ""

		ConnectionEvent:FireServer(315,wearing,true)
	end

	function SetShirt(id)
		local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
		local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing

		wearing.Shirt = tonumber(id) or 0

		ConnectionEvent:FireServer(315,wearing,true)
	end

	function SetPants(id)
		local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
		local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing

		wearing.Pants = tonumber(id) or 0

		ConnectionEvent:FireServer(315,wearing,true)
	end

	function SetAttribute(a,val)
		local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
		local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
		wearing[a] = val
		ConnectionEvent:FireServer(315,wearing,true)
	end

	function GetAttribute(a,val)
		local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
		local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
		return wearing[a]
	end

	function GetAllAttributes()
		local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
		local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing
		return wearing
	end

	function ResetAvatar()
		ConnectionEvent:FireServer(315,{},true)
	end

	function SaveAvatar(name)
		local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
		local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing

		if not isfolder("Meep City Avatar Saves") then
			makefolder("Meep City Avatar Saves")
		end

		apath = "Meep City Avatar Saves\\" .. name .. ".json"

		writefile(apath, game:GetService("HttpService"):JSONEncode(wearing))

		print("Saved as '" .. name .. "'")
	end

	function LoadAvatar(name)
		local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
		local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing

		if not isfolder("Meep City Avatar Saves") then
			makefolder("Meep City Avatar Saves")
		end

		apath = "Meep City Avatar Saves\\" .. name .. ".json"

		ConnectionEvent:FireServer(315,game:GetService("HttpService"):JSONDecode(readfile(apath)),true)

		print("Loaded '" .. name .. "'")
	end

	function SaveCurrentOutfit(name)
		local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
		local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing

		local args = {
			[1] = 65,
			[2] = tostring(name)
		}

		game:GetService("ReplicatedStorage").Connection:InvokeServer(unpack(args))

		local args = {
			[1] = 319,
			[2] = wearing
		}

		game:GetService("ReplicatedStorage").Connection:InvokeServer(unpack(args))
	end

	local ScreenGui = Instance.new("ScreenGui",game.CoreGui)
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.Name = math.random(1,1000000)

	local StealthToggle = Instance.new("TextButton",ScreenGui)
	StealthToggle.AnchorPoint = Vector2.new(0.5,1)
	StealthToggle.Position = UDim2.new(0.5,0,1,-5)
	StealthToggle.Size = UDim2.new(0,147,0,32)
	StealthToggle.TextSize = 14
	StealthToggle.Font = Enum.Font.SourceSans
	StealthToggle.BorderSizePixel = 0
	StealthToggle.TextColor3 = Color3.new(.8,.8,.8)
	StealthToggle.BackgroundColor3 = Color3.new(.1,.1,.1)
	StealthToggle.RichText = true
	StealthToggle.LineHeight = 1.2

	Instance.new("UICorner",StealthToggle)

	StealthToggle.Text = "<b>Stealth:</b> " .. tostring(getgenv().stealth)

	StealthToggle.MouseButton1Click:Connect(function()
		getgenv().stealth = not getgenv().stealth
		StealthToggle.Text = "<b>Stealth:</b> " .. tostring(getgenv().stealth)
	end)

	local overlap = false

	function LoadPlayer(player)
		coroutine.wrap(function()
			if player ~= game:GetService("Players").LocalPlayer then
				local user =  player.Name
				local function LoadCharacter(character)
					local prox = Instance.new("ProximityPrompt",character:WaitForChild("HumanoidRootPart"))
					prox.ActionText = "Clone Avatar"
					prox.ObjectText = user
					prox.KeyboardKeyCode = Enum.KeyCode.C
					prox.HoldDuration = .2
					prox.RequiresLineOfSight = false
					prox.Triggered:Connect(function()
						if not overlap then
							local hum = character.Humanoid
							local humdes = hum.HumanoidDescription

							overlap = true

							local data = Connection:InvokeServer(Constants.AE_REQUEST_AE_DATA)
							local wearing = data.PlayerCurrentTemporaryOutfit or data.PlayerCurrentlyWearing

							local pos = CFrame.new(0,0,0)

							local stealth = getgenv().stealth

							if stealth then
								local LP = game:GetService("Players").LocalPlayer
								local character = LP.Character or LP.CharacterAdded:Wait()
								local root = character:WaitForChild("HumanoidRootPart")
								root.Anchored = true
								pos = root.CFrame
								root.CFrame = CFrame.new(0,400,0)
							end

							ResetAvatar()
							wait()
							ResetAvatar()
							wait()

							-- ^^ make sure it resets!
							
							local ava = {}

							--[[SetAttribute("WidthScale",humdes.WidthScale)
							SetAttribute("HeadScale",humdes.HeadScale)
							SetAttribute("HeightScale",humdes.HeightScale)
							SetAttribute("DepthScale",humdes.DepthScale)
							SetAttribute("BodyTypeScale",humdes.BodyTypeScale)
							SetAttribute("ProportionScale",humdes.ProportionScale)

							SetAttribute("Face",humdes.Face)
							SetAttribute("Head",humdes.Head)
							SetAttribute("LeftArm",humdes.LeftArm)
							SetAttribute("RightArm",humdes.RightArm)
							SetAttribute("LeftLeg",humdes.LeftLeg)
							SetAttribute("RightLeg",humdes.RightLeg)
							SetAttribute("Torso",humdes.Torso)

							SetAttribute("HeadColor",colorToTable(humdes.HeadColor))
							SetAttribute("LeftArmColor",colorToTable(humdes.LeftArmColor))
							SetAttribute("RightArmColor",colorToTable(humdes.RightArmColor))
							SetAttribute("LeftLegColor",colorToTable(humdes.LeftLegColor))
							SetAttribute("RightLegColor",colorToTable(humdes.RightLegColor))
							SetAttribute("TorsoColor",colorToTable(humdes.TorsoColor))

							SetAttribute("GraphicTShirt",humdes.GraphicTShirt)
							SetShirt(humdes.Shirt)
							SetPants(humdes.Pants)

							AddAccessories("Head",unpack(string.split(humdes.HatAccessory,",")))
							AddAccessories("Hair",unpack(string.split(humdes.HairAccessory,",")))
							AddAccessories("Back",unpack(string.split(humdes.BackAccessory,",")))
							AddAccessories("Face",unpack(string.split(humdes.FaceAccessory,",")))
							AddAccessories("Front",unpack(string.split(humdes.FrontAccessory,",")))
							AddAccessories("Neck",unpack(string.split(humdes.NeckAccessory,",")))
							AddAccessories("Shoulders",unpack(string.split(humdes.ShouldersAccessory,",")))
							AddAccessories("Waist",unpack(string.split(humdes.WaistAccessory,",")))

							SetAttribute("ClimbAnimation",humdes.ClimbAnimation)
							SetAttribute("FallAnimation",humdes.FallAnimation)
							SetAttribute("IdleAnimation",humdes.IdleAnimation)
							SetAttribute("JumpAnimation",humdes.JumpAnimation)
							SetAttribute("RunAnimation",humdes.RunAnimation)
							SetAttribute("SwimAnimation",humdes.SwimAnimation)
							SetAttribute("WalkAnimation",humdes.WalkAnimation)

							SetAttribute("Emotes",humdes:GetEmotes())]]
							
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

							SaveCurrentOutfit(user .. " Cloned")

							SaveAvatar(user.. "'s Avatar")

							if stealth then
								local LP = game:GetService("Players").LocalPlayer
								local character = LP.Character or LP.CharacterAdded:Wait()
								local root = character:WaitForChild("HumanoidRootPart")
								ConnectionEvent:FireServer(315,wearing,true)
								root.CFrame = pos
								root.Anchored = false
							end

							overlap = false

						end
					end)
				end
				LoadCharacter(player.Character or player.CharacterAdded:Wait())
				player.CharacterAdded:Connect(LoadCharacter)
			end
		end)()
	end

	for _,player in pairs(game:GetService("Players"):GetPlayers()) do LoadPlayer(player) end
	game:GetService("Players").PlayerAdded:Connect(LoadPlayer)
end