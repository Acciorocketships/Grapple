function inside = inwindow(island,camerapos,stagesize)
inside = true;
% check x
if island(1) < camerapos(1) || island(1)-island(4) > camerapos(1)+stagesize*2
    inside = false;
% check y
elseif island(2)+island(4) < camerapos(2)-stagesize || island(2)-island(4) > camerapos(2)+stagesize
    inside = false;
% check z
elseif island(3)+island(4) < camerapos(3)-stagesize || island(3)-island(4) > camerapos(3)+stagesize
    inside = false;
end