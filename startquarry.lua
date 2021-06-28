-- pastebin get f7wDv0Le startquarry

argument1 = tonumber(arg[1]) -- starting height
argument2 = tonumber(arg[2]) -- digging height
argument3 = tonumber(arg[3]) -- quarry size (n^2)
argument4 = tonumber(arg[4]) -- number of turtles (must have a sqrt)
argument5 = tonumber(arg[5]) -- num of x positions

slot = 2
fuel = 4

function PlaceFuel()
    turtle.select(slot) -- placing fuel into turtle
    if turtle.getItemCount() >= fuel then
        turtle.drop(fuel)
    else
        slot = slot + 1
        turtle.select(slot)
        if turtle.getItemCount() >= fuel then
            turtle.drop(fuel)
        end
    end
end

for i = 1, argument4/argument5, 1 do
    for j = 1, argument5, 1 do
        print("placing turtle", i*j) --places down turtle
        turtle.select(1)
        turtle.place()

        PlaceFuel() -- places fuel into turtle

        peripheral.call('front','turnOn') -- turns turtle on
        os.sleep(1)

        local modem -- sends quarry command to turtle
        modem = peripheral.wrap("left")
        modem.transmit(3, 1, string.format("quarry %d %d %d %d %d", j, argument1, argument2, argument3, argument4))
        print(j, argument1, argument2, argument3, argument4, argument5)
        print("message sent")
        os.sleep(4)
    end
end

killedTurtles = 0
while true do
    local modem = peripheral.wrap("left")
    modem.open(3)  -- Open channel 3 so that we can listen on it
    print("listening for message in channel 3")
    local event, modemSide, senderChannel,
    replyChannel, message, senderDistance = os.pullEvent("modem_message")

    if message == "kill_me" then
        turtle.select(1)
        turtle.dig()
        killedTurtles = killedTurtles + 1

        if killedTurtles == argument4 then
            break
        end
    end

    if message == "refuel_me" then
        PlaceFuel()
    end
end
