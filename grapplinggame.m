%instructions
disp('Press the arrow keys to move and the spacebar to shoot the grappling hook.')

% Player
dead = false;
isroping = false;
pos = [0 0 0]; % position, automatically updated
vel = [0 0 0]; % velocity, automatically updated
gravity = [0 0 -20]; % gravity constant
ropeforce = [0 0 0]; % tension force variable
moveforce = [0 0 0]; % player movement force variable
speed = 25;
resolution = 10; % Plotting Resolution
playersize = 1.5; % Size of the Player
[px,py,pz] = sphere(resolution); 
px = playersize*px;
py = playersize*py;
pz = playersize*pz;
maxropedist = 30;
springconstant = 20;

% Air resistance
dampConst = 0.05;

% Camera
stagesize = 100; % distance of the edge of the stage from the center
camerapos = [0 -stagesize/4 0]; % camera position, automatically updated

% Islands
islands = cell(0);
defaultisland = [15 0 0.5 4]; % Default relative x, y, z from player and default size
firstisland = [4 0 0.5 3];
deathbuffer = stagesize / 2; %disallow islands generated below death buffer above the ground
skybuffer = stagesize / 3; %disallow islands fully out of view
nextisland = randomize(firstisland); % variable to store the attributes of the next island

% Extra Initialization

h = figure('KeyPressFcn',@keypress,...
    'KeyReleaseFcn',@keyrelease);
h.UserData.keyspressed = {};
h.UserData.commands = [false, false, false, false, false];
h.UserData.sPrevPressed = false;
h.UserData.numSPresses = 0;
%set(h,'keypressfcn',@setfocus);
set(h,'MenuBar','none');
camproj('perspective');
ax = gca;
ax.Clipping = 'off';
set(h,'units','normalized','position',[0 0 0.8 1]);
plt = surf([],[],[]);
plt.Parent.Position = [-0.25 -0.25 1.5 1.5];
player = surf([],[],[]);
pshadow = plot3([],[],[]);
hrope = surf([],[],[]);
colormap winter;
gameTicLength = 10; % tic length of 10 ms
time = 0;
score = uicontrol('Style', 'text',...
       'String', num2str(pos(1)),...
       'Units','normalized',...
       'ForegroundColor','k',...
       'BackgroundColor','w',...
       'FontSize',20,...
       'Position', [0.9 0.95 0.1 0.05]); 

% Plot ground and ground guideline
hold on;
gx = 1e3*stagesize * [-1 1 1 -1]';
gy = 1e3*stagesize * [-1 -1 1 1]';
gz = -stagesize * [1 1 1 1]';
pol1 = fill3(gx, gy, gz, 'g');
xdir = plot3([min(gx) max(gx)],[mean(gy) mean(gy)],[min(gz) min(gz)],'-k','LineWidth',3);
alpha(pol1, 0.5)
% lighting
light('Position',[0 0 1e7]);
lighting gouraud;
tic;

hold on;
while ~dead       
    %process key input; deal with rope shooting if applicable
    [moveforce] = getmoveforce(h, pos, camerapos, speed);

    %Compute rope shooting forces.    
    nToggles = h.UserData.numSPresses;
    %We want an even positive number of toggles to switch to the next available
    %island if isroping, and to do nothing otherwise.
    %An odd number of toggles will act like 1 toggle.
    %otherwise, regardless of the number of toggles, an island is roped to if possible.
    if nToggles > 0 
        h.UserData.numSPresses = 0;
        [pt,dist] = shootrope(pos,vel,islands,maxropedist);
        if ~isempty(pt)
            disp(isroping);
            disp(nToggles);
            isroping = logical(mod(isroping+nToggles,2));
        else
            isroping = false; 
        end        
    end
    delete(hrope);
    if isroping
        ropeforce = tensionforce(pos,pt,maxropedist/2,springconstant);
    else
        ropeforce = [0 0 0];
    end
    

    % Generate Islands
    changeview(camerapos,pos,stagesize);
    while inwindow(nextisland,camerapos,stagesize)
        hold on;
        % plot nextisland
        [ix,iy,iz] = generatemesh(nextisland,resolution,playersize);
        surf(ix,iy,iz,'FaceAlpha',0.8,'linestyle','none');
        ctheta = linspace(0, 2*pi);
        % plot shadow
        icx = cos(ctheta) * nextisland(4) + nextisland(1);
        icy = sin(ctheta) * nextisland(4) + nextisland(2);
        icz = min(gz) * ones(size(icx)) + 0.01;
        ishadow = fill3(icx,icy,icz,'k','EdgeColor','none');
        alpha(ishadow,0.5);
        %  add nextisland to list
        islands{length(islands)+1} = nextisland;
        % generate new nextisland
        nextisland = generateisland(defaultisland,nextisland,-stagesize,deathbuffer, skybuffer);
    end
    
    % Air resistance
    dampForce = -vel * dampConst;
    % Player Movement, Player Plotting, and Camera
    [vel,dt,time] = applyforce(gravity+ropeforce+moveforce+dampForce,vel,time);
    pos = move(pos,vel,dt);
    camerapos(1) = pos(1) - sin(time/10)*stagesize/5;
	camerapos(2) = pos(2) - cos(time/10)*stagesize/5;
    %camerapos(1) = pos(1) - stagesize/20;
    %camerapos(2) = pos(2) - stagesize/5;
    camerapos(3) = pos(3) + stagesize/5;
    delete(player);
    delete(pshadow);
    player = surf(px+pos(1),py+pos(2),pz+pos(3),'edgecolor','interp','facecolor','r','linestyle','none');
    ctheta = linspace(0, 2*pi);
    pcx = cos(ctheta) * playersize + pos(1);
    pcy = sin(ctheta) * playersize + pos(2);
    pcz = min(gz) * ones(size(pcx)) + 0.02;
    if pos(3) >= -stagesize
        pshadow = fill3(pcx, pcy, pcz,'k','EdgeColor','none');
        alpha(pshadow, 0.6);
    end
    changeview(camerapos,pos,stagesize);
    if(isroping)
        hrope = plot3([pos(1) pt(1)],[pos(2) pt(2)],[pos(3) pt(3)],'-r','LineWidth',3);
    end
    drawnow;
    
    
    % Show Score
    set(score,'String',num2str(pos(1)));
    
    % Check Death
    if pos(3) < -stagesize
        % Added restart Button
        restartButton = uicontrol('Parent', h, 'Style', 'pushbutton', 'String', 'Restart', 'FontWeight', 'bold', ...
                        'Units','normalized','Position', [0.45 0.45 0.1 0.05],'Callback', @resFunction);
        % Added exit Button            
        exitButton = uicontrol('Parent', h, 'Style', 'pushbutton', 'String', 'Exit', 'FontWeight', 'bold', ...
                        'Units','normalized','Position', [0.45 0.35 0.1 0.05],'Callback', @exitFunction);  
        % Added Score Display
         scoreDisp = uicontrol('Parent', h, 'Style', 'pushbutton', 'String', ['You have died.  Score: ', num2str(pos(1))], ...
                        'FontWeight','bold','FontSize',20,'Units','normalized','BackgroundColor','w','Position', [0.35 0.55 0.3 0.03]);
        dead = true;
    end
    
    % Wait for next tick
    if(gameTicLength-dt>0)
        pause(max(gameTicLength-dt,0)/1e3);
    end
end


