function [ix,iy,iz] = generatemesh(island,resolution,playersize)
    [ix,iy,iz] = sphere(round(island(4)/playersize * resolution));
    ix = ix * island(4) + island(1);
    iy = iy * island(4) + island(2);
    iz = iz * island(4) + island(3);
end
