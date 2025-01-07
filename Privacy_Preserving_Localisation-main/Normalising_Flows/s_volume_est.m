clear
clc
close all


syms r n rho(r) r_max

assume(n, 'integer')
assume(r_max, 'positive')

rho(r) = exp(-0.5*r^2)/sqrt((2*pi)^n);

V = int(rho(r)*r^(n-1), 0, r_max);


%% vary n

nVals = round(logspace(0,3,5));
r_max_val = 1;

figure
hold on
r_max_vals = [1,1.5,1.7];
for rIdx = 1:length(r_max_vals)
    r_max_val = r_max_vals(rIdx);
    for nIdx = 1:length(nVals)
        V_vals(nIdx) = vpa(subs(V, [n, r_max], [nVals(nIdx), r_max_val]),5);
    end
    ATplot(nVals, V_vals);
    leg(rIdx) = sprintf("r = %.2f", r_max_val);
end
set(gca, 'yscale','log', 'xscale','log')
xlabel('Dimension')
ylabel('Enclosed Probability density')
legend(leg)
ATprettify

%%

r_max_vals = linspace(0.1,2,10);
V_vals = [];

figure
hold on
n_vals = [30, 28*28];
for nIdx = 1:length(n_vals)
    n_val = n_vals(nIdx);
    for rIdx = 1:length(r_max_vals)
        V_vals(rIdx) = vpa(subs(V, [n, r_max], [n_val, r_max_vals(rIdx)]),5);
    end
    ATplot(r_max_vals, log10(V_vals));
    leg(nIdx) = sprintf("n = %d", n_val);
end
set(gca, 'xscale','log')
xlabel('r')
ylabel('log10(Enclosed probability density)')
legend(leg)
ATprettify


%% how it varies with number of images that need to be checked


nVals = round(logspace(0,3,5));
r_max_val = 1;
V_vals = [];

figure
hold on
r_max_vals = [1,1.5,1.7];
for rIdx = 1:length(r_max_vals)
    r_max_val = r_max_vals(rIdx);
    for nIdx = 1:length(nVals)
        % im part is an artefact
        V_vals(nIdx) = real(vpa(subs(V, [n, r_max], [nVals(nIdx), r_max_val]),5));
    end
    ATplot(nVals, 8*nVals*log10(2) + log10(V_vals));
    leg(rIdx) = sprintf("r = %.2f", r_max_val);
end
% set(gca, 'xscale','log')
xlabel('Dimension')
ylabel('log10(Number of images)')
legend(leg)
ATprettify


%% compare to not using NF


figure
hold on

nVals = round(logspace(0,3,5));
r_max_val = 1.5;
V_vals = [];

for nIdx = 1:length(nVals)
    % im part is an artefact
    V_vals(nIdx) = real(vpa(subs(V, [n, r_max], [nVals(nIdx), r_max_val]),5));
end
ATplot(nVals, 8*nVals*log10(2) + log10(V_vals));
ATplot(nVals, 8*nVals*log10(2))
xlabel('Dimension')
ylabel('log10(Number of images)')
legend(["With NF","Brute Force"])
ATprettify



