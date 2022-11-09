local gpu    = component.proxy(
    component.list("gpu")()
)

local screen_addr = component.list("screen")()

gpu.bind(screen_addr, true)


local width, height = gpu.getResolution()
-- Clear screen
gpu.fill(1, 1, width, height, " ")

while 1 do
    gpu.set(1, 1, "Hello, world!")
end