-- pastebin get e39Z34jX startup

fs.copy("disk/startup", "startup")
fs.copy("disk/quarry", "quarry")
shell.run("startup")

local modem = peripheral.wrap("left")
modem.open(3)  -- Open channel 3 so that we can listen on it
print("listening for message in channel 3")
local event, modemSide, senderChannel,
replyChannel, message, senderDistance = os.pullEvent("modem_message")

print(message)

if senderDistance == 1 then
    shell.run(message)
end

