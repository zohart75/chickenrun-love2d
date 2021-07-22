function movePlayer(dt)
  if not enetclient then return end

  local ply = players[client.id]

  if not ply then return end

  local x,y = ply.x, ply.y

  if love.keyboard.isDown("w") then
    y = y - (speed * dt)
  end

  if love.keyboard.isDown("s") then
    y = y + (speed * dt)
  end

  if love.keyboard.isDown("d") then
    x = x + (speed * dt)
  end

  if love.keyboard.isDown("a") then
    x = x - (speed * dt)
  end

  if x ~= ply.x or y ~= ply.y then
    players[client.id].x = x
    players[client.id].y = y
    client.Send("movePlayer " .. x .. " " .. y)
  end
end
