function [pt,dist] = intersect2 (pos,island,direction)
    direction = direction / norm(direction);
    dist = [];
    a = (dot(direction, (pos - island(1:3)))).^2 - norm(pos - island(1:3)) - island(4)^2;
    if a < 0
        pt = [];
        return
    end
    dist1 = -dot(direction,(pos - island(1:3))) + sqrt(a);
    dist2 = -dot(direction,(pos - island(1:3))) - sqrt(a);
    dist = min(dist1,dist2);
    pt = pos + direction * dist;
    if dist < 0
        pt = [];
        dist = [];
    end
end