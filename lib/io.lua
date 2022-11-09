local gpu    = component.proxy(
    component.list("gpu")()
)

io = {}

screen_pos_x = 1
screen_pos_y = 1

function io.gpu_init()
    local screen_addr = component.list("screen")()
    gpu.bind(screen_addr, true)
end

function io.init()
    io.gpu_init()
end

function io.print(msg)
    local width, height = gpu.getResolution()
    for msg_pos = 1, #msg do
        char=msg:sub(msg_pos,msg_pos)
        if screen_pos_x>=width then
            screen_pos_x=1
            screen_pos_y=screen_pos_y+1
        end
        if char == "\n" then
            screen_pos_x=1
            screen_pos_y=screen_pos_y+1
        else
            gpu.set(screen_pos_x, screen_pos_y, char)
            screen_pos_x=screen_pos_x+1
        end
    end
end

function io.println(msg)
    io.print(msg .. "\n")
end

function io.clear()
    local width, height = gpu.getResolution()
    gpu.fill(1, 1, width, height, " ")
end

return io