
require 'math'

in_coords = {}

function draw()
    for c = 1, #colX, 1 do
        local x, y, z, command = colX[c], colY[c], colZ[c], colC[c] -- ia fiecare rand din array

        -- Locatia celor 4 colturi
        local pos = {
            {x - 10, y + 10, z},
            {x + 10, y + 10, z},
            {x - 10, y - 10, z},
            {x + 10, y - 10, z}
        }

        -- Converteste din 3D in Screen si adauga pozitia colturilor in array.
        local corners = {}
        for var = 1, 4, 1 do
            table.insert(corners, {convert3DCoordsToScreen(pos[var][1], pos[var][2], pos[var][3])})
        end

        -- Randeaza patratul
        if are_corners_visible(pos) then
            
            if checkbox1.v then
                render_box(corners)
            end
        end

        -- Executa comanda cand e in centrul patratului
        if is_between_corners(pos) then
            if in_coords[c] == 0 then
                send_message(command, delay.v)
                in_coords[c] = 1
            end
        else
            in_coords[c] = 0
        end
    end
end

function send_message(text, delay)
    lua_thread.create(function()
        wait(delay)
        sampSendChat(tostring(text))
    end)
end

function add_to_array(x, y, z, command)
    table.insert(colX, string.format("%d", x))
    table.insert(colY, string.format("%d", y))
    table.insert(colZ, string.format("%d", z))
    table.insert(colC, string.format("%s", command))
end

function remove_from_array(choice)
    if #colX == 0 then return 0 end
    table.remove(colX, choice + 1)
    table.remove(colY, choice + 1)
    table.remove(colZ, choice + 1)
    table.remove(colC, choice + 1)
end

function remove_all_from_array()
    for x = 1, #colX, 1 do
        colX[x] = nil
    end
    for x = 1, #colY, 1 do
        colY[x] = nil
    end
    for x = 1, #colZ, 1 do
        colZ[x] = nil
    end
    for x = 1, #colC, 1 do
        colC[x] = nil
    end
end

function is_between_corners(pos)
    local x, y, z = getCharCoordinates(playerPed)
	local corners = {0, 0}
	if (x > pos[1][1]) and (x < pos[2][1]) then corners[1] = 1 end
	if (y > pos[3][2]) and (y < pos[2][2]) then corners[2] = 1 end
	if (corners[1] == 1) and (corners[2] == 1) then return true else return false end
end 

function render_box(array)
    renderDrawLine(array[1][1], array[1][2], array[2][1], array[2][2], 1, -1)
    renderDrawLine(array[1][1], array[1][2], array[3][1], array[3][2], 1, -1)
    renderDrawLine(array[4][1], array[4][2], array[2][1], array[2][2], 1, -1)
    renderDrawLine(array[4][1], array[4][2], array[3][1], array[3][2], 1, -1)
end

function are_corners_visible(pos)
	count = 0
	for c, x in ipairs(pos) do
		if isPointOnScreen(x[1], x[2], x[3], 0) then
			count = count + 1
		end
	end
	if count == 4 then
		return true
	else
		return false
	end
end

function welcome()
    sampAddChatMessage("{ff0000}Area-Command: {ffffff} V0.0.1 ")
end