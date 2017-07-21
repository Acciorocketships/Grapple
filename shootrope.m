function [pt,dist] = shootrope(pos,vel,islands,maxropedist)
pt = [];
for n = length(islands):-1:1
    [loc, dist] = intersect(pos,islands{n},vel);
    if ~isempty(loc) && dist < maxropedist
        pt = loc;
        return;
    end
end