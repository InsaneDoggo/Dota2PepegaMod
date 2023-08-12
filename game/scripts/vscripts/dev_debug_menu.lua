
if not DevDebugMenu then
    DevDebugMenu = class({})
else
    -- Script Is Reloading
    print("[DevDebugMenu] Script Is Reloading. Sync Panorama")
    -- Sync Panorama UI in case if Buttons were changed    
    DevDebugMenu:InitUIForAll()
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

-- ================================ Debug Actions ========================================
function DevDebugMenu:GetDebugButtonNames()
    return {
        { callbackFunctionName = "OnClickDebugButton1", label = "Do X" },
        { callbackFunctionName = "OnClickDebugButton2", label = "Do Y" },
        { callbackFunctionName = "OnClickDebugButton3", label = "Pepega" }
    }
end

function DevDebugMenu:OnClickDebugButton1()
    print("On Click Debug Button 1")
end

function DevDebugMenu:OnClickDebugButton2()
    print("On Click Debug Button 2")
end

function DevDebugMenu:OnClickDebugButton3()
    print("On Click Debug Button 3")
end