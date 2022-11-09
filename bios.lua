local gpu    = component.proxy(
    component.list("gpu")()
)
local eeprom = component.proxy(
    component.list("eeprom")()
)

local screen_addr = component.list("screen")()

gpu.bind(screen_addr, true)

local width, height = gpu.getResolution()
gpu.fill(1, 1, width, height, " ")

local screen_pos_x = 1
local screen_pos_y = 1

local osBootFile="boot.lua"

local print = function(msg)
    for msg_pos = 1, #msg do
        char=msg:sub(msg_pos,msg_pos)
        if screen_pos_x==width then
            screen_pos_x=1
            screen_pos_y=screen_pos_y+1
        end
        gpu.set(screen_pos_x, screen_pos_y, char)
        screen_pos_x=screen_pos_x+1
    end
end
local println = function(msg)
    print(msg)
    screen_pos_y=screen_pos_y+1
    screen_pos_x=1
end
local crash = function(msg)
    println("[FATAL] " .. msg)
    while 1 do
        computer.pullSignal()
    end
end
local getBootableDisk = function()
    disks=component.list("filesystem")
    for diskAddress in disks do
        disk = component.proxy(diskAddress)
        if disk.getLabel()~="tmpfs" and disk.isReadOnly()==false and
            disk.exists(osBootFile) 
        then
            return disk
        end
    end
    crash("Failed to get bootable disk!")
end
local executeString = function(...)
    local result, err = load(...)
    if result then
        result, err = xpcall(result, debug.traceback)
		if result then
			return
		end
    end
end
println("EEPROM init done!")
local disk=getBootableDisk()
println("Bootable disk found!")
eeprom.setData(disk.address)
print("Reading bootfile... ")
local bootfile_fd=disk.open(osBootFile)
local bootdata=disk.read(bootfile_fd, math.huge)
disk.close(bootfile_fd)
println("DONE")
executeString(bootdata)
crash("Unknown error!")