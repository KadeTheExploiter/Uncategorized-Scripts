local Global = getfenv(2)
local FakeCoreGuiEnv = game:FindFirstChildOfClass("CoreGui"):FindFirstChild("CoreScriptLocalization")
local VirtualInputManager = Instance.new("VirtualInputManager")
local HttpService = game:GetService("HttpService")

Global.getgenv = Global

loadstring = Global.load_string or loadstring -- A fix for celery (saw someone talk about it)
Global.loadstring = loadstring

local nilinstances = {}
game.DescendantRemoving:Connect(function(Descendant)
	nilinstances[#nilinstances+1]=Descendant	
end)

game.DescendantAdded:Connect(function(Descendant)
	if table.find(nilinstances, Descendant) then
		nilinstances[Descendant] = nil
	end
end)

Global.getexecutorname = function() -- kade
    return "Incognito"
end

Global.isnetworkowner = function(Part) -- kade 
    return Part.ReceiveAge == 0
end

Global.gethui = function(Part) -- kade 
    return FakeCoreGuiEnv
end

Global.getinstances = function() -- kade 
    local x = {}
    for i,v in pairs(game:GetDescendants()) do
        if v:IsA("Instance") then
            x[#x+1]=v
        end
    end
    return x
end

Global.getnilinstances = function() -- kade 
    return nilinstances
end

Global.getscripts = function() 
    local x = {}
    local returned = {}

    local getins, getnilins = getinstances(),getnilinstances() 
    for i,v in next, getins do
        table.insert(x, v)
    end
    for i,v in next, getnilins do
        table.insert(x, v)
    end

    for i,v in pairs(x) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") or v:IsA("Script") then
            returned[#returned+1]=v
        end
    end

    return returned
end

Global.fireclickdetector = function(ClickDetector) -- pio
    if typeof(ClickDetector) ~= "ClickDetector" then
        return
    end

    local Parent = ClickDetector.Parent
    if (not Parent) or Parent and typeof(Parent) ~= "Part" then
        return
    end

    local CameraCalc = workspace.CurrentCamera:WorldToViewportPoint(ClickDetector.Parent.Position)

    VirtualInputManager:SendMouseButtonEvent(res.X, res.Y, 0, true, game, 1)
    VirtualInputManager:SendMouseButtonEvent(res.X, res.Y, 0, false, game, 1)
end

Global.request = function(Options) -- kade
    local Response, Success = nil, nil
    HttpService:RequestInternal(Options):Start(function(Success, Res)  -- thanks len1781
        task.delay(3, function()
            Success = true
        end)

        Response = Res and Res or true
    end)

    
    repeat task.wait() until Response ~= nil

    if typeof(Response) == "boolean" then
        error("Request() timed out.")
        return
    end

    return Response
end

Global.mouse1down = function() -- jxsh
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 1)
end

Global.mouse1up = function() -- jxsh
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 1)
end

Global.mouse1click = function() -- jxsh
    mouse1down()
    mouse1up()
end

Global.keypress = function(key) -- jxsh
    VirtualInputManager:SendKeyEvent(true, key, false, game)
end

Global.keyrelease = function(key) -- jxsh
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end
