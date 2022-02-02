clear
clc
addpath('C:\Users\Jorge\Desktop\TESIS\01_FUNCTIONS');
addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\RAW\');
P='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\RAW\';
S = dir(fullfile(P,'*.mat'));
S = natsortfiles(S);
FNAME={S.name}.';
if true
    for ifile=1:numel(S)
        disp(ifile)
        fname= FNAME{ifile};
        disp(fname)
        load(fname);
        temp = struct2cell(conv.').'; conv1 = table(temp(:, 1), temp(:, 2), [conv(:).date].',...
            'VariableNames', {'long', 'lati', 'date'});clear temp
        conv1.date=datetime(conv1.date,'ConvertFrom',"datenum","Format","dd-MMM-uuuu HH:mm:ss");
        clear conv;
        lati = cell(size(conv1.lati,1),1);
        long = cell(size(conv1.lati,1),1);
        for i=1:size(conv1.lati,1)
            if all(conv1.lati{i}(:)>=-30) && all(conv1.lati{i}(:)<=45)
                lati{i,1}=conv1.lati{i};
                long{i,1}=conv1.long{i};
                date(i,1)=conv1.date(i);
            end
        end
        
        %Ignore empty cells
        NE=find(~cellfun(@isempty,lati(:,1)));
        LAT(:,1)=lati(NE(:,1),1);
        LON(:,1)=long(NE(:,1),1);
        DAT(:,1)=(date(NE(:,1),1));
        
        %Save as table
        Clean=table(LAT,LON,DAT);
        structpath='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\CLR\';
        structnum=num2str(ifile);
        ext=".mat";
        structname=append(structnum,ext);
        save(fullfile(structpath,structname),'Clean');
        clear Clean LAT LON DAT lati long conv1;
        addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\RAW\');
    end
end
return