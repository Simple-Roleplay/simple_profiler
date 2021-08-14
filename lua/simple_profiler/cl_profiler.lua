net.Receive("SimpleProfiler::Execute", function()
	local data = net.ReadTable()

	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW() * 0.7, ScrH() * 0.7)
	frame:SetTitle("Simple Profiler")
	frame:Center()
	frame:MakePopup()

	local listView = vgui.Create("DListView", frame)
	listView:Dock(FILL)
	listView:DockMargin(10, 10, 10, 10)
	listView:AddColumn("Player")
	listView:AddColumn("Net")
	listView:AddColumn("Count")
	listView:AddColumn("Total time")
	listView:AddColumn("Average time")

	listView.OnRowRightClick = function(_, _, line)
		local menu = DermaMenu()
		menu:AddOption("Show Steam profile", function()
			gui.OpenURL("http://steamcommunity.com/profiles/" .. line.steamID64)
		end):SetIcon("icon16/link.png")
		menu:AddOption("Copy SteamID64", function()
			SetClipboardText(line.steamID64)
			notification.AddLegacy("SteamID64 copied in the clipboard.", NOTIFY_CLEANUP, 5)
		end):SetIcon("icon16/page_copy.png")
		menu:Open()
	end

	for ply, nets in pairs(data) do
		for messageName, messageData in pairs(nets) do
			local line = listView:AddLine(ply:Name(), messageName, messageData.count, math.Round(messageData.totalTime, 5), math.Round(messageData.totalTime / messageData.count, 5))
			line.steamID64 = ply:SteamID64()
		end
	end
end)