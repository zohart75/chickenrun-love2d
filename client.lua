local x = 0

client.Connect = function(ip)
  print("[CLIENT] Connecting to "..ip.."...")

  enetclient = enet.host_create()
  clientpeer = enetclient:connect(ip)

  ip = ip
end

client.Send = function(msg)
  clientpeer:send(msg)
end

client.Ready = function()
  enetclient:service(100)
end

client.Listen = function()
  hostevent = enetclient:service(0)

	if hostevent then
		if hostevent.type == "connect" then
			print("[CLIENT] Connected to " .. tostring(hostevent.peer) .. ".")
      currentmap = "waitingroom"
      client.id = tostring(hostevent.peer:connect_id())
      client.Send("idle " .. "chicken " .. math.random(0, 800) .. " " .. math.random(0, 600))
		end
		if hostevent.type == "receive" then
			print("[CLIENT] " .. tostring(hostevent.peer) .. ": " .. hostevent.data .. ";")
      client.ParseMessage(hostevent.data)
		end
	end

  enetclient:flush()
end

client.ParseMessage = function(msg)
  local args = split(msg, " ")
  if args[1] == "newPlayer" then
    if players[args[2]] then return end

    local ply = {}
    ply.skin = args[3]
    ply.x = args[4]
    ply.y = args[5]
    players[args[2]] = ply
  elseif args[1] == "movePlayer" and args[2] ~= client.id then
    for k,v in pairs(players)do
      if k == args[2] then
        v.x = args[3]
        v.y = args[4]
      end
    end
  elseif args[1] == "removePlayer" then
    players[args[2]] = nil
  end
end
