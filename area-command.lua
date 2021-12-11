imgui = require 'imgui'
require 'area-command.functions'
require 'area-command.config'
require 'area-command.style'
require 'area-command.vars'

cheat_status = false

function imgui.OnDrawFrame()
	imgui.SetNextWindowSize(imgui.ImVec2(config.main_window.size[1], config.main_window.size[2]))
	imgui.Begin(config.main_window.title, imgui.WindowFlags.NoResize)

	-- Child #1
	imgui.BeginChild("Coords", imgui.ImVec2(620, 203), true)
	imgui.PushItemWidth(50)
	imgui.ListBox("##X", selected, colX, 10)
	imgui.PopItemWidth()
	imgui.SameLine()
	imgui.PushItemWidth(50)
	imgui.ListBox("##Y", selected, colY, 10) 
	imgui.PopItemWidth()
	imgui.SameLine()
	imgui.PushItemWidth(50)
	imgui.ListBox("##Z", selected, colZ, 10)
	imgui.PopItemWidth()
	imgui.SameLine()
	imgui.PushItemWidth(425)
	imgui.ListBox("##C", selected, colC, 10)
	imgui.PopItemWidth()
	imgui.SameLine()	
	imgui.EndChild()

	-- Child #2
	imgui.BeginChild("Widgets", imgui.ImVec2(620, 105), true)
	if imgui.Button("Add Coords", imgui.ImVec2(config.widgets.button.size[1], config.widgets.button.size[2])) then
		cX, cY, cZ = getCharCoordinates(playerPed)
		if #input1.v ~= 0 then
			add_to_array(cX, cY, cZ, input1.v)
		end
	end
	imgui.SameLine()
	if imgui.Button("Remove", imgui.ImVec2(config.widgets.button.size[1], config.widgets.button.size[2])) then
		remove_from_array(selected.v)
	end
	imgui.SameLine()
	if imgui.Button("Remove all", imgui.ImVec2(config.widgets.button.size[1], config.widgets.button.size[2])) then
		remove_all_from_array()
	end
	imgui.SameLine()
	imgui.Checkbox("Render targets", checkbox1) 
	if imgui.InputText("Command", input1) then
		if #input1.v > 127 then input1.v = "" end
	end
	if imgui.InputInt("Delay", delay) then
		if (delay.v < 0) or (delay.v > 10000) then delay.v = 0 end
	end


	imgui.EndChild()
	imgui.End()
end

function main()
	welcome()
	apply_custom_style()
	while true do
		wait(0)
		draw()
		if wasKeyPressed(0x71) then
			cheat_status = not cheat_status
		end
		imgui.Process = cheat_status
	end
end
