clear
clc
%%Load data
addpath('D:\OneDrive - Escuela Politécnica Nacional\TESIS JBravo\01_FUNCTIONS');
addpath('D:\OneDrive - Escuela Politécnica Nacional\TESIS JBravo\05_STRUCTURES\CPLINES\')
P='D:\OneDrive - Escuela Politécnica Nacional\TESIS JBravo\05_STRUCTURES\CPLINES\';
S = dir(fullfile(P,'*.mat'));
S = natsortfiles(S);
FNAME={S.name}.';

if true
    for ifile=1:numel(S)
        disp(ifile)
        fname= FNAME{ifile};
        disp(fname)
        load(fname);
        
        IL=[];
        %% Extraer las lineas de cada fecha
        for i=1:size(CL,1)
            L=CL.CLNS{i,1};
            A=[];
            cont=1;
            for j=1:length(L)
                lin= L{j,1};
                %% Establecer la ubicacion de interes de las lineas
                if (any(lin(:,1)>=-10) && any(lin(:,1)<=15))&&(any(lin(:,2)>=240) && any(lin(:,2)<=282))
%                     geoplot(lin(:,1),lin(:,2),'LineWidth',1,'Color','y')
%                     hold on
                    lin= lin((lin(:,2)>=240)&(lin(:,2)<=275),:);
                    lin= lin((lin(:,1)>=-10)&(lin(:,1)<=15),:);
%                     geoplot(lin(:,1),lin(:,2),'LineWidth',2)
%                     hold on
                    A(cont,1)=numel(lin(:,1));
                    A(cont,2)=j;
                    cont=cont+1;
%                 else
%                     geoplot(lin(:,1),lin(:,2),'LineWidth',1,'Color','b')
%                     hold on
                end
            end
            [LL,idx]=max(A(:,1));
            lin= L{A(idx,2),1};
            IL=cat(1,IL,A(idx,2));
%             geoplot(lin(:,1),lin(:,2),'LineWidth',1,'Color','k','Marker','o','MarkerSize',[3])
%              hold on
            %% Guardar Plot
%              title(datestr(CL.DATE(i)));
%              figpath='C:\Users\Jorge\Desktop\TESIS\06_CAPTURAS\IL\06_12';
%              figname=num2str(i);
%              geolimits([-20 20],[180 300])
%             set(gcf,'units','normalized','outerposition',[0 0 1 1])
%             saveas(gcf,fullfile(figpath,figname),'jpg');
%             cla
        end
        IL=array2table(IL);
        DL=[CL,IL];
        DL.Properties.VariableNames = {'LNS','DATE','IBL'};
        structpath='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\IBL\';
        structnum=num2str(ifile);
        ext=".mat";
        structname=append(structnum,ext);
        save(fullfile(structpath,structname),'DL');
        clear CL DL;
    end
end
return