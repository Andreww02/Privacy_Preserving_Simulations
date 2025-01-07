# estimate the volume of the space of possible images

__author__ = "Adam Taras"

import sympy
import numpy as np
import matplotlib.pyplot as plt


plt.style.use('dark_background')

# define values
r = sympy.symbols('r', positive=True) # the radius in integral
r_0 = sympy.symbols('r_0', positive=True) # the max radius for n=1
r_max = sympy.symbols('r_max', positive=True) # the max radius in dim n
n = sympy.symbols('n', positive=True, integer=True) # the number of pixels

# some things to keep eqn neater
pi = sympy.pi
log10 = lambda x : sympy.log(x,10)
sqrt = sympy.sqrt
exp = sympy.exp

# the gaussian distribution
rho = sympy.exp(-0.5*r**2)/sympy.sqrt((2*sympy.pi)**n)



# consider just the integral part without any multipliers to make sure it is calculating 
int_V = sympy.integrate(rho*r**(n-1),(r,0, r_max))
int_V_fn = sympy.lambdify(n, int_V.subs(r_max, 1*sqrt(n)), 'mpmath')

nVals = np.round(np.linspace(3,1000,10))
int_V_vals = np.zeros_like(nVals)

for nIdx in range(len(nVals)):
    int_V_vals[nIdx] = float(int_V_fn(nVals[nIdx]))

plt.figure()
plt.plot(nVals, np.log10(int_V_vals))
plt.xlabel('N')
plt.ylabel('Integral part of V')
plt.show()


# the full V expression
V = log10(2*pi**(n/2)/sympy.gamma(n/2)) + log10(sympy.integrate(rho*r**(n-1), (r, 0, r_max)))

plt.figure()

# take your pick of r_0 values
r_0s = [0.6,0.8,1,1.2]
r_0s = np.linspace(1-0.05, 1+0.05,6)

for r_0val in r_0s:
    V_fn = sympy.lambdify(n, V.subs(r_max, r_0val*sqrt(n)), 'mpmath')
    
    
    nVals = np.round(np.linspace(3,10000,50))
    V_vals = np.zeros_like(nVals)
    
    for nIdx in range(len(nVals)):
        V_vals[nIdx] = float(V_fn(nVals[nIdx]))
    
    plt.plot(nVals,V_vals, label=f'r_0 = {r_0val}')
    
plt.xlabel('Dimension N')
plt.ylabel('log10(V)')
plt.legend()
plt.savefig('Vwide.pdf')
plt.ylim([-1,0])
plt.savefig('Vzoomed.pdf')
plt.show()



# now number of images

plt.figure()
r_0s = np.linspace(1-0.5, 1+0.05,6)
plt.plot(nVals,8*nVals*np.log10(2), label=f'Brute Force')

for r_0val in r_0s:
    V_fn = sympy.lambdify(n, V.subs(r_max, r_0val*sqrt(n)), 'mpmath')
    
    
    nVals = np.round(np.linspace(3,10000,50))
    V_vals = np.zeros_like(nVals)
    
    for nIdx in range(len(nVals)):
        V_vals[nIdx] = float(V_fn(nVals[nIdx]))
        
    plt.plot(nVals,8*nVals*np.log10(2) + V_vals, label=f'r_0 = {r_0val}')

plt.xlabel('Dimension N')
plt.ylabel('log10(Number of images)')

plt.legend()
plt.savefig('nImgs.svg')


