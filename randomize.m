function y = randomize(x)
    factor = norm(x) / 2.5;
    y = normrnd(x,factor);
    if length(y) == 4
        y(4) = max(abs(y(4)),3);
    end
end