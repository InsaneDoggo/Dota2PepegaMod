function OnButtonDebugClicked(eventData) {
    // $.Msg("OnButtonDebugClicked ", eventData);

    var data = { "FunctionNameToCall" : eventData, };
    GameEvents.SendCustomGameEventToServer( "debug_dev_menu_button_clicked", data );
}

// event:  { { callbackFunctionName: "SomeFun", label: "SomeText" }, {...} }
function OnSetupUI(event) {
	//  $.Msg("OnSetupUI: ", event);
    
    var menuRoot = $('#DebugMenuClassID');
    menuRoot.RemoveAndDeleteChildren();
    
    Object.values(event).forEach(item => {
        // $.Msg("Item: ", item)

        // callback name is unique so we can use it as ID
        var buttonId = item.callbackFunctionName

        var button = $.CreatePanel('TextButton', menuRoot, buttonId);
        button.AddClass('DefaultValveButtonClass');
        button.text = item.label;
        button.SetPanelEvent('onactivate', (function(BtnId) {
            return function() { OnButtonDebugClicked(BtnId) };
        })(item.callbackFunctionName));
    });
}


(function() {
    $.Msg("dev_debug_menu.js");

    GameEvents.Subscribe( "debug_dev_menu_setup_ui", OnSetupUI);

    // Players.GetPlayerHeroEntityIndex( integer iPlayerID )
    GameEvents.SendCustomGameEventToServer( "debug_dev_menu_request_for_sync", { "playerId": Game.GetLocalPlayerID() } );
})();