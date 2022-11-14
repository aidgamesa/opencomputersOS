import os
import json

scripts_dir="scripts"
git_dir=".git"
bios_dir="bios"
file_save="installer_data.lua"

installer_files=[]
for path, dirs, files in os.walk("."):
	for file in files:
		file_str=path+"/"+file if path!="." else file
		file_str=file_str[2:] if file_str.startswith("./") else file_str
		if file_str.startswith(git_dir) or file_str.startswith(scripts_dir) \
			or file_str.startswith(bios_dir) :
			continue
		installer_files.append(file_str)
lua_data="return {"+", ".join("\"{}\"".format(file) for file in installer_files)+"}\n"
file=open(file_save, "w+")
file.write(lua_data)
file.close()

