clear
clf
clc
gloswac_path= 'C:\Users\Jorge\Desktop\TESIS\04_DATA\01_ECMWF\GLOSWAC_NUMDEF\';
load([gloswac_path,'ECMWF_GAUSSIAN_GRID.mat'],'clat','clon')
addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\GCLUSTERS\')
load 1.mat;
plot(clon,clat,'.k'); hold on
C=CTS.CORD {1,1};
scatter(C(:,2),C(:,1),[5],'bo')
axis([200 330 -50 50])
set(gcf,'Position',[0 0 1800 850]);

%% Create polygons array
Lati={};
Long={};

%% Draw a polygon
%hold on
ploth=plot(mean(C(:,1)),mean(C(:,2)),'r');
button=1;
[lon,lat]=deal([]);

while button==1
    %get a new mouse position
    [lont,latt,button]=ginput(1);
    lon=[lon lont];
    lat=[lat latt];
    %update a plot handle
    set(ploth,'XData',lon,'YData',lat)
end
lon=[lon lon(1,1)];
lat=[lat lat(1,1)];
set(ploth,'XData',lon,'YData',lat)

%% Identify the dots inside the polygon 
in=inpolygon(C(:,2),C(:,1),lon,lat);
%A=numel(C(in))
plot(C(in,2),C(in,1),'r*')
poly=[lat' lon'];
%figure 
%geoscatter(C((in==0),1),C((in==0),2))
%set(gcf,'Position',[0 0 1800 850]);
structpath='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\';
structname="RPolygons.mat"
save(fullfile(structpath,structname),'poly'); 
