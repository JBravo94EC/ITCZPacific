clear
clc
addpath('C:\Users\Jorge\Desktop\TESIS\01_FUNCTIONS');
addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\CLR\')
P='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\CLR\';
S = dir(fullfile(P,'*.mat'));
S = natsortfiles(S);
FNAME={S.name}.';
if true
    for ifile=1:numel(S)
        disp(ifile)
        fname= FNAME{ifile};
        disp(fname)
        load(fname);
        %Group by date to have independent arrays of latitude and longitude
        dates=groupsummary(Clean,"DAT");
        counts=1;
        lati=[];
        long=[];
        for i=1:size (dates.DAT,1)
            countf=counts+dates.GroupCount(i)-1;
            for k=counts:countf
                lati=cat(1,lati,Clean.LAT{k}(:));
                long=cat(1,long,Clean.LON{k}(:));
            end
        LatLon{i,1}=[lati long];
        lati=[];
        long=[];
        date(i,1)=dates.DAT(i);
        counts=counts+dates.GroupCount(i);
        end
        LTP=table(LatLon,date);
        structpath='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\POINTS\';
        structnum=num2str(ifile);
        ext=".mat";
        structname=append(structnum,ext);
        save(fullfile(structpath,structname),'LTP');
        clear Clean lati long LatLon date;
        addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\CLR\');
    end
end
return