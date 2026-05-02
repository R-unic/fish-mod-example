--!strict
--!native
--!optimize 2

local SPAWN_COOLDOWN = 20

return function(id: string, api): ()
	print("hello from", id)
	local hasFish = false
	local function trySpawn(trap: Model): ()
		if hasFish then
			return
		end

		local _, bounds = trap:GetBoundingBox()
		local fishCFrame = trap:GetPivot() - Vector3.new(0, bounds.Y / 2, 0)
		print("cframe:", fishCFrame)
		local dropID: number = api:spawnItem("fish:raw_fish", fishCFrame)[1]
		print("spawned fish drop, id", dropID)
		local conn: RBXScriptConnection
		conn = api.dropPickedUp:Connect(function(pickedUp: number): ()
			if pickedUp ~= dropID then
				return
			end
			if not hasFish then
				return
			end
			print("fish drop picked up")
			hasFish = false
			conn:Disconnect()
		end)

		hasFish = true
	end

	api.structure:whenPlaced(function(info): ()
		if info.id ~= id then
			return
		end
		print("fish trap placed")
		while task.wait(SPAWN_COOLDOWN) do
			print("trying to spawn fish...")
			trySpawn(info.model)
		end
	end)
end
