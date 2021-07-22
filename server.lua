hostevent = nil

server.Host = function(ip)
  print("[SERVER] Starting hosting on "..ip.."...")
  enethost = enet.host_create(ip)
end

server.Listen = function()
  hostevent = enethost:service(16)

	if hostevent then
		if hostevent.type == "connect" then
			print("[SERVER] " .. tostring(hostevent.peer) .. " connected.")
		elseif hostevent.type == "receive" then
			print("[SERVER] " .. tostring(hostevent.peer) .. ": " .. hostevent.data .. ";")
      server.ParseMessage(hostevent.data, hostevent.peer)
		elseif hostevent.type == "disconnect" then
			print("[SERVER] " .. tostring(hostevent.peer) .. " disconnected.")
		end
	end
end

server.Broadcast = function(msg)
  enethost:broadcast(msg)
end

server.ParseMessage = function(msg, peer)
  local args = split(msg, " ")
  if args[1] == "idle" then
    local ply = {}
    ply.skin = args[2]
    ply.x = args[3]
    ply.y = args[4]
    players[tostring(peer:connect_id())] = ply
    server.Broadcast("newPlayer " .. peer:connect_id() .. " " .. ply.skin .. " " .. ply.x .. " " .. ply.y)

    for k,v in pairs(players)do
      if k ~= peer:connect_id() then
        server.Broadcast("newPlayer " .. k .. " " .. v.skin .. " " .. v.x .. " " .. v.y)
      end
    end
  elseif args[1] == "movePlayer" then
    for k,v in pairs(players)do
      if k == tostring(peer:connect_id()) then
        v.x = args[2]
        v.y = args[3]

        server.Broadcast("movePlayer " .. k .. " " .. v.x .. " " .. v.y)
      end
    end
  elseif args[1] == "disconnect" then
    players[tostring(peer:connect_id())] = nil
    server.Broadcast("removePlayer " .. peer:connect_id())
  end
end
