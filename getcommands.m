function commands = getcommands(keys)
%GETCOMMAND gets array of commands mapped to cell array of keys pressed
%   Detailed explanation goes here
    %commandDescription = {'up','down','left','right','grappleToggle'}
    commands = [false, false, false, false, false];
    for key = keys
        command = getcommand(key{:});
        if ~isempty(command)
            commands(command) = true;
        end
    end
end

function command = getcommand(key)
%GETCOMMAND gets command mapped to key
%   Detailed explanation goes here
command = [];
if ~isempty(key)
    switch key
        case {'uparrow', 'w'}      %30 for 'uparrow', 119 for 'w'
            command = 1;
        case {'downarrow', 's'}  %31 for 'downarrow', 115 for 's'
            command = 2;
        case {'leftarrow', 'a'}  %28 for 'leftarrow', 97 for 'a'
            command = 3;
        case {'rightarrow', 'd'} %29 for 'rightarrow', 100 for 'd'
            command = 4;
        case 'space'             %spacebar
            command = 5;
    end
end
end

