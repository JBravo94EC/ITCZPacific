% JBravo (10/07/2020)
% -------------------------------------------------------------------------
%
clear
clc
addpath('C:\Users\Jorge\Desktop\TESIS\01_FUNCTIONS')
%
gloswac_path= 'C:\Users\Jorge\Desktop\TESIS\04_DATA\01_ECMWF\GLOSWAC_NUMDEF\';
%
load([gloswac_path,'ECMWF_GAUSSIAN_GRID.mat'],'clat','clon')
%
windir= 'C:\Users\Jorge\Desktop\TESIS\04_DATA\01_ECMWF\MAT\GLOBAL_WIND_HR_C\';
[FNAME,nf]= List_dir(windir);
%
%
if true
    for ifile=1:nf
        disp(ifile)
        %
        fname= FNAME(ifile).name;
        disp(fname)
        load(fname)
        %
        ntimes= size(V10,3);
        [lat,lon]= meshgrid(LAT,LON);
        numb=0;
        %
        for i=1:ntimes
            u = U10(:,:,i);
            v = V10(:,:,i);
            w= sqrt(u.^2+v.^2);
            aa= abs(v)>10; %componente vertical sea mayor a 10m/s
            bb= w>10; %velocidad de viento mayor que 10
            v(aa)= NaN; %Componente  
            v(bb)= NaN;
            %
            A= sign(v);
            % Detect the inversion lines
            A1= A; A1(2:end,:)= A1(2:end,:) + A1(1:end-1,:); A1(1,:)= A1(1,:) + A1(end,:);
            A1= double(A1==0);
            % Buscar el cambio de signo para determinar convergencia
            A2= A; A2(:,2:end)= A2(:,2:end) + A2(:,1:end-1); A2(:,1)= A2(:,1) + A2(:,end,:);
            A2= double(A2==0);
            % A2 es lo mismo para hacer una ponderacion
            A0= A1 + 0.6*A2; % A1 % | A2;
            %
            %pcolor(lon',lat',sign(v));
            %Plot convergence lines
%             pcolor(lon',lat',double(A0));
%             set(get(gca,'Children'),'LineStyle','none')
%             hold on;
%             plot(clon,clat,'.k'); hold on;
%             %
%             title(datestr(wtime(i)))
            
            % Raster to vector, conect lines (only one path)
            B= uint8(A0);
            for ix= 1:size(B,1)
                for jy= 1:size(B,2)
                    bx= ix-1:ix+1; bx(bx<1)= []; bx(bx>size(B,1))= [];
                    by= jy-1:jy+1; by(by<1)= []; by(by>size(B,2))= [];
                    q= B(bx,by);
                    [row,col]= find(q);
                    if ~isempty(row)
                        C= [];
                        pcounter= 1;
                        C(pcounter,1)= ix;
                        C(pcounter,2)= jy;
                        B(ix,jy)= 0;
                        while true
                            ix2= bx(row(1)); % only the first found
                            jy2= by(col(1));
                            pcounter=pcounter+1;
                            C(pcounter,1)= ix2;
                            C(pcounter,2)= jy2;
                            B(ix2,jy2)= 0;
                            bx= ix2-1:ix2+1; bx(bx<1)= []; bx(bx>size(B,1))= [];
                            by= jy2-1:jy2+1; by(by<1)= []; by(by>size(B,1))= [];
                            q= B(bx,by);
                            [row,col]= find(q);
                            if isempty(row)
                               break
                            end
                        end
%                         plot(LON(C(:,2)),LAT(C(:,1)),'.m');
                        numb=numb+1;
                        n=numb;
                            conv(n)=struct('long',LON(C(:,2)),'lati',LAT(C(:,1)),'longM'...
                            ,max(LON(C(:,2))),'longm',min(LON(C(:,2))),'latiM',max(LAT(C(:,1)))...
                            ,'latim',min(LAT(C(:,1))),'date',(wtime(i)));
                        %pause
                    end
                end
            end
%             figpath='C:\Users\Jorge\Desktop\TESIS\Capturas';
%             structnum=num2str(ifile);
%             sep="_"
%             fignum=num2str(i);
%             figname=append(structnum,sep,fignum)
%             set(gcf,'Position',[0 0 1800 850]);
%             saveas(gcf,fullfile(figpath,figname),'jpg');
            addpath('C:\Users\Jorge\Desktop\TESIS\04_DATA\01_ECMWF\MAT\GLOBAL_WIND_HR_C\');
        end
    structpath='C:\Users\Jorge\Desktop\TESIS\05_STRUCTURES\RAW';
    newnum=ifile
    structnum=num2str(newnum);
    ext=".mat";
    structname=append(structnum,ext);
    save(fullfile(structpath,structname),'conv'); 
    clear conv
    addpath('C:\Users\Jorge\Desktop\TESIS\04_DATA\01_ECMWF\MAT\GLOBAL_WIND_HR_C\');
    end
end
return






