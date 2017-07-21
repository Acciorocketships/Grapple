function command = getinput(fig)

key = double(get(fig,'CurrentCharacter'));

command = [];
if ~isempty(key)
    switch key
        case {30 119} %30 for 'uparrow', 119 for 'w'
            command = 1;
        case {31 115} %31 for 'downarrow', 115 for 's'
            command = 2;
        case {28 97}  %28 for 'leftarrow', 97 for 'a'
            command = 3;
        case {29 100} %29 for 'rightarrow', 100 for 'd'
            command = 4;
        case 32       %spacebar
            command = 5;
    end
end
set(fig,'CurrentCharacter','~');
end