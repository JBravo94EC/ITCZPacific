clear
clc
addpath('D:\OneDrive - Escuela Politécnica Nacional\TESIS JBravo\01_FUNCTIONS');
addpath('D:\OneDrive - Escuela Politécnica Nacional\TESIS JBravo\05_STRUCTURES\LINES\')
P='D:\OneDrive - Escuela Politécnica Nacional\TESIS JBravo\05_STRUCTURES\LINES\';
S = dir(fullfile(P,'*.mat'));
S = natsortfiles(S);
FNAME={S.name}.';

if true
    for ifile=1:numel(S)
        disp(ifile)
        fname= FNAME{ifile};
        disp(fname)
        load(fname);
        %Extraer las lineas para cada fecha
        for i=1:size(LNS,1)
            C=LNS.LINES{i,1};
            %Extraer cada linea y analizar sus puntos
            CLINES={};
            for j=1:length(C)
                lin= C{j,1};
                ind=[];
                %Para cada punto identificar si hay cambio de direccion
                for k=2:length(lin)-1
                    if (lin(k-1,2)>= lin(k,2) && lin(k,2)< lin(k+1,2))||((lin(k-1,2)<= lin(k,2) && lin(k,2)> lin(k+1,2)))
                        ind=cat(2,ind,k);
                    end
                end
                geoscatter(lin(ind,1),lin(ind,2),[10],'o','k');
                hold on
                %%Recortar las líneas en los puntos encontrados
                ind=[1,ind,length(lin)]';
                for l=1:length(ind)
                    if  numel(lin)~=2
                        if l+1<length(ind)
                            Clin=lin(ind(l):ind(l+1),:);
                        else
                            Clin=lin(ind(l):ind(end),:);
                        end
                        geoplot(Clin(:,1),Clin(:,2),'LineWidth',2)
                        hold on
                        CLINES=cat(1,CLINES,Clin);
                    end
                end
            end
%             %%Plot de las lineas recortadas
%             title(datestr(LNS.DATE(i)));
%             figpath='C:\Users\Jorge\Desktop\TESIS\06_CAPTURAS\CDIR\03';
%             figname=num2str(i);
%             geolimits([-40 40],[0 360])
%             set(gcf,'Position',[0 0 1800 850]);
%             saveas(gcf,fullfile(figpath,figname),'jpg');
%             cla
            CLNS{i,1}=CLINES;
            DATE=LNS.DATE;
        end
        CL=table(CLNS,DATE);
        structpath='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\SDC\';
        structnum=num2str(ifile);
        ext=".mat";
        structname=append(structnum,ext);
        save(fullfile(structpath,structname),'CL');
        clear CLNS CLINES Clin LNS C;
        addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\LINES\');
    end
end
return

