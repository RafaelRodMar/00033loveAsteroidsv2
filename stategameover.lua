stategameover = {}

function stategameover:load()
end

function stategameover:keypressed(key)
end

function stategameover:keyreleased(key)
    if key == 'space' then
        state = "MENU"
        return
    end
end

function stategameover:update()
end

function stategameover:draw()
    love.graphics.print("GAME OVER", 500, 300)
    love.graphics.print("press fire to menu", 470, 350)
end