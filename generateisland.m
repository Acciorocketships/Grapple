function island = generateisland(defaultisland,lastisland,deathz,deathbuffer,skybuffer)
    island = randomize(defaultisland);
    island(1) = island(1) + lastisland(1);
    island(2) = island(2) + lastisland(2);
    island(3) = max(island(3) + lastisland(3),deathz+deathbuffer);
    island(3) = min(island(3),-deathz-skybuffer);
end