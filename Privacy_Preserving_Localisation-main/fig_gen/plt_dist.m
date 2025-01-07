function plt_dist(fn, x_bnd)
    [xx,yy] = meshgrid(linspace(-x_bnd,x_bnd));


    figure

    surf(fn(xx,yy))
    axis off
    view([-40,45])
    ATprettify
end