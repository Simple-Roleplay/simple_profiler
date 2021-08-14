local callbacks, data = {}, {}
local sysTime = SysTime

util.AddNetworkString("SimpleProfiler::Execute")

local function print(...)
	MsgC(Color(251, 197, 49), "[Simple Profiler] ", Color(150, 150, 150), os.date("%H:%M:%S", os.time()), Color(255, 255, 255), " ", ..., "\n")
end

local function enableProfiler()
	if table.Count(callbacks) > 0 then
		return
	end

	callbacks = {}
	data = {}

	for messageName, callback in pairs(net.Receivers) do
		callbacks[messageName] = callback

		net.Receivers[messageName] = function(len, ply)
			if not data[ply] then
				data[ply] = {}
			end
			if not data[ply][messageName] then
				data[ply][messageName] = {}
			end

			data[ply][messageName].count = (data[ply][messageName].count or 0) + 1

			local savedTime = sysTime()
			callback(len, ply)
			data[ply][messageName].totalTime = (data[ply][messageName].totalTime or 0) + (sysTime() - savedTime)
		end
	end

	print("Profiler started.")
end

local function disableProfiler()
	for messageName, callback in pairs(callbacks) do
		net.Receivers[messageName] = callback
	end

	callbacks = {}

	print("Profiler ended.")
end

concommand.Add("profiler", function(ply, cmd, args)
	if not ply:IsAdmin() then
		return
	end

	if args[1] == "start" then
		enableProfiler()
	elseif args[1] == "stop" then
		disableProfiler()

		net.Start("SimpleProfiler::Execute")
		net.WriteTable(data)
		net.Send(ply)
	end
end)