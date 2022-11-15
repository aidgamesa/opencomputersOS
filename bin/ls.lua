local io = require('io')
function main() 
    files=disk.list(pwd)
    local msg=""
    for i = 1,#files do
        msg=msg..files[i].."\n"
    end
    io.print(msg)
end
return main