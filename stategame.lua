require("objectplayer")
require("objectasteroid")
require("objectbullet")
require("objectexplosion")

stategame = {}

function stategame:load()
end

function stategame:reset()
    lives = 3
    score = 0

    entities = {}

    --create the player
    local player = objectplayer:new("player", spaceship, gameWidth / 2, gameHeight / 2, 40, 40,
    40, 0, 1, 0, 20)
    table.insert(entities, player)

    --create the asteroids
    for i=0, 15 do
        local ast = objectasteroid:new("asteroid", rock, love.math.random(0,gameWidth), love.math.random(0,gameHeight), 64, 64,
        0,0,16, 0, 25)
        table.insert(entities, ast)
    end
end

function stategame:keypressed(key)
    if key == 'space' and not entities[1].isDying then
        local bullet = objectbullet:new("bullet", fire_blue, entities[1].posx, entities[1].posy,
        32, 64, 0, 0, 16, entities[1].angle, 16)
        table.insert(entities, bullet)
        cl = laser:clone()
        cl:play()
    end
end

function stategame:keyreleased(key)
end

function isCollide(a,b)
    if a.posx < b.posx + b.width and
        a.posx + a.width > b.posx and
        a.posy < b.posy + b.height and
        a.posy + a.height > b.posy then
            return true
        end

    return false
end

function isCollideRadius(a,b)
	return (b.posx - a.posx)*(b.posx - a.posx) +
		(b.posy - a.posy)*(b.posy - a.posy) <
		(a.radius + b.radius)*(a.radius + b.radius)
end

function stategame:update(dt)

    for i,v in ipairs(entities) do
        v:update(dt)
    end

    for i,v in ipairs(entities) do
        for j,w in ipairs(entities) do
            if v.name == "bullet" and v.destroy == false and w.name == "asteroid" and w.destroy == false then
                if(isCollideRadius(v,w)) then
                    explosion:play()

                    --mark them for being destroyed later
                    v.destroy = true
                    w.destroy = true

                    local exp = objectexplosion:new("explosion", type_C, w.posx + 32 - 85, w.posy + 32 - 85,
                    171, 171, 0,0, 48, 0,0)
                    table.insert(entities, exp)
                    
                    --create two little asteroids
                    if w.radius == 25 then
                        local small = objectasteroid:new("asteroid", rock_small, w.posx, w.posy, 64, 64, 0, 0, 16, 0, 10)
                        table.insert(entities, small)
                        small = objectasteroid:new("asteroid", rock_small, w.posx, w.posy, 64, 64, 0, 0, 16, 0, 10)
                        table.insert(entities, small)
                    end

                    score = score + 10
                    break
                end
            end

            if v.name == "player" and w.name == "asteroid" and w.destroy == false then
                if(isCollideRadius(v,w)) then
                    w.destroy = true

                    local shipexp = objectexplosion:new("shipexplosion", type_B, w.posx + 20 - 64, w.posy + 20 - 64,
                    128,128,0,0,64,0,0)
                    table.insert(entities, shipexp)

                    shipexplosion:play()
                    entities[1].isDying = true
                    lives = lives - 1
                    if lives <= 0 then
                        gameover:play()
                        entities[1].isDying = false
                        table.insert(hiscores, score)
                        writeHiScores()
                        state = "GAMEOVER"
                    end

                    entities[1].posx = gameWidth / 2
                    entities[1].posy = gameHeight / 2
                    entities[1].velx = 0
                    entities[1].vely = 0
                end
            end
        end
    end

    --destroy marked elements
    for i=#entities, 1, -1 do
        if entities[i].destroy == true then
            if entities[i].name == "shipexplosion" then
                entities[1].isDying = false
            end
            table.remove(entities,i)
        end
    end
end

function stategame:draw()
    love.graphics.setColor(1,1,1)
    for i,v in ipairs(entities) do
        v:draw()
    end

    --draw UI
    love.graphics.setColor(1,0,0)
    love.graphics.print("Lives: " .. lives .. "   Score: " .. score, 5, 10)
end