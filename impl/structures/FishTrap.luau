return function(id, structureAPI)
	print("hello from", id, "implementation!")
	structureAPI:whenPlaced(function(info)
		if info.id ~= id then
			return
		end
		print("fish trap placed, starting fishing...")
	end)
end
