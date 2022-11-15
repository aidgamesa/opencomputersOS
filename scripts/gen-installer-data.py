import os
import json

def multi_startswith(data, starts):
	return True in [data.startswith(i) for i in starts]

file_save="installer_data.lua"
starts=["scripts", ".git", "bios", "installer.lua", file_save]

installer_files=[]
for path, dirs, files in os.walk("."):
	for file in files:
		file_str=path+"/"+file if path!="." else file
		file_str=file_str[2:] if file_str.startswith("./") else file_str
		if multi_startswith(file_str, starts):
			continue
		installer_files.append(file_str)
lua_data="return {\n\t"+",\n\t".join("\"{}\"".format(file) for file in installer_files)+"\n}"
file=open(file_save, "w+")
file.write(lua_data)
file.close()

