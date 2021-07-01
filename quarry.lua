-- pastebin get RKdpa3ws quarry

function FindHole(isFindNewHole)
    local dist = holeWidth

    if isFindNewHole == true then
        if turtle.detectDown() == false then -- if a hole is under the turtle, it will move forward holeWidth
            for i = 1, dist, 1 do
                TForward()
                yDistFromChest = yDistFromChest + 1
            end
            FindHole(true)
        elseif turtle.detectDown() == true then -- if turtle detects a block, it will end the function        
        end

    elseif isFindNewHole == false then -- goes back to original hole
        for i = 1, yDistFromChest, 1 do
            TForward()
        end
    end
end

function GoToXLocation(isFindNewHole)
    local x = holeWidth
    local index = xIndex

    print("moving to position", holeWidth*xIndex, "on the x axis")

    turtle.turnRight()
    for i = 1, x*index, 1 do
        TForward()
    end
    turtle.turnLeft()
    FindHole(isFindNewHole)
end

function GoToHeight()
    startingDigHeight = startHeight - digHeight
    for i = 1, startingDigHeight, 1 do
        TDown()
        totalHeight = totalHeight + 1
    end
end

function uTurnRight()
    turtle.turnRight()
    TForward()
    turtle.turnRight()
end

function uTurnLeft()
    turtle.turnLeft()
    TForward()
    turtle.turnLeft()
end

function DigLevel()
    for i = 1, holeWidth, 1 do        -- executes mining of n x n grid
        for j = 1, holeWidth-1, 1 do
            TForward()
        end

        if i ~= holeWidth then
            if i % 2 ~= 0 then
                uTurnRight()
            elseif i % 2 == 0 then
                uTurnLeft()
            end
        else
        end
    end

    if holeWidth % 2 ~= 0 then
        turtle.turnLeft() -- returns to pos 1,1 in the n x n grid for odd size
        for i = 1, holeWidth-1, 1 do
            TForward()
        end
        turtle.turnLeft()
        for i = 1, holeWidth-1, 1 do
            TForward()
        end
        turtle.turnLeft()
        turtle.turnLeft()
    elseif holeWidth % 2 ==0 then -- returns to pos 1,1 in the n x n grid for even size
        turtle.turnRight()
        for i = 1, holeWidth-1, 1 do
            TForward()
        end
        turtle.turnRight()
    end

    CheckInv()
end

function QuarryToBottom()
    index = digHeight - 2 --calculates how many levels to dig until it hits bedrock
    for i = 1, index, 1 do
        DigLevel()
        TDown()
        totalHeight = totalHeight + 1
    end
end

function CheckInv() -- checks if the inv is full
    if turtle.getItemCount(15) > 0 then
        ReturnToChest(false)
    end
end

function ReturnToChest(isDone)
    for i = 1, totalHeight+1, 1 do
        TUp()
    end

    -- turns turtle from north to south
    turtle.turnRight()
    turtle.turnRight()

    for j = 1, yDistFromChest, 1 do
        TForward()
    end

    turtle.turnRight() -- turns turtle west

    for i = 1, xIndex*holeWidth, 1 do
        TForward()
    end
    turtle.turnRight() -- turns turtle back to north on top of chest

    if isDone == false then -- turtle goes back to mining
        TDown()
        EmptyInv()
        CheckFuelInv()
        GoToXLocation(false) --returns back to the hole
        for i = 1, totalHeight, 1 do -- digs back down to level when inv was full and resumes DigLevel()
            TDown()
        end
    elseif isDone == true then --if true, turtle will stop at the chest (done mining)
        TDown() 
        EmptyInv()
    end
end

function EmptyInv()
    for i = 2, 16, 1 do
        turtle.select(i)
        turtle.dropDown()
    end
end

function TUp()
    CheckFuel()
    local mineCheck = 0
    while turtle.up() == false do
        local success, data = turtle.inspectUp()
        if data.name == "computercraft:turtle_expanded" then
            print("turtle in above")
        elseif data.name ~= "computercraft:turtle_expanded" then
            turtle.digUp()
            turtle.attackUp()
            mineCheck = mineCheck + 1
            if mineCheck >= 15 then
                Stuck()
            end
        end
    end
end

function TDown()
    CheckFuel()
    local mineCheck = 0
    while turtle.down() == false do
        local success, data = turtle.inspectDown()
        if data.name == "computercraft:turtle_expanded" then
            print("turtle in below")
        elseif data.name ~= "computercraft:turtle_expanded" then
            turtle.digDown()
            turtle.attackDown()
            mineCheck = mineCheck + 1
            if mineCheck >= 15 then
                Stuck()
            end
        end
    end
end

function TForward()
    CheckFuel()
    local mineCheck = 0
    while turtle.forward() == false do
        local success, data = turtle.inspect()
        if data.name == "computercraft:turtle_expanded" then
            print("turtle in front")
        elseif data.name ~= "computercraft:turtle_expanded" then
            turtle.dig()
            turtle.attack()
            mineCheck = mineCheck + 1
            if mineCheck >= 15 then
                Stuck()
            end
        end
    end
end

function Stuck()
    print("Miner is stuck")
    CheckFuel()
end

function CheckFuel()
    turtle.select(1)
    if turtle.getFuelLevel() <= 50 then
        turtle.refuel(1)
    end
end

function CheckFuelInv()
    turtle.select(1)
    if turtle.getItemCount() <= 2 then
        --send message to refuel turtle
        local modem
        modem = peripheral.wrap("left")
        modem.transmit(3, 1, "refuel_me")
    end
end

function KillMe()
    local modem
    modem = peripheral.wrap("left")
    modem.transmit(3, 1, "kill_me")
end

xIndex = tonumber(arg[1]) -- REQUIRED; x index 
startHeight = tonumber(arg[2]) -- REQUIRED
digHeight = tonumber(arg[3]) -- dig down to height before quarrying (default is 50)
holeWidth = tonumber(arg[4]) -- default is 8x8
numTurtles = tonumber(arg[5]) -- number of turtles, must be divisible by digDimension

totalHeight = 0
yDistFromChest = 0

if arg[3] == nil then
    print("dig height not supplied, defaulting to quarry at y=50")
    digHeight = 50
end

if arg[4] == nil then
    print("mining dimensions not supplied, defaulting to 8x8 grid")
    holeWidth = 8
end

if arg[5] == nil then
    print("number of turtles was not provided, defaulting to 16 turtles (4x4)")
    numTurtles = 16
end

GoToXLocation(true)
GoToHeight()
QuarryToBottom()
ReturnToChest(true)
KillMe()
