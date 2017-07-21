function [pt,dist] = intersect(pos,island,vel)
    %idland(1:3): x,y,z coordinates of island
    %idland(4): radius of island
    
    r = island(4);
    direction = island(1:3) - pos;
    dist = abs(norm(direction) - r);
    pt = island(1:3) - direction/norm(direction) * r;
end