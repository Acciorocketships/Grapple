function pt = shootrope(pos,vel,islands,maxropedist)
pt = [];
for n = 1:length(islands)
    for lr = [0,-pi/12,pi/12,-pi/6,pi/6]
        for ud = linspace(0,pi/2,10)
            direction = vel([1 3]);
            rotmat = [cos(lr) sin(lr); -sin(lr) cos(lr)];
            direction = [direction*rotmat sqrt(norm(direction))*tan(ud)];
            [loc, dist] = intersect(pos,islands{n},direction);
            if ~isempty(loc) && dist < maxropedist
                pt = loc;
                return;
            end
        end
    end
end
end