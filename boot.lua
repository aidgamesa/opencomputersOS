local gpu    = component.proxy(
    component.list("gpu")()
)
local eeprom = component.proxy(
    component.list("eeprom")()
)
local disk   = component.proxy(
    eeprom.getData()
)

local screen_addr = component.list("screen")()

gpu.bind(screen_addr, true)


local width, height = gpu.getResolution()
-- Clear screen
gpu.fill(1, 1, width, height, " ")

local text
if disk.exists("text.txt") then
    fd=disk.open("text.txt")
    text=disk.read(fd, math.huge)
    disk.close(fd)
else
    text="Hello, world text"
end

while 1 do
    --gpu.fill(1, 1, width, height, " ")
    gpu.set(1, 1, "Hello, world!")
    gpu.set(1, 2, text)
end