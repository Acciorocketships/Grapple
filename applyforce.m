function [vel,dt,prevtime] = applyforce(force,velocity,prevtime)
    newtime = toc;
    dt = newtime - prevtime;
    prevtime = newtime;
    vel = velocity + force*dt;
end