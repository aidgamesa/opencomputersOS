local eeprom = component.proxy(
    component.list("eeprom")()
)
local disk   = component.proxy(
    eeprom.getData()
)

local require = function(module)
    local fd=disk.open("lib/" .. module .. ".lua")
    data=disk.read(fd, math.huge)
    disk.close(fd)
    return load(data)()
end



local text
if disk.exists("text.txt") then
    fd=disk.open("text.txt")
    text=disk.read(fd, math.huge)
    disk.close(fd)
else
    text="Hello, world text"
end

local io = require("io")
local event = require("event")

io.init()
io.clear()
io.println("Hello, world")
io.println("Hello, world")
io.println("Hello, world")

while 1 do 
    curr_event = event.next()
    if curr_event[1] == "key_down" then
        if curr_event[3] > 0 then
            io.print(string.char(curr_event[3]))
        end
    end
end