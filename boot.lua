local gpu    = component.proxy(
    component.list("gpu")()
)

local screen_addr = component.list("screen")()

gpu.bind(screen_addr, true)

gpu.set(16, 16, "Read bootfile work!")