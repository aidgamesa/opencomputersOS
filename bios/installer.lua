if component==nil then
	component=require("component")
end
network_component=component.list("internet")()
if network_component==nil then
    error("Network card not found!")
end
network_component=component.proxy(network_component)
if network_component.isHttpEnabled()~=true then
    error("http disabled!")
    return 
end
fs_components=component.list("filesystem")
for address,_ in fs_components do
	if component.proxy(address).getLabel()~="tmpfs" and component.proxy(address).isReadOnly()~=true then
		fs_component=component.proxy(address)
		break
	end
end
base_url="https://raw.githubusercontent.com/aidgamesa/opencomputersOS/main/"
local fileDirectory = function(path)
	return path:match("^(.+%/).") or ""
end
local getData = function(url)
	req=network_component.request(base_url..url)
	while 1 do
		status,err = req.finishConnect()
		if status then
			break
		end
	end
	data=""
	while 1 do
		chunk=req.read(math.huge)
		if chunk then
			data=data..chunk
		else
			break
		end
	end
	return data
end
installer_data=load(getData("installer_data.lua"))()
for i = 1,#installer_data do
	dir=fileDirectory(installer_data[i])
	if fs_component.exists(dir) ~= true then
		fs_component.makeDirectory(dir)
	end
	fd=fs_component.open(installer_data[i], "w")
	fs_component.write(fd, getData(installer_data[i]))
	fs_component.close(fd)
end
eeprom=component.proxy(component.list("eeprom")())
eeprom.set(getData("bios/bios.lua"))
computer.shutdown(true)