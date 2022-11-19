statemenu = {}

function statemenu:load()
end

function statemenu:keypressed(key)
end

function statemenu:keyreleased(key)
    if key == "space" then
        state = "GAME"
        stategame:reset()
    end
end

function statemenu:update()
end

function statemenu:draw()
    love.graphics.print("Asteroids", 500, 300)
    love.graphics.print("press fire to play", 470, 350)
    love.graphics.print("hi scores", 500, 400)
    row = 450
    for i=1,5 do
        love.graphics.print(hiscores[i],580,row)
        row = row + 50
    end
end