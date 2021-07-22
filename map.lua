local inputip = {text = "localhost:8301"}

function makeUI(dt)
  w, h = love.graphics.getWidth(), love.graphics.getHeight()
  x, y = w/2, h/2

  if not love.window.isVisible() then return end

  if(currentmap == "lobby")then
    suit.Label("Chicken", {font = assets.fonts["Title"], align = "center", valign = "center"}, x - 125 - 39 - 6, y - 15 - 100, 250, 30)
    suit.Label("RUN", {font = assets.fonts["TitleBold"], align = "center", valign = "center"}, x - 125 + 75 - 6, y - 15 - 100, 250, 30)
    suit.Label("v1.0", {font = assets.fonts["SubTitle"], align = "center", valign = "center"}, x - 125, y - 15 - 60, 250, 30)

    local ip = suit.Input(inputip, {font = assets.fonts["Button"], align = "center", valign = "top"}, x - 125, y + 12.5 + 5, 250, 40)

    if suit.Button("Host", {font = assets.fonts["Button"], align = "center", valign = "center"}, x - 125, y - 12.5, 250 / 2 - 2.5, 25).hit then
      if love.window.showMessageBox("Warning!", "You're hosting server!\nThe game window will disappear and host will run in the background. Be sure to run game with lovec.exe!", {"Continue", "Stop"}) == 1 then
        love.window.close()
        server.Host(inputip.text)
        connection = "host"
        return
      else return end
    end

    if suit.Button("Connect", {font = assets.fonts["Button"], align = "center", valign = "center"}, x + 2.5, y - 12.5, 250 / 2 - 2.5, 25).hit then
      client.Connect(inputip.text)
      connection = "client"
    end
  elseif(currentmap == "waitingroom")then
    if suit.Button("Disconnect", {font = assets.fonts["Button"], align = "center", valign = "top"}, 5, 5, 85, 25).hit then
      if clientpeer then client.Send("disconnect ") clientpeer:disconnect_later() enetclient:flush() end
      if enethost then enethost:destroy() enethost = nil end

      connection = "none"
      currentmap = "lobby"
      players = {}

      print("Disconnected.")
    end
  end

  --suit.Label("Players: " .. table.count(players), {font = assets.fonts["Title"], align = "right", valign = "top"}, 0, 0, 250, 30)
end
