io.write("Install opencomputersOS? [y/n] ")
a=""
while a~="y" and a~="n" do
    a=io.read(1)
end
if a=="n" then
    print("Canceling...")
end
--TODO: normal functional
print("Installing...")
print(":)")