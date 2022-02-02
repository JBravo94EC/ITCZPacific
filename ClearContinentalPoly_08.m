clear
clc
%%Load data
addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\')
load RPolygons.mat;
addpath('C:\Users\Jorge\Desktop\TESIS\01_FUNCTIONS');
addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\SDC\')
P='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\SDC\';
S = dir(fullfile(P,'*.mat'));
S = natsortfiles(S);
FNAME={S.name}.';

if true
    for ifile=1:numel(S)
        disp(ifile)
        fname= FNAME{ifile};
        disp(fname)
        load(fname);
        
        for i=1:size(CL,1)
            C=CL.CLNS{i,1};
            %% Plot lines
            for k=1:length(C)
                in=inpolygon(C{k,1}(:,2),C{k,1}(:,1),poly(:,2),poly(:,1));
                C{k,1}(in,:)=[];
            end
            idx=cellfun(@isempty,C);
            C=C(~idx,1);
            CL.CLNS{i,1}=C;
        end
        structpath='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\CPLINES\';
        structnum=num2str(ifile);
        ext=".mat";
        structname=append(structnum,ext);
        save(fullfile(structpath,structname),'CL');
    end
end
return
