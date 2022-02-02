clear
clc
addpath('D:\OneDrive - Escuela Politécnica Nacional\TESIS JBravo\01_FUNCTIONS');
addpath('D:\OneDrive - Escuela Politécnica Nacional\TESIS JBravo\05_STRUCTURES\CLUSTERS\')
P='D:\OneDrive - Escuela Politécnica Nacional\TESIS JBravo\05_STRUCTURES\CLUSTERS\';
S = dir(fullfile(P,'*.mat'));
S = natsortfiles(S);
FNAME={S.name}.';

if true
    for ifile=1:numel(S)
        disp(ifile)
        fname= FNAME{ifile};
        disp(fname)
        load(fname);
        
        np=1;
        for k=1:size(CTS,1)
            C=CTS.CORD{k,1};
            djoin= 300; % km (Distance to join points)
            
            S= [];
            iline= 0;
            
            while true
                i= find(~isnan(C(:,1)));
                if isempty(i)
                    break
                end
                %
                i= i(1);
                %
                line= C(i,:);
                %iline= iline+1;
                while true
                    lat1= C(i,1);
                    lon1= C(i,2);
                    C(i,:)= NaN;
                    %
                    D= distance(lat1,lon1,C(:,1),C(:,2));
                    D(i)= 999;
                    dkm= deg2km(D);
                    [a,b]= min(dkm);
                    if a < djoin &&  abs(C(b,2)-line(end,2))<300
                        line= cat(1,line,C(b,:));
                        i= b;
                    else
                        iline= iline+1;
                        S(iline).line= line;
                        line=[];
                        break
                    end
                end
            end
            
            L = {S.line}.';
            LINES{k,1}=L;
            for n=1:length(L)
                geoplot(L{n,1}(:,1),L{n,1}(:,2),'LineWidth',2,'Color','b')
                hold on
            end
            title(datestr(CTS.DAT(k)));
            figpath='C:\Users\Jorge\Desktop\TESIS\06_CAPTURAS\GLNS\03\';
            figname=num2str(k);
            geolimits([-40 40],[0 360])
%             set(gcf,'Position',[0 0 1800 850]);
%             geobasemap('colorterrain')
%             saveas(gcf,fullfile(figpath,figname),'jpg');
%             cla
        end
        DATE=CTS.DAT;
        LNS=table(LINES,DATE);
        structpath='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\LINES\';
        structnum=num2str(ifile);
        ext=".mat";
        structname=append(structnum,ext);
        save(fullfile(structpath,structname),'LNS');
        clear CTS LNS LINES line dkm L D C DATE a b;
        addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\CLUSTERS\');
    end
end
return



