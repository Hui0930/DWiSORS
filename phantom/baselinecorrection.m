%%% 
%%For ALS basleline and three types of normalization--RG created on Aug2020- 
%%small modification on plots and variable names of normalized spectra by MSN Nov2021
%%---TO SAVE FILES NEED TO CREATE A "NEW FOLDER" INSIDE THE DATA FOLDER
clc;
% clear;

%upload all other files to be normalized
[filenames,datapath]=uigetfile(char({'*.csv;'}),'Select spectral file for shift correction...','MultiSelect','on');
cd(datapath);
if iscell(filenames)==1
filenames=filenames';
else 
filenames={filenames};
end
filecount=length(filenames(:,1));

%directory to save %%create a "New Folder" in the data folder
Dir = ('New folder');

if ~exist(Dir, 'dir')
   mkdir(Dir)
end

% for ii=1:filecount  
%     filename=char(cell2mat(filenames(ii,:)));
% % 	Rspectrum=importdata(filename);
% %     data1= Rspectrum.data;
%     data1=load(filename); 
% 
%     x=data1(:,1);
%     %%% SNR calculation
%         for i=1:900
%             if (x(i)>=885.0) && x(i)<=887.0;
%                  z3_index=i;
%             else if x(i) >= 879 && x(i)<=881;
%                  z1_index=i;
%                 else if x(i)>= 890 && x(i)<=892;
%                     z2_index=i;
%                     end
%                 end
%             end
%         end
%         z1=data1(z1_index,2);
%         z2=data1(z2_index,2);
%         z3=data1(z3_index,2);
%         m=(z1-z2)/(x(z1_index)-x(z2_index));  % slope that lipid peak sits on
%         b=z1-(m*(x(z1_index)));  %y=mx + b, solving for b using the left side of the lipid peak x and y values
%         base=(m*x(z3_index))+b; % solving for the base height (y value) using the previously calculated y intercept and slope
%         signal=z3-base;  % subtracting peak height from base height to determine signal height
%         noise=detrend(data1(820:900,2)); %calculating "noise" from Raman inactive portion of spectrum
%         std_noise=std(noise); %standard deviation of the noise
%         SNR=signal/std_noise; %snr calculation
%         SNR_list(ii,1)=SNR; 
% end
% 
%     SNR_txt=SNR_list;
%     SNR_list=num2cell(SNR_list);
%     SNR_table=[filenames SNR_list];
    
    
%loop to normalize all the uploaded file
for ii=1:filecount  
    filename=char(cell2mat(filenames(ii,:)));
% 	Rspectrum=importdata(filename);
%     data1= Rspectrum.data;
    data1=load(filename); 
    
    %%%find starting and stopping points in vector
    start=550;
    stop=1850;
    newx=data1(:,1);
    newy=data1(:,2);
    x1=find(newx<=start);
    startx=length(x1);
    x2=find(newx>=stop);
    stopx=length(newx)-length(x2);
    nx=newx(startx:stopx); %truncated x values
    ny=newy(startx:stopx); %truncated y values
    data=[nx ny];
    %data= data1;
    specnew=data(:,2);

%     xq=stop:1.2:start;           %%%optinal to make axis same
%     newny=interp1(nx,ny,xq,'Shape-preserving');   
%     data=[xq' newny'];
%     specnew=data(:,2);
%     
%     %%Smoothing or noise reduction ""THIS IS OPTIONAL""   
    SGorder=2; %smoothing order
    SGframe=5; %smoothing window frame
    specnew=sgolayfilt(specnew,SGorder,SGframe);
% %     
    %%% ALS baseline 
    lambda = 60000;  %%%TUNE THE VALUE TO FIT THE BASELINE TO SPECTRA 100000; (dry saliva 6000, 0.001; liq3x10^6,0.003 cell 20000, 0.001 , PCF RHD 0.001 1000, )
    p = 0.001;      % p= 0.0002 renishaw or 0.0005  %%% TUNE THE VALUE TO AVOID -VE VALUE 0.00008 200000       
    specnew1 = baseline(specnew, lambda, p); % <- call the ALSbaseline
    specnew2=specnew(:)-specnew1(:); %subtract the smoothed data from the raw spectrum
    
     %plot output
     figure
     subplot(2,1,1)
     plot(data(:,1),data(:,2),'linewidth',2)
     hold on
     plot(data(:,1),specnew1,'r','linewidth',2) %changed for ALS
    grid on
    set(gca,'FontSize',20,'FontWeight','Bold')
    set(gcf, 'Units','Normalized', 'OuterPosition', [0 0 1 1]);
    xlabel('Wavenumber (cm^-^1)')
    ylabel('Intensity (arb. units)')
    xlim([550 1850])
    box on
     legend('Raw spectrum','ALS fit')
     subplot(2,1,2)
     plot(data(:,1),specnew2,'linewidth',2)
     title('Baseline-subtracted spectrum','interpreter','none');
    grid on
    set(gca,'FontSize',20,'FontWeight','Bold')
    set(gcf, 'Units','Normalized', 'OuterPosition', [0 0 1 1]);
    xlabel('Wavenumber (cm^-^1)')
    ylabel('Intensity (arb. units)')
    xlim([550 1850])
    box on
     subplot(2,1,1)
     title(filename,'interpreter','none')
     
     cd([datapath,'\',Dir])
     savefig=[filename(1:length(filename)-16)];%save the figure generated 
     savefig=char(savefig);
     set(gcf, 'PaperOrientation','landscape','PaperPositionMode' ,'manual', 'PaperPosition', [0.25,0.25,10.50,8.00])
     saveas(gcf,[savefig '.pdf'],'pdf')
     saveas(gcf,[savefig '.fig'],'fig')
     close(gcf)%close figure to prevent runtime error with large file loads
   
%      %%% Mean Normalization
     meany= mean(specnew2);
     %y1(:,1)=specnew2./meany;
     y1=specnew2./meany;
%      %%% Vectornormalization
%  	 y1(:,1)=specnew2./norm(specnew2);
    
%      %%% SNV normalization
%    meany=mean(specnew2);
%    Sdy=std(specnew2);
%    y1(:,1)=(specnew2-meany)./Sdy;
%    min_val = abs(min(y1(:,1)));      %%%select minimum value for the SNV spectrum
% %    y2(:,1) = y1(:,1)+ min_val;       %%%add minimum value to whole spectrum ; to make +ve
%    y(:,1) = y1(:,1)+ min_val;       %%%add minimum value to whole spectrum ; to make +ve
%     
    %%%% normalized data saving
    % datanorm=[data(:,1) y1(:,1)]; 
    datanorm=[data(:,1) y1]; 
   % datanorm2=[data(:,1) y2(:,1)];    %%% only for SNV +ve shifted spectrum
     
cd([datapath,'\',Dir])
name = strrep(filename,'.txt','');
savecor=convertCharsToStrings([name, '_corrected.txt']);
save(savecor,'datanorm','-ascii','-tabs');%% save the correction after normalization

%     savefile = 'SNR_table.mat';
%     save(savefile,'SNR_table','-mat')
%     savefile2= 'SNR_txt.txt';
%     save(savefile2,'SNR_txt','-ascii')

% savecor=convertCharsToStrings([name, '_positive_corrected.txt']);
% save(savecor,'datanorm2','-ascii','-tabs');%% save the correction only for SNV 
end



