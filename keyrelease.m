function keyrelease(fig_obj, eventDat)
    fig_obj.UserData.keyspressed = setdiff(fig_obj.UserData.keyspressed, eventDat.Key);
    fig_obj.UserData.commands = getcommands(fig_obj.UserData.keyspressed);
    if fig_obj.UserData.commands(5) == 0
        fig_obj.UserData.sPrevPressed = false;
    end
end