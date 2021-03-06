%+========================================================================+
%|                                                                        |
%|            This script uses the GYPSILAB toolbox for Matlab            |
%|                                                                        |
%| COPYRIGHT : Matthieu Aussal (c) 2017-2018.                             |
%| PROPERTY  : Centre de Mathematiques Appliquees, Ecole polytechnique,   |
%| route de Saclay, 91128 Palaiseau, France. All rights reserved.         |
%| LICENCE   : This program is free software, distributed in the hope that|
%| it will be useful, but WITHOUT ANY WARRANTY. Natively, you can use,    |
%| redistribute and/or modify it under the terms of the GNU General Public|
%| License, as published by the Free Software Foundation (version 3 or    |
%| later,  http://www.gnu.org/licenses). For private use, dual licencing  |
%| is available, please contact us to activate a "pay for remove" option. |
%| CONTACT   : matthieu.aussal@polytechnique.edu                          |
%|             francois.alouges@polytechnique.edu                         |
%| WEBSITE   : www.cmap.polytechnique.fr/~aussal/gypsilab                 |
%|                                                                        |
%| Please acknowledge the gypsilab toolbox in programs or publications in |
%| which you use it.                                                      |
%|________________________________________________________________________|
%|   '&`   |                                                              |
%|    #    |   FILE       : nrtDomRegularize.m                            |
%|    #    |   VERSION    : 0.40                                          |
%|   _#_   |   AUTHOR(S)  : Matthieu Aussal                               |
%|  ( # )  |   CREATION   : 14.03.2017                                    |
%|  / 0 \  |   LAST MODIF : 14.03.2018                                    |
%| ( === ) |   SYNOPSIS   : Singular kernel regularization (in debug mode)|
%|  `---'  |                                                              |
%+========================================================================+

% Cleaning
clear all
close all
clc

% Library path
addpath('../../openDom')
addpath('../../openFem')
addpath('../../openMsh')

% Parameters
N   = 1e2;
gss = 3;

% Spherical mesh
sphere = mshSphere(N,1);

% Square mesh
square = mshSquare(2*N,[3 3]);

% Graphical representation
figure
plot(sphere)
hold on
plot(square)
axis equal

% Domain
sigma = dom(sphere,gss);    

% Finite elements
u = fem(sphere,'P0');
v = fem(sphere,'P1');
w = fem(sphere,'RWG');

% Gren kernel
Gxy   = @(X,Y) femGreenKernel(X,Y,'[1/r]',[]);
dyGxy = @(X,Y) femGreenKernel(X,Y,'grady[1/r]1',[]);


% Single radiation P0
M  = integral(square.vtx,sigma,Gxy,u);
Mr = regularize(square.vtx,sigma,'[1/r]',u);
norm(M+Mr,'inf')

% Single radiation P1
M  = integral(square.vtx,sigma,Gxy,v);
Mr = regularize(square.vtx,sigma,'[1/r]',v);
norm(M+Mr,'inf')

% Single radiation RWG
M  = integral(square.vtx,sigma,Gxy,div(w));
Mr = regularize(square.vtx,sigma,'[1/r]',div(w));
norm(M+Mr,'inf')


% Single layer P0
M  = integral(sigma,sigma,u,Gxy,u);
Mr = regularize(sigma,sigma,u,'[1/r]',u);
norm(M+Mr,'inf')

% Single layer P1
M  = integral(sigma,sigma,v,Gxy,v);
Mr = regularize(sigma,sigma,v,'[1/r]',v);
norm(M+Mr,'inf')

% Single layer RWG
M  = integral(sigma,sigma,div(w),Gxy,div(w));
Mr = regularize(sigma,sigma,div(w),'[1/r]',div(w));
norm(M+Mr,'inf')


% Double radiation P0
M  = integral(square.vtx,sigma,dyGxy,u);
Mr = regularize(square.vtx,sigma,'grady[1/r]1',u);
norm(M+Mr,'inf')

% Double layer P0
M   = integral(sigma,sigma,u,dyGxy,u);
Mr  = regularize(sigma,sigma,u,'grady[1/r]1',u);
norm(M+Mr,'inf')



disp('~~> Michto gypsilab !')


