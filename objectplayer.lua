objectplayer = {}

objectplayer_mt = { __index = objectplayer }

function objectplayer:new(name, tex, x, y, w, h, u, v, nFrames, ang, rad)
    local entity = {}
    setmetatable(entity, objectplayer_mt)
    
    entity.name = name
    entity.texture = tex
    entity.posx = x
    entity.posy = y
    entity.width = w
    entity.height = h
    entity.velx = 0
    entity.vely = 0
    entity.angle = ang
    entity.radius = rad
    entity.alpha = 0
    entity.frames = {}
    entity.currentRow = 0
    entity.currentFrame = 1
    entity.numFrames = nFrames
    entity.thrust = 0
    entity.destroy = false
    entity.isDying = false

    table.insert(entity.frames, love.graphics.newQuad(u,v,w,h,tex:getWidth(),tex:getHeight()))
    table.insert(entity.frames, love.graphics.newQuad(u,v+40,w,h,tex:getWidth(),tex:getHeight()))

    return entity
end

function objectplayer:update(dt)
    if self.isDying then return end

    if love.keyboard.isDown( 'left' ) then
        self.angle = self.angle - 300 * dt
    end
    if love.keyboard.isDown( 'right' ) then
        self.angle = self.angle + 300 * dt
    end
    if love.keyboard.isDown( 'up' ) then
        self.thrust = true
    else
        self.thrust = false
    end

    if self.thrust then
        self.velx = self.velx + math.cos(math.rad(self.angle - 90)) * 0.2
        self.vely = self.vely + math.sin(math.rad(self.angle - 90)) * 0.2
    else
        self.velx = self.velx * 0.99
        self.vely = self.vely * 0.99
    end

    local maxSpeed = 15
    local speed =  math.sqrt(self.velx * self.velx + self.vely * self.vely)
    if speed > maxSpeed then
        self.velx = self.velx * maxSpeed / speed
        self.vely = self.vely * maxSpeed / speed
    end

    self.posx = self.posx + self.velx * dt * 25
    self.posy = self.posy + self.vely * dt * 25

    if self.posx > gameWidth then self.posx = 0 end
    if self.posx < 0 then self.posx = gameWidth end
    if self.posy > gameHeight then self.posy = 0 end
    if self.posy < 0 then self.posy = gameHeight end
end

function objectplayer:draw()
    local cFrame = math.floor(self.currentFrame / self.numFrames * #self.frames)
    if cFrame < 1 then 
        cFrame = 1
    elseif cFrame > self.numFrames then
        cFrame = self.numFrames
    end

    if not self.isDying then
        if self.thrust then
            love.graphics.draw(self.texture, self.frames[cFrame + 1],self.posx,self.posy, math.rad(self.angle), 1, 1, 20, 20, 0, 0)
        else
            love.graphics.draw(self.texture, self.frames[cFrame],self.posx,self.posy, math.rad(self.angle), 1, 1, 20, 20, 0, 0)
        end
    end
end