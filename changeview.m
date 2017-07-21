function changeview(camerapos,pos,size)
    axis([pos(1)-size pos(1)+size pos(2)-size pos(2)+size -size-1 size])
    campos(camerapos);
    camtarget(pos);
%     direction = lookdirection - camerapos;
%     direction(1) = direction(1) * -1;
%     direction(2) = direction(2) * 0.5;
%     direction(3) = direction(3) * 0.2;
%     view(direction);
%     
end