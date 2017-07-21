function keypress(fig_obj, eventDat)
%key press and release functions (optional: these can be moved to separate files).
    setfocus(fig_obj,[]);
    fig_obj.UserData.keyspressed = union(fig_obj.UserData.keyspressed, eventDat.Key);
    fig_obj.UserData.commands = getcommands(fig_obj.UserData.keyspressed);

    %If the spacebar has been pressed, add 1 to the number of presses.
    %(ignore keyboard repeats.)
    if fig_obj.UserData.commands(5) == 1 && fig_obj.UserData.sPrevPressed == false
        fig_obj.UserData.sPrevPressed = true;
        fig_obj.UserData.numSPresses = fig_obj.UserData.numSPresses + 1;
    end
end