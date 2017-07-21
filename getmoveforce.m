function [moveforce] = getmoveforce(h, pos, camerapos, speed)
%GETMOVEFORCE Gets move forces based on keys currently pressed. (not
%lag-friendly; most keys are treated as either pressed or not pressed the whole
%time lagging.
%It might be possible to improve this behavior.
%   This could be split into two functions.
%   Detailed explanation goes here
moveforce = [0 0 0];
moveforces = cell(4,1);
for ind = 1:4
    moveforces{ind} = [0 0 0];
end

nforces = 0;
for key = (1:4).*h.UserData.commands(1:4) %this way, commands that don't need to run will yield key=0, and will be skipped.
    % The move forces for each pressed key will be averaged.
    % This way, up-left moves diagonally.
    % However, this means up-left-right moves up with one-third the force
    % of pure 'up'.
    if key == 1 
        nforces = nforces + 1;
        moveforces{nforces} = [speed 0 0]; 
    end
    if key == 2
        nforces = nforces + 1;
        moveforces{nforces} = [-speed 0 0]; 
    end
    if key == 3
        nforces = nforces + 1;
        moveforces{nforces} = [0 speed 0]; 
    end
    if key == 4
        nforces = nforces + 1;
        moveforces{nforces} = [0 -speed 0];
    end
end

for ind = 1:nforces %with this, no keys pressed --> no movement
   	moveforce = moveforce + moveforces{ind}/nforces;
end
        %apply moveforce in proper direction: 
    %into/out of the screen for up/down
    %screen left/right for leftarrow/rightarrow
    %note that the z-direction of the camera position must be level
    %with the particle to prevent z-direction motion.
    %MTODO: Allow downward force if grappling for a better swinging motion
viewvector = pos(1:2) - camerapos(1:2);
viewvector = viewvector / norm(viewvector);
theta = atan2(viewvector(2),viewvector(1)); %Use atan2 for reliability
moveforce(1:2) = [cos(theta) -sin(theta); sin(theta) cos(theta)] * moveforce(1:2)';

end

