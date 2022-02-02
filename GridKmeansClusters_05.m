clear
clc
addpath('C:\Users\Jorge\Desktop\TESIS\01_FUNCTIONS');
addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\POINTS\')
P='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\POINTS\';
S = dir(fullfile(P,'*.mat'));
S = natsortfiles(S);
FNAME={S.name}.';

if true
    for ifile=1:numel(S)
        disp(ifile)
        fname= FNAME{ifile};
        disp(fname)
        load(fname);
        
        %Add grid to adjust clusters
%         lat=[-90:0.75:90]';
%         lon=[0:0.75:359.25];
%         [LAT,LON]=meshgrid(lat,lon);
%         Grd = [LAT(:) LON(:)];
        
        %Loop for each time set
        for i=1: size (LTP.date,1)
            CData = LTP.LatLon{i,1};
            %Cluster using Kmeans, get n clusters
            [idx,C] = kmeans(CData,2500);
            GC=[];
            %             for j=1:size(C,1)
            %                 P=C(j,:);
            %                 D= distance(P(:,1),P(:,2),Grd(:,1),Grd(:,2));
            %                 [a,b]= min(D);
            %                 GC= cat(1,GC,Grd(b,:));
            %             end
            %             CORD{i,1}=(GC);
            CORD{i,1}=(C);
        end
        DAT=LTP.date;
        CTS=table(CORD,DAT);
        structpath='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\CLUSTERS';
        structnum=num2str(ifile);
        ext=".mat";
        structname=append(structnum,ext);
        save(fullfile(structpath,structname),'CTS');
        clear LTP LAT LON lat lon CTS D GC CORD DAT;
        addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\POINTS\');
    end
end
return
