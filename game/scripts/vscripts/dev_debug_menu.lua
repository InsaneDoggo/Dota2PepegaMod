
if not DevDebugMenu then
    DevDebugMenu = class({})
else
    -- Script Is Reloading
    print("[DevDebugMenu] Script Is Reloading. Sync Panorama")
    -- One Frame delay to let GetDebugButtonNames() be updated
    Timers:CreateTimer(function()
        -- Sync Panorama UI in case if Buttons were changed
        DevDebugMenu:InitUIForAll()
    end)
end

function DevDebugMenu:Init()
    DebugPrint("[DevDebugMenu] Init")
    print("[DevDebugMenu] Init")

    CustomGameEventManager:RegisterListener("debug_dev_menu_button_clicked", Dynamic_Wrap(DevDebugMenu, "OnDebugButtonClickedEvent"))
    CustomGameEventManager:RegisterListener("debug_dev_menu_request_for_sync", Dynamic_Wrap(DevDebugMenu, "OnRequestForSync"))
end

function DevDebugMenu:OnRequestForSync(event)
    local player = PlayerResource:GetPlayer(event.playerId)
    DevDebugMenu:InitUIForPlayer(player)
end

function DevDebugMenu:InitUIForAll()
    print("[DevDebugMenu] InitUIForAll")
    CustomGameEventManager:Send_ServerToAllClients("debug_dev_menu_setup_ui", DevDebugMenu:GetDebugButtonNames())
end

function DevDebugMenu:InitUIForPlayer(player)
    print("[DevDebugMenu] InitUIForPlayer ")
    CustomGameEventManager:Send_ServerToPlayer(player, "debug_dev_menu_setup_ui", DevDebugMenu:GetDebugButtonNames())
end

-- event: { "FunctionNameToCall" : "SomeText" }
function DevDebugMenu:OnDebugButtonClickedEvent(event)
    if DevDebugMenu[event.FunctionNameToCall] then
        -- Find function by name and call it
        DevDebugMenu[event.FunctionNameToCall]()
    else
        print('OnDebugButtonClickedEvent Unknown FunctionNameToCall: ' .. event.FunctionNameToCall)
    end
end


function DevDebugMenu:GetDebuButtonLabelByFunctionName(functionName)
    local names = DevDebugMenu:GetDebugButtonNames()
    
    for _,v in pairs(names) do
        if (v.callbackFunctionName == functionName) then
            return v.label
        end
    end

    return 'Undefined'
end



-- ================================ Debug Actions ========================================
function DevDebugMenu:GetDebugButtonNames()
    return {
        { callbackFunctionName = "OnClickReloadButton", label = "Clear; Reload" },
        { callbackFunctionName = "OnClickDebugButton1", label = "Test 1" },
        { callbackFunctionName = "OnClickDebugButton2", label = "Test 2" },
        { callbackFunctionName = "OnClickDebugButton3", label = "Test 3" },
        { callbackFunctionName = "OnClickDebugButton4", label = "Test 4" },
        { callbackFunctionName = "OnClickDebugButton5", label = "Test 5" }
    }
end

function DevDebugMenu:OnClickReloadButton()
    print(DevDebugMenu:GetDebuButtonLabelByFunctionName('OnClickReloadButton'))

    SendToServerConsole('clear;script_reload')
end

function DevDebugMenu:OnClickDebugButton1()
    print(DevDebugMenu:GetDebuButtonLabelByFunctionName('OnClickDebugButton1'))
    
    
end

function DevDebugMenu:OnClickDebugButton2()
    print(DevDebugMenu:GetDebuButtonLabelByFunctionName('OnClickDebugButton2'))
    
    
end

function DevDebugMenu:OnClickDebugButton3()
    print(DevDebugMenu:GetDebuButtonLabelByFunctionName('OnClickDebugButton3'))

    -- PlayerResource:SetCustomTeamAssignment( 1, DOTA_TEAM_BADGUYS )
end

function DevDebugMenu:OnClickDebugButton4()
    print(DevDebugMenu:GetDebuButtonLabelByFunctionName('OnClickDebugButton4'))

    local player = PlayerResource:GetPlayer(0)
    local hero = player:GetAssignedHero()
    
    print('Hello world!')
end

function DevDebugMenu:OnClickDebugButton5()
    print(DevDebugMenu:GetDebuButtonLabelByFunctionName('OnClickDebugButton5'))

    local player = PlayerResource:GetPlayer(0)
    local hero = player:GetAssignedHero()
    -- local ability = hero:GetAbilityByIndex(0)
end


-- ======================================= Utils ===============================================
function DevDebugMenu:DemoHttpRequest()
	print("Start DemoHttpRequest")

    -- url - just random open api that returns small JSON response
    -- you can open it in a browser (e.g. chrome) to see expected result
    local url = "https://jsonplaceholder.typicode.com/todos/1"
	-- Google: "REST API methods"
    local method = "GET"

    local requestHandle = CreateHTTPRequest(method, url)
    -- headers contains additional information about the request/response
    -- more info: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers
	requestHandle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
	
    local timeStartMS = GetSystemTimeMS()
    -- callback. see description of "Send" function below.
	local callbackFunction = function(response)
        local timeSpentMS = GetSystemTimeMS() - timeStartMS
        print("Http Response: " .. response.StatusCode)		
        -- Google: List of HTTP status codes
        -- 2xx - success
        -- 4xx - client errors
        -- 5xx - server errors
        if response.StatusCode == 200 then
			print(response.Body)
		end

        print(string.format("[Debug] Time Spent: %.2f ms", timeSpentMS))
	end
    
    -- Send is asynchronous i.e. it needs time for data(packets) to reach server
    -- and return back to client. When we(engine) recevie response, function, that we had put 
    -- as a parameter into requestHandle:Send() will be called.
    requestHandle:Send(callbackFunction)
end