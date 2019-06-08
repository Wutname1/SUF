local parent, ns = ...
local SUF = ns.SUF
local Private = SUF.Private

local argcheck = Private.argcheck

local queue = {}
local factory = CreateFrame('Frame')
factory:SetScript('OnEvent', function(self, event, ...)
	return self[event](self, event, ...)
end)

factory:RegisterEvent('PLAYER_LOGIN')
factory.active = true

function factory:PLAYER_LOGIN()
	if(not self.active) then return end

	for _, func in next, queue do
		func(SUF)
	end

	-- Avoid creating dupes.
	wipe(queue)
end

--[[ Factory: SUF:Factory(func)
Used to call a function directly if the current character is logged in and the factory is active. Else the function is
queued up to be executed at a later time (upon PLAYER_LOGIN by default).

* self - the global SUF object
* func - function to be executed or delayed (function)
--]]
function SUF:Factory(func)
	argcheck(func, 2, 'function')

	-- Call the function directly if we're active and logged in.
	if(IsLoggedIn() and factory.active) then
		return func(self)
	else
		table.insert(queue, func)
	end
end

--[[ Factory: SUF:EnableFactory()
Used to enable the factory.

* self - the global SUF object
--]]
function SUF:EnableFactory()
	factory.active = true
end

--[[ Factory: SUF:DisableFactory()
Used to disable the factory.

* self - the global SUF object
--]]
function SUF:DisableFactory()
	factory.active = nil
end

--[[ Factory: SUF:RunFactoryQueue()
Used to try to execute queued up functions. The current player must be logged in and the factory must be active for
this to succeed.

* self - the global SUF object
--]]
function SUF:RunFactoryQueue()
	factory:PLAYER_LOGIN()
end
