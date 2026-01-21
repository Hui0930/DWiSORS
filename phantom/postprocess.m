offset = [3 5 7 9 11 13];
thickness = [1 2 3 5 6 7 8 10];

for i = 1 : length(offset)
    for j = 1 : length(thickness)
        file_name = sprintf('%dmmring%dmmtop.txt', offset(i), thickness(j));
        spectra = load(file_name);
        spectra_data(:,:,i,j) = spectra;
    end
end


%% bottom peak at pixel 246
peakbottom=zeros(size(spectra_data,3),size(spectra_data,4));
stdbottom=zeros(size(spectra_data,3),size(spectra_data,4));

for i = 1 : length(offset)
    for j = 1 : length(thickness)
        peakbottom(i,j)=mean(spectra_data(214:283,2,i,j)); %230:260
        stdbottom(i,j)=mean(spectra_data(214:283,3,i,j));
    end
end

% figure;
% for j = 1 : length(thickness)
% 
%     str='thickness'+string(thickness(j));
%     plot(offset,peakbottom(:,j),'DisplayName',str,LineWidth=2)
%     hold on
% end
% xlabel('sds','FontSize',20,'FontWeight','bold')
% ylabel('Bottom Intensity','FontSize',20,'FontWeight','bold')
% 
% figure;
% for j = 1 : length(thickness)
%     str='thickness'+string(thickness(j));
%     plot(offset,peakbottom(:,j)./peakbottom(1,j),'DisplayName',str,LineWidth=2)
%     hold on
% end
% xlabel('sds','FontSize',20,'FontWeight','bold')
% ylabel('Bottom Intensity normalised','FontSize',20,'FontWeight','bold')

%% top peak at pixel 143 186
peaktop1=zeros(size(spectra_data,3),size(spectra_data,4));
peaktop2=zeros(size(spectra_data,3),size(spectra_data,4));

for i = 1 : length(offset)
    for j = 1 : length(thickness)
        peaktop1(i,j)=mean(spectra_data(142:145,2,i,j));
        peaktop2(i,j)=mean(spectra_data(177:204,2,i,j));   %183:192
    end
end


%% enhancement cv

cvbottom=stdbottom./peakbottom;
enhancement = peakbottom./peaktop2;
ENR=enhancement./cvbottom;
% figure;
% for j = 1 : length(thickness)
% 
%     str='thickness'+string(thickness(j))
%     plot(offset,ENR(:,j),'DisplayName',str,LineWidth=2)
%     hold on
% end
% xlabel('sds','FontSize',20,'FontWeight','bold')
% ylabel('ENR','FontSize',20,'FontWeight','bold')


figure;
for j = 1 : length(thickness)

    str='thickness'+string(thickness(j));
    plot(offset,ENR(:,j)./max(ENR(:,j)),'DisplayName',str,'LineWidth',2)
    hold on
end
xlabel('sds','FontSize',20,'FontWeight','bold')
ylabel('ENR','FontSize',20,'FontWeight','bold')

%%

% t5 = ENR(:,4);
% figure;
% scatter(offset,t5)


