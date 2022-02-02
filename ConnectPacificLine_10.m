clear
clc
%%Load data
addpath('D:\OneDrive - Escuela Politécnica Nacional\TESIS JBravo\01_FUNCTIONS');
addpath('D:\OneDrive - Escuela Politécnica Nacional\TESIS JBravo\05_STRUCTURES\IBL\')
P='D:\OneDrive - Escuela Politécnica Nacional\TESIS JBravo\05_STRUCTURES\IBL\';
S = dir(fullfile(P,'*.mat'));
S = natsortfiles(S);
FNAME={S.name}.';
%% Load data and set parameter
if true
    for ifile=1:numel(S)
        disp(ifile)
        fname= FNAME{ifile};
        disp(fname)
        load(fname);
        mdis=275; %minimun distance to connect
        pdis=800; %distance to find a new line
        
        %% Loop to operate on each timeframe
        for i=1:size(DL,1)
            %extract lines
            L=DL.LNS{i,1};
            %extract base line and reorganize
            ibl=DL.IBL(i,1);
            BL=L{ibl,1};
            BL=unique(BL,'rows');
            BL=sortrows(BL,[2 1],{'ascend' 'ascend'});
            %erase first base line from set of lines
            L(ibl,:)=[];
            DL.LNS{i,1}(ibl,:)=[];
            %Filter lines for Pacific range
            FL={};
            for j=1:length(L)
                if all(L{j,1}(:,2)>=180)&& all(L{j,1}(:,2)<=282)...
                        && all(L{j,1}(:,1)<=15)&& all(L{j,1}(:,1)>=-15)
                    NL=(L{j,1});
                    FL=cat(1,FL,NL);
                end
            end
            
            PL = cell2table(FL,'VariableNames',{'LNS'});
            
            %% Loop to conect lines
            cont=0;
            PLs={};
            while true
                
                %Clean the range of the base line
                if isempty(PLs)
                    RE=BL(end,2);
                    LE=BL(1,2);
                else
                    RefP=[];
                    for z=1:size(PLs,1)
                        RPL=PLs{z,1}(end,2);
                        LPL=PLs{z,1}(1,2);
                        Ref=[LPL RPL];
                        RefP=cat(1,RefP,Ref);
                    end
                    RPmax=max(RefP(:,2));
                    LPmin=min(RefP(:,1));
                    RBL=BL(end,2);
                    LBL=BL(1,2);
                    RE=max(RBL,RPmax);
                    LE=min(LBL,LPmin);
                end
                eraseid=[];
                for l=1:size(PL,1)
                    Lin=PL.LNS{l,1};
                    Lin=Lin((Lin(:,2)<=LE)|(Lin(:,2)>=RE),:);
                    PL.LNS{l,1}=Lin;
                    %Erase lines completely inside BL Range
                    if all(PL.LNS{l,1}(:,2)>=LE) && all(PL.LNS{l,1}(:,2)<=RE)
                        eraseid=cat(1,eraseid,l);
                    end
                end
                PL(eraseid,:) = [];
                
                %Add atribute of extreme points to each lines
                for k=1:size(PL,1)
                    [Rex,Ridx]=max(PL.LNS{k,1}(:,2));
                    [Lex,Lidx]=min(PL.LNS{k,1}(:,2));
                    PL.LEx(k,:)=PL.LNS{k,1}(Lidx,:);
                    PL.REx(k,:)=PL.LNS{k,1}(Ridx,:);
                end
                
                %Calculate euclidean distance between line and extremes of rest of
                %the lines
                dr=distance(BL(end,1),BL(end,2),PL.LEx(:,1),PL.LEx(:,2));
                dl=distance(BL(1,1),BL(1,2),PL.REx(:,1),PL.REx(:,2));
                [drm,rmidx]=min(dr);
                [dlm,lmidx]=min(dl);
                dmin=min(drm,dlm);
                
                if isempty(dmin)
                    cont=cont+1;
                    PLs{cont,1}=BL;
                    DL.PL{i,1}=PLs;
                    PLs={};
                    break
                end
                
                %Conditional to check which path is shorter
                if dmin==drm
                    midx=rmidx;
                else
                    midx=lmidx;
                end
                dmin=deg2km(dmin);
                
                %Conditional to check distance condition
                if dmin<mdis && (PL.LEx(rmidx,2)>=BL(end,2)||PL.REx(lmidx,2)<=BL(1,2))
                    BL=cat(1,BL,PL.LNS{midx,1});
                    BL=unique(BL,'rows');
                    BL=sortrows(BL,[2 1],{'ascend' 'ascend'});
                    PL(midx,:)=[];
                elseif dmin>mdis && dmin<pdis
                    cont=cont+1;
                    PLs{cont,1}=BL;
                    DL.PL{i,1}=PLs;
                    BL=PL.LNS{midx,1};
                else
                    cont=cont+1;
                    PLs{cont,1}=BL;
                    DL.PL{i,1}=PLs;
                    PLs={};
                    break
                end
                
            end
            
            %Plot pacific lines
            for m=1:size(DL.PL{i,1},1)
                geoplot(DL.PL{i,1}{m,1}(:,1),DL.PL{i,1}{m,1}(:,2),'LineWidth',2,'Color','b')
                hold on
            end
            title(datestr(DL.DATE(i)));
            figpath='C:\Users\Jorge\Desktop\TESIS\06_CAPTURAS\PL\';
            figname=num2str(i);
            geolimits([-20 20],[180 300])
            geobasemap 'bluegreen'
            set(gcf,'units','normalized','outerposition',[0 0 1 1])
            saveas(gcf,fullfile(figpath,figname),'png');
            cla;
            
        end
        DL.IBL = [];
        %Save file
        structpath='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\FPLINES\';
        structnum=num2str(ifile);
        ext=".mat";
        structname=append(structnum,ext);
        save(fullfile(structpath,structname),'DL');
%         clear DL;
%         addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\IBL\');
    end
end
return