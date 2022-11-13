local eeprom = component.proxy(
    component.list("eeprom")()
)
local disk   = component.proxy(
    eeprom.getData()
)
libs_loaded={}

require = function(module)
    if libs_loaded[module] ~= nil then
        return libs_loaded[module]
    end
    local fd=disk.open("lib/" .. module .. ".lua")
    data=disk.read(fd, math.huge)
    disk.close(fd)
    lib=load(data)()
    libs_loaded[module]=lib
    return lib
end

executeFile = function(file)
    local fd=disk.open(file)
    data=disk.read(fd, math.huge)
    disk.close(fd)
    return load(data)()()
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
    local data = io.input("/root # ")
    local file="/bin/"..data..".lua"
    if disk.exists(file)==false then
        io.println("[ERROR] '" .. file .. "' not found!" )
    else
        executeFile(file)
    end
end