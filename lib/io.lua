local gpu    = component.proxy(
    component.list("gpu")()
)
local event = require("event")

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

        if char == "\n" or char == "\13" then
            screen_pos_x=1
            screen_pos_y=screen_pos_y+1
        elseif char == "\8" then
            if screen_pos_x>1 then
                screen_pos_x=screen_pos_x-1
            else
                screen_pos_x=width
                screen_pos_y=screen_pos_y-1
            end
            gpu.set(screen_pos_x, screen_pos_y, " ")
        else
            if screen_pos_x>=width then
                screen_pos_x=1
                screen_pos_y=screen_pos_y+1
            end
            gpu.set(screen_pos_x, screen_pos_y, char)
            screen_pos_x=screen_pos_x+1
        end
    end
end

function io.println(msg)
    io.print(msg .. "\n")
end

function io.input(printmsg)
    if printmsg ~= nil then
        io.print(printmsg)
    end
    start_x=screen_pos_x
    start_y=screen_pos_y
    local data = ""
    while 1 do 
        local event = event.next()
        if event[1] == "key_down" then
            if event[3] == 8 then
                if start_y<screen_pos_y or (start_y==screen_pos_y and start_x<screen_pos_x ) then
                    io.print(string.char(event[3]))
                    data=data:sub(1,#data-1)
                end
            elseif event[3]==13 or string.char(event[3])=="\n" then
                break
            else
                data=data..string.char(event[3])
                io.print(string.char(event[3]))
            end
        end
    end
    io.println("")
    return data
end

function io.clear()
    local width, height = gpu.getResolution()
    gpu.fill(1, 1, width, height, " ")
end

return io
