offset = [3 5 7 9 11 13];
thickness = [1 2 3 5 6 7 8 10];

for i = 1 : length(offset)
    for j = 1 : length(thickness)
        file_name = sprintf('%dmmring%dmmtop.txt', offset(i), thickness(j));
        spectra = load(file_name);
        spectra_data(:,:,i,j) = spectra;
        file_name_raw = sprintf('%dmmring%dmmtop_r.txt', offset(i), thickness(j));
        spectra_raw = load(file_name_raw);
        spectra_data_raw(:,:,i,j) = spectra_raw;
    end
end


%% bottom peak at pixel 209
peakbottom=zeros(size(spectra_data,3),size(spectra_data,4));
peakbottom_raw=zeros(size(spectra_data_raw,3),size(spectra_data_raw,4));
stdbottom=zeros(size(spectra_data,3),size(spectra_data,4));

for i = 1 : length(offset)
    for j = 1 : length(thickness)
        peakbottom(i,j)=mean(spectra_data(206:218,2,i,j)); %204-214
        peakbottom_raw(i,j)=mean(spectra_data_raw(304:310,2,i,j)); %305:309
        stdbottom(i,j)=mean(spectra_data(206:218,3,i,j));
        stdbottom_raw(i,j) = mean(spectra_data_raw(305:310,3,i,j));
    end
end

bottom_baseline = peakbottom_raw - peakbottom;
bottom_ratio = peakbottom_raw./peakbottom;

figure;
for j = 1 : length(thickness)

    str='thickness'+string(thickness(j))
    plot(offset,peakbottom(:,j),'DisplayName',str,'LineWidth',2)
    hold on
end
xlabel('sds','FontSize',20,'FontWeight','bold')
ylabel('Bottom Intensity','FontSize',20,'FontWeight','bold')

figure;
for j = 1 : length(thickness)
    str='thickness'+string(thickness(j));
    plot(offset,peakbottom(:,j)./peakbottom(1,j),'DisplayName',str,'LineWidth',2)
    hold on
end
xlabel('sds','FontSize',20,'FontWeight','bold')
ylabel('Bottom Intensity normalised','FontSize',20,'FontWeight','bold')

%% top peak at pixel 51 63
peaktop1=zeros(size(spectra_data,3),size(spectra_data,4));
peaktop2=zeros(size(spectra_data,3),size(spectra_data,4));

for i = 1 : length(offset)
    for j = 1 : length(thickness)
        peaktop1(i,j)=mean(spectra_data(48:54,2,i,j)); %49:53
        peaktop2(i,j)=mean(spectra_data(60:64,2,i,j)); %61:65
    end
end
% 
% 
%% enhancement cv

cvbottom = stdbottom./peakbottom;
cvbottom_raw = stdbottom_raw./peakbottom;
enhancement = peakbottom./peaktop1;

ENR = enhancement./cvbottom;
ENR_raw = enhancement./cvbottom_raw;
% figure;
% for j = 1 : length(thickness)
% 
%     str='thickness'+string(thickness(j))
%     plot(offset,enhancement(:,j)./min(enhancement(:,j)),'DisplayName',str,'LineWidth',2)
%     hold on
% end
% xlabel('sds','FontSize',20,'FontWeight','bold')
% ylabel('ENR','FontSize',20,'FontWeight','bold')
% 
figure;
for j = 1 : length(thickness)
    % ENR_n(:,j)=ENR_m(:,j)./max(ENR_m(:,j));
    str='thickness'+string(thickness(j))
    plot(offset,ENR(:,j)./max(ENR(:,j)),'DisplayName',str,'LineWidth',2)
    hold on
end
xlabel('sds','FontSize',20,'FontWeight','bold')
ylabel('ENR','FontSize',20,'FontWeight','bold')

%%
figure;
for j = 1 : length(thickness)
    % ENR_n(:,j)=ENR_m(:,j)./max(ENR_m(:,j));
    str='thickness'+string(thickness(j))
    plot(offset,ENR_raw(:,j)./max(ENR_raw(:,j)),'DisplayName',str,'LineWidth',2)
    hold on
end
xlabel('sds','FontSize',20,'FontWeight','bold')
ylabel('ENR raw','FontSize',20,'FontWeight','bold')
% 
% %%
% figure;
% for j = 1 : length(thickness)
% 
%     str='thickness'+string(thickness(j))
%     plot(offset,peaktop1(:,j),'DisplayName',str,'LineWidth',2)
%     hold on
% end
% xlabel('sds','FontSize',20,'FontWeight','bold')
% ylabel('Top Intensity','FontSize',20,'FontWeight','bold')
% 
% figure;
% for j = 1 : length(thickness)
%     str='thickness'+string(thickness(j));
%     plot(offset,peaktop1(:,j)./peaktop1(1,j),'DisplayName',str,'LineWidth',2)
%     hold on
% end
% xlabel('sds','FontSize',20,'FontWeight','bold')
% ylabel('Top Intensity normalised','FontSize',20,'FontWeight','bold')

%%
for j = 1 : length(thickness)
    % ENR_n(:,j)=ENR_m(:,j)./max(ENR_m(:,j));
    str='thickness'+string(thickness(j))
    plot(offset,bottom_baseline(:,j)./bottom_baseline(1,j),'DisplayName',str,'LineWidth',2)
    hold on
end


%%
for i = 1 : 6;
    area(i) = (offset(i)+0.5).^2 - (offset(i)-0.5).^2 ;
end
figure;
power = 1./area;
plot(offset,power./power(1))
%%
for j = 1 : length(thickness)
    % ENR_n(:,j)=ENR_m(:,j)./max(ENR_m(:,j));
    str='thickness'+string(thickness(j))
    plot(offset,bottom_baseline(:,j)','DisplayName',str,'LineWidth',2)
    hold on
end

%%
thk2 = bottom_baseline(:,2);
plot(offset,thk2)

%%
figure;
for j = 1 : length(thickness)

    str='thickness'+string(thickness(j))
    plot(offset,peakbottom(:,j),'DisplayName',str,'LineWidth',2)
    hold on
end
xlabel('sds','FontSize',20,'FontWeight','bold')
ylabel('Bottom Intensity','FontSize',20,'FontWeight','bold')

%%
thk5 = peakbottom(:,4);
thk8 = peakbottom(:,7);