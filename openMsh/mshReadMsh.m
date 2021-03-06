function [vtx,elt] = mshReadMsh(filename)
%+========================================================================+
%|                                                                        |
%|                 OPENMSH - LIBRARY FOR MESH MANAGEMENT                  |
%|           openMsh is part of the GYPSILAB toolbox for Matlab           |
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
%| WEBSITE   : www.cmap.polytechnique.fr/~aussal/gypsilab                 |
%|                                                                        |
%| Please acknowledge the gypsilab toolbox in programs or publications in |
%| which you use it.                                                      |
%|________________________________________________________________________|
%|   '&`   |                                                              |
%|    #    |   FILE       : mshReadMsh.m                                  |
%|    #    |   VERSION    : 0.40                                          |
%|   _#_   |   AUTHOR(S)  : Matthieu Aussal                               |
%|  ( # )  |   CREATION   : 14.03.2017                                    |
%|  / 0 \  |   LAST MODIF : 14.03.2018                                    |
%| ( === ) |   SYNOPSIS   : Read .msh files (triangular and tetrahedral)  |
%|  `---'  |                                                              |
%+========================================================================+

% Ouverture
fid = fopen(filename,'r');
if( fid==-1 )
    error('Can''t open the file.');
    return;
end

% En-tete -> Table des noeuds
str = fgets(fid);
while isempty(strfind(str,'Nodes'))
    str = fgets(fid);
end

% Tabe des noeuds
Nvtx = str2double(fgets(fid));
vtx  = zeros(Nvtx,3);
for i = 1:Nvtx
    tmp = str2num(fgets(fid));
    vtx(i,:) = tmp(2:4);
end

% Fin table des noeuds
str = fgets(fid);
if isempty(strfind(str,'Nodes'))
    error('error reading vertex');
    return
end

% Table des noeuds -> Table des elements
str = fgets(fid);
while isempty(strfind(str,'Elements'))
    str = fgets(fid);
end

% Tabe des elements (4 vertex max)
Nelt = str2double(fgets(fid));
elt  = zeros(Nelt,4);
for i = 1:Nelt
    tmp = str2num(fgets(fid));
    if tmp(2) == 2
        elt(i,1:3) = tmp(6:8);
    elseif tmp(2) == 4
        elt(i,1:4) = tmp(6:9);
    else
        error('meshReadMsh.m : unsupporting elements')
    end
end

% Uniformisation
if (sum(elt(:,4))==0)
    elt = elt(:,1:3);
else
    elt = elt(elt(:,4)>0,:);
end

% Fin table des noeuds
str = fgets(fid);
if isempty(strfind(str,'Elements'))
    error('error reading elements');
    return
end

% Fermeture fichier
fclose(fid);
return