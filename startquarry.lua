-- pastebin get f7wDv0Le startquarry

argument1 = tonumber(arg[1]) -- starting height
argument2 = tonumber(arg[2]) -- digging height
argument3 = tonumber(arg[3]) -- quarry size (n^2)
argument4 = tonumber(arg[4]) -- number of turtles (must have a sqrt)
argument5 = tonumber(arg[5]) -- num of x positions

slot = 2
fuel = 4

function PlaceFuel(fuelNum)
    turtle.select(slot) -- placing fuel into turtle
    if turtle.getItemCount() >= fuelNum then
        turtle.drop(fuelNum)
    else
        slot = slot + 1
        if slot > 16 then
        elseif slot <= 16 then
            turtle.select(slot)
            if turtle.getItemCount() >= fuelNum then
                turtle.drop(fuelNum)
            end
        end
    end
end

numTurt = 0
for i = 1, argument4/argument5, 1 do
    for j = 1, argument5, 1 do
        print("placing turtle", numTurt+1) --places down turtle
        turtle.select(1)
        turtle.place()

        PlaceFuel(fuel) -- places fuel into turtle

        peripheral.call('front','turnOn') -- turns turtle on
        os.sleep(1)

        local modem -- sends quarry command to turtle
        modem = peripheral.wrap("left")
        modem.transmit(3, 1, string.format("quarry %d %d %d %d %d", j, argument1, argument2, argument3, argument4))
        print("message sent to turtle", numTurt+1)
        numTurt = numTurt + 1
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
        print("Killing turtle #", killedTurtles)
        turtle.select(1)
        turtle.dig()
        killedTurtles = killedTurtles + 1

        if killedTurtles == argument4 then
            break
        end
    end

    if message == "refuel_me" then
        print("Refueling turtle with 2 fuel")
        PlaceFuel(2)
    end
end
