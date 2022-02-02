clear
clc
addpath('C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\CSR\')
load 12.mat;
addpath('C:\Users\Jorge\Desktop\TESIS\06_CAPTURAS\CSR\12_12\');
%temp = struct2cell(conv.').'; conv1 = table(temp(:, 1), temp(:, 2), [conv(:).longM].', [conv(:).longm].',...
    %[conv(:).latiM].', [conv(:).latim].', [conv(:).date].',...
    %'VariableNames', {'long', 'lati', 'longM', 'longm', 'latiM', 'latim', 'date'});clear temp
%conv1.date=datetime(conv1.date,'ConvertFrom',"datenum","Format","dd-MMM-uuuu HH:mm:ss");
dates=groupsummary(Clean,"date");
counts=1;
%clear conv;
for i=1:size (dates.date,1)
    countf=counts+dates.GroupCount(i);
    for k=counts:countf
       geoplot(Clean.lati{k,:},Clean.long{k,:},'LineWidth',1.5,'Color',[.6 0 0])
       geolimits([-40 40],[0 360])
       set(gcf,'Position',[0 0 1800 850])
       geobasemap('colorterrain')
       hold on 
    end
    title(datestr(dates.date(i)));
    counts=counts+dates.GroupCount(i);
    figpath='C:\Users\Jorge\Desktop\TESIS\06_CAPTURAS\CSR\12_12\';
    %structnum=datestr(dates.date(i));
    structnum=num2str(i);
    figname=append(structnum);
    %set(gcf,'Position',[0 0 1800 850]);
    saveas(gcf,fullfile(figpath,figname),'jpg');
        cla
end
        
 