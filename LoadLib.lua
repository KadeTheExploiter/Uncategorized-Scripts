function LoadLibrary(a)
local t = {}
local string = string
local math = math
local table = table
local error = error
local tonumber = tonumber
local tostring = tostring
local type = type
local setmetatable = setmetatable
local pairs = pairs
local ipairs = ipairs
local assert = assert

local StringBuilder = {
    buffer = {}
}
 
function StringBuilder:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.buffer = {}
    return o
end
 
function StringBuilder:Append(s)
    self.buffer[#self.buffer+1] = s
end
 
function StringBuilder:ToString()
    return table.concat(self.buffer)
end
 
local JsonWriter = {
    backslashes = {
        ['\b'] = "\\b",
        ['\t'] = "\\t",
        ['\n'] = "\\n",
        ['\f'] = "\\f",
        ['\r'] = "\\r",
        ['"'] = "\\\"",
        ['\\'] = "\\\\",
        ['/'] = "\\/"
    }
}
 
function JsonWriter:New()
    local o = {}
    o.writer = StringBuilder:New()
    setmetatable(o, self)
    self.__index = self
    return o
end
 
function JsonWriter:Append(s)
    self.writer:Append(s)
end
 
function JsonWriter:ToString()
    return self.writer:ToString()
end
 
function JsonWriter:Write(o)
    local t = type(o)

    if t == "nil" then
        self:WriteNil()
    elseif t == "boolean" then
        self:WriteString(o)
    elseif t == "number" then
        self:WriteString(o)
    elseif t == "string" then
        self:ParseString(o)
    elseif t == "table" then
        self:WriteTable(o)
    elseif t == "function" then
        self:WriteFunction(o)
    elseif t == "thread" then
        self:WriteError(o)
    elseif t == "userdata" then
        self:WriteError(o)
    end
end
 
function JsonWriter:WriteNil()
    self:Append("null")
end
 
function JsonWriter:WriteString(o)
    self:Append(tostring(o))
end
 
function JsonWriter:ParseString(s)
    self:Append('"')

    self:Append(string.gsub(s, "[%z%c\\\"/]", function(n)
        local c = self.backslashes[n]

        if c then return c end
        return string.format("\\u%.4X", string.byte(n))
    end))

    self:Append('"')
end
 
function JsonWriter:IsArray(t)
    local count = 0
    local isindex = function(k)
        if type(k) == "number" and k > 0 then
            if math.floor(k) == k then
                return true
            end
        end

        return false
    end

    for k,v in pairs(t) do
        if not isindex(k) then
            return false, '{', '}'
        else
            count = math.max(count, k)
        end
    end

    return true, '[', ']', count
end
 
function JsonWriter:WriteTable(t)
    local ba, st, et, n = self:IsArray(t)
    self:Append(st)

    if ba then
        for i = 1, n do
            self:Write(t[i])

            if i < n then
                self:Append(',')
            end
        end
    else
        local first = true;

        for k, v in pairs(t) do
            if not first then
                self:Append(',')
            end

            first = false;

            self:ParseString(k)
            self:Append(':')
            self:Write(v)
        end
    end

    self:Append(et)
end
 
function JsonWriter:WriteError(o)
    error(string.format("Encoding of %s unsupported", tostring(o)))
end

function JsonWriter:WriteFunction(o)
    if o == Null then
        self:WriteNil()
    else
        self:WriteError(o)
    end
end
 
local StringReader = {
    s = "",
    i = 0
}
 
function StringReader:New(s)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.s = s or o.s
    return o
end
 
function StringReader:Peek()
    local i = self.i + 1

    if i <= #self.s then
        return string.sub(self.s, i, i)
    end

    return nil
end
 
function StringReader:Next()
    self.i = self.i + 1

    if self.i <= #self.s then
        return string.sub(self.s, self.i, self.i)
    end

    return nil
end
 
function StringReader:All()
    return self.s
end
 
local JsonReader = {
    escapes = {
        ['t'] = '\t',
        ['n'] = '\n',
        ['f'] = '\f',
        ['r'] = '\r',
        ['b'] = '\b',
    }
}
 
function JsonReader:New(s)
    local o = {}
    o.reader = StringReader:New(s)
    setmetatable(o, self)
    self.__index = self
    return o;
end
 
function JsonReader:Read()
    self:SkipWhiteSpace()
    local peek = self:Peek()

    if peek == nil then
        error(string.format("Nil string: '%s'", self:All()))
    elseif peek == '{' then
        return self:ReadObject()
    elseif peek == '[' then
        return self:ReadArray()
    elseif peek == '"' then
        return self:ReadString()
    elseif string.find(peek, "[%+%-%d]") then
        return self:ReadNumber()
    elseif peek == 't' then
        return self:ReadTrue()
    elseif peek == 'f' then
        return self:ReadFalse()
    elseif peek == 'n' then
        return self:ReadNull()
    elseif peek == '/' then
        self:ReadComment()
        return self:Read()
    else
        return nil
    end
end
 
function JsonReader:ReadTrue()
    self:TestReservedWord{'t', 'r', 'u', 'e'}
    return true
end
 
function JsonReader:ReadFalse()
    self:TestReservedWord{'f', 'a', 'l', 's', 'e'}
    return false
end
 
function JsonReader:ReadNull()
    self:TestReservedWord{'n', 'u', 'l', 'l'}
    return nil
end
 
function JsonReader:TestReservedWord(t)
    for i, v in ipairs(t) do
        if self:Next() ~= v then
            error(string.format("Error reading '%s': %s", table.concat(t), self:All()))
        end
    end
end
 
function JsonReader:ReadNumber()
    local result = self:Next()
    local peek = self:Peek()

    while peek ~= nil and string.find(peek, "[%+%-%d%.eE]") do
        result = result .. self:Next()
        peek = self:Peek()
    end

    result = tonumber(result)

    if result == nil then
        error(string.format("Invalid number: '%s'", result))
    else
        return result
    end
end
 
function JsonReader:ReadString()
    local result = ""
    assert(self:Next() == '"')

    while self:Peek() ~= '"' do
        local ch = self:Next()

        if ch == '\\' then
            ch = self:Next()

            if self.escapes[ch] then
                ch = self.escapes[ch]
            end
        end

        result = result .. ch
    end

    assert(self:Next() == '"')

    local fromunicode = function(m)
        return string.char(tonumber(m, 16))
    end

    return string.gsub(result, "u%x%x(%x%x)", fromunicode)
end
 
function JsonReader:ReadComment()
    assert(self:Next() == '/')
    local second = self:Next()

    if second == '/' then
        self:ReadSingleLineComment()
    elseif second == '*' then
        self:ReadBlockComment()
    else
        error(string.format("Invalid comment: %s", self:All()))
    end
end
 
function JsonReader:ReadBlockComment()
    local done = false

    while not done do
        local ch = self:Next()

        if ch == '*' and self:Peek() == '/' then
            done = true
        end

        if not done and ch == '/' and self:Peek() == "*" then
            error(string.format("Invalid comment: %s, '/*' illegal.", self:All()))
        end
    end

    self:Next()
end
 
function JsonReader:ReadSingleLineComment()
    local ch = self:Next()

    while ch ~= '\r' and ch ~= '\n' do
        ch = self:Next()
    end
end
 
function JsonReader:ReadArray()
    local result = {}
    assert(self:Next() == '[')

    local done = false

    if self:Peek() == ']' then
        done = true;
    end

    while not done do
        local item = self:Read()
        result[#result+1] = item
        self:SkipWhiteSpace()

        if self:Peek() == ']' then
            done = true
        end

        if not done then
            local ch = self:Next()

            if ch ~= ',' then
                error(string.format("Invalid array: '%s' due to: '%s'", self:All(), ch))
            end
        end
    end

    assert(']' == self:Next())
    return result
end
 
function JsonReader:ReadObject()
    local result = {}
    assert(self:Next() == '{')

    local done = false

    if self:Peek() == '}' then
        done = true
    end

    while not done do
        local key = self:Read()

        if type(key) ~= "string" then
            error(string.format("Invalid non-string object key: %s", key))
        end

        self:SkipWhiteSpace()
        local ch = self:Next()

        if ch ~= ':' then
            error(string.format("Invalid object: '%s' due to: '%s'", self:All(), ch))
        end

        self:SkipWhiteSpace()

        local val = self:Read()
        result[key] = val

        self:SkipWhiteSpace()

        if self:Peek() == '}' then
            done = true
        end

        if not done then
            ch = self:Next()

            if ch ~= ',' then
                error(string.format("Invalid array: '%s' near: '%s'", self:All(), ch))
            end
        end
    end

    assert(self:Next() == "}")
    return result
end
 
function JsonReader:SkipWhiteSpace()
    local p = self:Peek()
    while p ~= nil and string.find(p, "[%s/]") do
        if p == '/' then
            self:ReadComment()
        else
            self:Next()
        end

        p = self:Peek()
    end
end
function JsonReader:Peek()
    return self.reader:Peek()
end
function JsonReader:Next()
    return self.reader:Next()
end
function JsonReader:All()
    return self.reader:All()
end
function Encode(o)
    local writer = JsonWriter:New()
    writer:Write(o)
    return writer:ToString()
end
function Decode(s)
    local reader = JsonReader:New(s)
    return reader:Read()
end
function Null()
    return Null
end
t.DecodeJSON = function(jsonString)
pcall(function() warn("RbxUtility.DecodeJSON is deprecated, please use Game:GetService('HttpService'):JSONDecode() instead.") end)
if type(jsonString) == "string" then
    return Decode(jsonString)
end
print("RbxUtil.DecodeJSON expects string argument!")
return nil
end
t.EncodeJSON = function(jsonTable)
    pcall(function() warn("RbxUtility.EncodeJSON is deprecated, please use Game:GetService('HttpService'):JSONEncode() instead.") end)
    return Encode(jsonTable)
end
t.MakeWedge = function(x, y, z, defaultmaterial)
    return game:GetService("Terrain"):AutoWedgeCell(x, y, z)
end
t.SelectTerrainRegion = function(regionToSelect, color, selectEmptyCells, selectionParent)
    local terrain = game:GetService("Workspace"):FindFirstChild("Terrain")
    if not terrain then return end
    assert(regionToSelect)
    assert(color)
    if not type(regionToSelect) == "Region3" then
        error("regionToSelect (first arg), should be of type Region3, but is type", type(regionToSelect))
    end
    if not type(color) == "BrickColor" then
        error("color (second arg), should be of type BrickColor, but is type", type(color))
    end
    local GetCell = terrain.GetCell
    local WorldToCellPreferSolid = terrain.WorldToCellPreferSolid
    local CellCenterToWorld = terrain.CellCenterToWorld
    local emptyMaterial = Enum.CellMaterial.Empty
    local selectionContainer = Instance.new("Model")
    selectionContainer.Name = "SelectionContainer"
    selectionContainer.Archivable = false
    if selectionParent then
        selectionContainer.Parent = selectionParent
    else
        selectionContainer.Parent = game:GetService("Workspace")
    end
    local updateSelection = nil -- function we return to allow user to update selection
    local currentKeepAliveTag = nil -- a tag that determines whether adorns should be destroyed
    local aliveCounter = 0 -- helper for currentKeepAliveTag
    local lastRegion = nil -- used to stop updates that do nothing
    local adornments = {} -- contains all adornments
    local reusableAdorns = {}
    local selectionPart = Instance.new("Part")
    selectionPart.Name = "SelectionPart"
    selectionPart.Transparency = 1
    selectionPart.Anchored = true
    selectionPart.Locked = true
    selectionPart.CanCollide = false
    selectionPart.Size = Vector3.new(4.2, 4.2, 4.2)
    local selectionBox = Instance.new("SelectionBox")
    local function Region3ToRegion3int16(region3)
        local theLowVec = region3.CFrame.p - (region3.Size/2) + Vector3.new(2, 2, 2)
        local lowCell = WorldToCellPreferSolid(terrain,theLowVec)
        local theHighVec = region3.CFrame.p + (region3.Size/2) - Vector3.new(2, 2, 2)
        local highCell = WorldToCellPreferSolid(terrain, theHighVec)
        local highIntVec = Vector3int16.new(highCell.x, highCell.y, highCell.z)
        local lowIntVec = Vector3int16.new(lowCell.x, lowCell.y, lowCell.z)
        return Region3int16.new(lowIntVec, highIntVec)
    end
    function createAdornment(theColor)
        local selectionPartClone = nil
        local selectionBoxClone = nil
        if #reusableAdorns > 0 then
            selectionPartClone = reusableAdorns[1]["part"]
            selectionBoxClone = reusableAdorns[1]["box"]
            table.remove(reusableAdorns,1)
             
            selectionBoxClone.Visible = true
        else
            selectionPartClone = selectionPart:Clone()
            selectionPartClone.Archivable = false
             
            selectionBoxClone = selectionBox:Clone()
            selectionBoxClone.Archivable = false
             
            selectionBoxClone.Adornee = selectionPartClone
            selectionBoxClone.Parent = selectionContainer
             
            selectionBoxClone.Adornee = selectionPartClone
             
            selectionBoxClone.Parent = selectionContainer
        end
        if theColor then
            selectionBoxClone.Color = theColor
        end
        return selectionPartClone, selectionBoxClone
    end
    function cleanUpAdornments()
        for cellPos, adornTable in pairs(adornments) do
            if adornTable.KeepAlive ~= currentKeepAliveTag then -- old news, we should get rid of this
                adornTable.SelectionBox.Visible = false
                table.insert(reusableAdorns, {part = adornTable.SelectionPart, box = adornTable.SelectionBox})
                adornments[cellPos] = nil
            end
        end
    end
    function incrementAliveCounter()
        aliveCounter = aliveCounter + 1
        if aliveCounter > 1000000 then
            aliveCounter = 0
        end
        return aliveCounter
    end
    function adornFullCellsInRegion(region, color)
        local regionBegin = region.CFrame.p - (region.Size/2) + Vector3.new(2, 2, 2)
        local regionEnd = region.CFrame.p + (region.Size/2) - Vector3.new(2, 2, 2)
        local cellPosBegin = WorldToCellPreferSolid(terrain, regionBegin)
        local cellPosEnd = WorldToCellPreferSolid(terrain, regionEnd)
        currentKeepAliveTag = incrementAliveCounter()
        for y = cellPosBegin.y, cellPosEnd.y do
            for z = cellPosBegin.z, cellPosEnd.z do
                for x = cellPosBegin.x, cellPosEnd.x do
                    local cellMaterial = GetCell(terrain, x, y, z)
                    if cellMaterial ~= emptyMaterial then
                        local cframePos = CellCenterToWorld(terrain, x, y, z)
                        local cellPos = Vector3int16.new(x,y,z)
                        local updated = false
                        for cellPosAdorn, adornTable in pairs(adornments) do
                            if cellPosAdorn == cellPos then
                                adornTable.KeepAlive = currentKeepAliveTag
                            if color then
                                adornTable.SelectionBox.Color = color
                            end
                            updated = true
                            break
                        end
                    end
                    if not updated then
                        local selectionPart, selectionBox = createAdornment(color)
                        selectionPart.Size = Vector3.new(4, 4, 4)
                        selectionPart.CFrame = CFrame.new(cframePos)
                        local adornTable = {SelectionPart = selectionPart, SelectionBox = selectionBox, KeepAlive = currentKeepAliveTag}
                        adornments[cellPos] = adornTable
                    end
                end
            end
        end
    end
cleanUpAdornments()
end
lastRegion = regionToSelect
if selectEmptyCells then
    local selectionPart, selectionBox = createAdornment(color)
    selectionPart.Size = regionToSelect.Size
    selectionPart.CFrame = regionToSelect.CFrame
    adornments.SelectionPart = selectionPart
    adornments.SelectionBox = selectionBox
    updateSelection = function (newRegion, color)
        if newRegion and newRegion ~= lastRegion then
            lastRegion = newRegion
            selectionPart.Size = newRegion.Size
            selectionPart.CFrame = newRegion.CFrame
        end

        if color then
            selectionBox.Color = color
        end
    end
else
    adornFullCellsInRegion(regionToSelect, color)
    updateSelection = function (newRegion, color)
        if newRegion and newRegion ~= lastRegion then
            lastRegion = newRegion
            adornFullCellsInRegion(newRegion, color)
        end
    end
end
local destroyFunc = function()
    updateSelection = nil
    if selectionContainer then selectionContainer:Destroy() end
        adornments = nil
    end
    return updateSelection, destroyFunc
end
function t.CreateSignal()
    local this = {}
    local mBindableEvent = Instance.new('BindableEvent')
    local mAllCns = {}
    function this:connect(func)
        if self ~= this then error("connect must be called with `:`, not `.`", 2) end
        if type(func) ~= 'function' then
            error("Argument #1 of connect must be a function, got a "..type(func), 2)
        end
        local cn = mBindableEvent.Event:Connect(func)
        mAllCns[cn] = true
        local pubCn = {}
        function pubCn:disconnect()
            cn:Disconnect()
            mAllCns[cn] = nil
        end
        pubCn.Disconnect = pubCn.disconnect
        return pubCn
    end
    function this:disconnect()
        if self ~= this then error("disconnect must be called with `:`, not `.`", 2) end
        for cn, _ in pairs(mAllCns) do
            cn:Disconnect()
            mAllCns[cn] = nil
        end
    end
    function this:wait()
        if self ~= this then error("wait must be called with `:`, not `.`", 2) end
        return mBindableEvent.Event:Wait()
    end
    function this:fire(...)
        if self ~= this then error("fire must be called with `:`, not `.`", 2) end
        mBindableEvent:Fire(...)
    end
    this.Connect = this.connect
    this.Disconnect = this.disconnect
    this.Wait = this.wait
    this.Fire = this.fire
    return this
end
local function Create_PrivImpl(objectType)
    if type(objectType) ~= 'string' then
        error("Argument of Create must be a string", 2)
    end
    return function(dat)
        dat = dat or {}
        local obj = Instance.new(objectType)
        local parent = nil
        local ctor = nil
        for k, v in pairs(dat) do
            if type(k) == 'string' then
                if k == 'Parent' then
                    parent = v
                else
                    obj[k] = v
                end
            elseif type(k) == 'number' then
                if type(v) ~= 'userdata' then
                    error("Bad entry in Create body: Numeric keys must be paired with children, got a: "..type(v), 2)
                end
                v.Parent = obj
            elseif type(k) == 'table' and k.__eventname then
                if type(v) ~= 'function' then
                    error("Bad entry in Create body: Key `[Create.E\'"..k.__eventname.."\']` must have a function value\
                        got: "..tostring(v), 2)
                end
                obj[k.__eventname]:connect(v)
            elseif k == t.Create then
                if type(v) ~= 'function' then
                    error("Bad entry in Create body: Key `[Create]` should be paired with a constructor function, \
                        got: "..tostring(v), 2)
                elseif ctor then
                    error("Bad entry in Create body: Only one constructor function is allowed", 2)
                end

                ctor = v
            else
                error("Bad entry ("..tostring(k).." => "..tostring(v)..") in Create body", 2)
            end
        end
        if ctor then
            ctor(obj)
        end

        if parent then
            obj.Parent = parent
        end
        return obj
    end
end
t.Create = setmetatable({}, {__call = function(tb, ...) return Create_PrivImpl(...) end})
t.Create.E = function(eventName)
    return {__eventname = eventName}
end
t.Help =
function(funcNameOrFunc)
if funcNameOrFunc == "DecodeJSON" or funcNameOrFunc == t.DecodeJSON then
return "Function DecodeJSON. "
end
if funcNameOrFunc == "EncodeJSON" or funcNameOrFunc == t.EncodeJSON then
return "Function EncodeJSON. "
end
if funcNameOrFunc == "MakeWedge" or funcNameOrFunc == t.MakeWedge then
return "Function MakeWedge. " 
end
if funcNameOrFunc == "SelectTerrainRegion" or funcNameOrFunc == t.SelectTerrainRegion then
return "Function SelectTerrainRegion. " 
end
if funcNameOrFunc == "CreateSignal" or funcNameOrFunc == t.CreateSignal then
return "Function CreateSignal. "
end
if funcNameOrFunc == "Signal:connect" then
return "Method Signal:connect. "
end
if funcNameOrFunc == "Signal:wait" then
return "Method Signal:wait. "
end
if funcNameOrFunc == "Signal:fire" then
return "Method Signal:fire. "
end
if funcNameOrFunc == "Signal:disconnect" then
return "Method Signal:disconnect. "
end
if funcNameOrFunc == "Create" then
return "Function Create. "
end
end
return t
end
