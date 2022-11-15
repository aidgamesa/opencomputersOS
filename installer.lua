io.write("Install opencomputersOS? [y/n] ")
a=""
while a~="y" and a~="n" do
    a=io.read(1)
end
if a=="n" then
    print("Canceling...")
    return
end
if component==nil then
	component=require("component")
end
network_component=component.list("internet")()
if network_component==nil then
    print("Network card not found!")
    return 
end
network_component=component.proxy(network_component)
if network_component.isHttpEnabled()~=true then
    print("http disabled!")
    return 
end
fs_components=component.list("filesystem")
for address,_ in fs_components do
	if component.proxy(address).getLabel()~="tmpfs" and component.proxy(address).isReadOnly()~=true then
		fs_component=component.proxy(address)
		break
	end
end
print("Installing...")
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
		os.sleep(0.05)
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
	print("Installing '"..installer_data[i].."'...")
	dir=fileDirectory(installer_data[i])
	if fs_component.exists(dir) ~= true then
		fs_component.makeDirectory(dir)
	end
	fd=fs_component.open(installer_data[i], "w")
	fs_component.write(fd, getData(installer_data[i]))
	fs_component.close(fd)
end
print("Flashing EEPROM...")
eeprom=component.proxy(component.list("eeprom")())
eeprom.set(getData("bios/bios.lua"))