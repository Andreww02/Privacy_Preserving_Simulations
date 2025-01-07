function img = ATplot(X, Y, Linespec)

    if nargin < 3
        Linespec = "";
    end
    plot(X, Y, Linespec);
end