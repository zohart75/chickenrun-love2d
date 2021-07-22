server = {}
client = {}

ip = nil

enethost = nil
clientpeer = nil

players = {}

assets = {}
currentmap = "lobby"

speed = 200

enet = require("enet")
suit = require "suit"

function table.count(tbl)
  local count = 0
  for k,v in pairs(tbl)do
    count = count + 1
  end

  return count
end

function dump(o)
  if type(o) == 'table' then
    local s = '{ '
      for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
    return s .. '} '
  else
    return tostring(o)
  end
end

function split (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

require("server")
require("client")
require("assets")
require("map")
require("player")

local show_message = false
function love.load()
  connection = "none"
end

function love.update(dt)
  if enethost then
    server.Listen()
  end

  if clientpeer then
    client.Listen()
  end

  makeUI(dt)
  movePlayer(dt)
end

function love.draw()
  w, h = love.graphics.getWidth(), love.graphics.getHeight()
  draw = love.graphics

  if(currentmap == "lobby")then
    draw.setColor(.2, .2, .2)
    draw.rectangle("fill", 0, 0, w, h)
  elseif(currentmap == "waitingroom")then
    for k,v in pairs(players)do
      local skin = assets.characters[v.skin]
      draw.setColor(1, 1, 1)
      draw.draw(skin, v.x, v.y, 0, 1, 1, skin:getWidth()/2, skin:getHeight()/2)
    end
  end

  suit.draw()
end

function love.textinput(t)
    suit.textinput(t)
end

function love.keypressed(key)
    suit.keypressed(key)
end
