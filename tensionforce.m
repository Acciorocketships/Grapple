function force = tensionforce(ropebottom,ropetop,naturallength,springconstant)
    vec = ropetop-ropebottom;
    len = sqrt(norm(vec));
    vec = vec / len;
    mag = len / naturallength * springconstant;
    force = vec * mag;
end