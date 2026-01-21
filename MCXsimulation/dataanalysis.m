load('bottom.mat');
load('top.mat');
load('modified_ratio.mat');

sds = 3:2:21;
layer = [1 2 3 5 6 7 8 10];
modified_ratio = modified_ratio';
ratio = em1b ./ em2t;
cv = sqrt(em1b.*modified_ratio)./em1b;
cv_org = 1./sqrt(em1b);
ENR_sim = ratio./((10^6)*cv);
ENR_org = ratio./((10^6)*cv_org);
%%

j=jet(10);
figure;
for i = 1 : size(ENR_sim,1)
    str = string(layer(i));
    plot(sds,ENR_sim(i,:)./max(ENR_sim(i,:)),"LineWidth",2,"Color",j(i,:),'DisplayName',str);
    hold on
end
xlabel('Offset/mm','FontSize',16,'FontWeight','bold')
ylabel('Normalised ENR','FontSize',16,'FontWeight','bold')
lgd = legend;
% lgd.Title.String = 'Top Thickness/mm'; % Set the legend title
lgd.FontSize = 14; % Optional: Adjust legend font size

%%
j=jet(10);
figure;
for i = 1 : size(ENR_sim,1)
    str = string(layer(i));
    plot(sds,ENR_sim(i,:),"LineWidth",2,"Color",j(i,:),'DisplayName',str);
    hold on
end
xlabel('Offset/mm','FontSize',16,'FontWeight','bold')
ylabel('ENR','FontSize',16,'FontWeight','bold')
lgd = legend;
% lgd.Title.String = 'Top Thickness/mm'; % Set the legend title
lgd.FontSize = 14; % Optional: Adjust legend font size

%%
figure;
plot(sds,(10^8)*cv(4,:),"LineWidth",2,'Marker','o')
xlabel('Offset/mm','FontSize',18,'FontWeight','bold')
ylabel('cv/%','FontSize',18,'FontWeight','bold')