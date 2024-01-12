clear;clc;close all
ystart=1993;yend=2020;
timex=[datenum(ystart,1,1):datenum(yend,12,31)];
%------------------
lonx=[-60:1:20];xx=length(lonx);
latx=[-60:1:20];yy=length(latx);
%%
%------load horizontal distribution

load('../../cal_step1_contribution\MLT_onset\plt_step1_single/step3_revise.mat','data_max_term','data_min_term')
[ELEV,LONG,LAT]=m_etopo2([lonx(1) lonx(end) latx(1) latx(end)]);
for x=1:length(lonx)
    for y=1:length(latx)
      loc1=find(lonx(x)==LONG(1,:));
      loc2=find(latx(y)==LAT(:,1));
      data_basin(x,y)=ELEV(loc2,loc1);
    end
end

%%
%---load bar data for Ttend
load('../../Box_time_series\BCO_onset\step3_01_max.mat','driver_days_heat','driver_days_cool');
driver_days_heat(driver_days_heat>=5)=5;
tbl=tabulate(driver_days_heat);
dataT_bar(1,:)=tbl(:,3)/100;
driver_days_cool(driver_days_cool>=5)=5;
tbl=tabulate(driver_days_cool);
dataT_bar(2,:)=tbl(:,3)/100;
%%
load('../../../multi_variables_analysis/Box_time_series\Detrend_BMC\C1_intergrated_Tend_durations\step3v2_01max_of_Qnet.mat','driver_days_heat','driver_days_cool');
tbl=tabulate(driver_days_heat);
dataqT_bar(1,:)=tbl(:,3)/100;
tbl=tabulate(driver_days_cool);
dataqT_bar(2,:)=tbl(:,3)/100;

%%
load('../../../multi_variables_analysis/Box_time_series\Detrend_BMC\C1_intergrated_Tend_durations\step2v2_bian2023_01max_advT','driver_days_heat','driver_days_cool');
driver_days_heat(driver_days_heat>=2)=2;
tbl=tabulate(driver_days_heat);
dataadvT_bar(1,:)=tbl(:,3)/100;
driver_days_cool(driver_days_cool>=2)=2;
tbl=tabulate(driver_days_cool);
dataadvT_bar(2,:)=tbl(:,3)/100;


%%
%------BMC
a1=[-54 -49 -49 -54 -54];b1=[-43 -43 -38 -38 -43];
%[ELEV,LONG,LAT]=m_etopo2([min(lonx) max(lonx) min(latx) max(latx)]);
flux_names={'MHW events';'MCS events';'Advection';'Entrainment';'Residual'};
flux_n={'HFlux';'ADV';'ENT';'Resi';'Mixed'};
%%
figure1=figure; 
hold on
for t=1:2
hm(1)=subtightplot(2,2,t,[.06 .05],[.06 .06],[.06 .06]);

m_proj('miller','lon',[-60 10],'lat',[min(latx) 0]);
if t==1
    data=data_max_term;
else
    data=data_min_term;
end
data(data_basin>-100)=nan;
m_pcolor(lonx,latx,squeeze(data)');
cmap=othercolor('Cat_12',5);
cmap(2,:)=[0.3 0.7 0.9];
colormap(cmap);
cb=colorbar;
set(cb,'ticks',[1:1:5],'ticklabels',flux_n)
caxis([.5 5.5])
hold on
%m_contour(LONG,LAT,ELEV,[-200 -200],'linecolor',[.65 .65 .65],'linewidth',2)
m_coast('patch',[.7 .7 .7],'edgecolor','none');
%------------------------------
warning off
if t==2
m_grid('tickdir','out','linewi',2,'fontsize',14,...
    'xtick',[-60:20:20],'ytick',[-60:20:20],'yticklabel',[],'fontsize',14,...
    'fontsize',14);
else
 m_grid('tickdir','out','linewi',2,'fontsize',14,...
    'xtick',[-60:20:20],'ytick',[-60:20:20],'fontsize',14,...
    'fontsize',14);   
end
    
h=m_line(a1,b1,'color','k','linewidth',2,'linestyle','-');

title([ cell2mat(flux_names(t)) ],'FontSize',12);
set(gca,'fontsize',16);
end
%%
cmap=othercolor('Cat_12',5);
cmap(2,:)=[0.3 0.7 0.9];
hold on
hm(1)=subtightplot(2,3,4,[.15 .15],[.1 .1],[.1 .1]);
hold on
b1=bar([1 2 ],dataT_bar,'facecolor', 'flat','EdgeColor',cmap(1,:),'FaceAlpha',0.8,'linewidth',3);
for n = 1:5
    b1(n).FaceColor= cmap(n,:);
    b1(n).EdgeColor= cmap(n,:);
end
xrange={['MHWs'],['MCSs']};
set(gca,'xtick',[1 2],'xticklabel',xrange)
ylabel('Probability of dominant drivers')
%legend([b1(1) b1(2) b1(3) b1(4) b1(5)],flux_n,'Orientation','horizontal')
set(gca,'fontsize',14)
ylim([0 .5])
box on;grid on
%%
cmap=othercolor('YlOrRd6',8);

hold on
hm(1)=subtightplot(2,3,5,[.15 .15],[.1 .1],[.1 .1]);
hold on
b1=bar([1 2 ],dataqT_bar,'facecolor', 'flat','EdgeColor',cmap(1,:),'FaceAlpha',0.8,'linewidth',3);
for n = 1:4
    b1(n).FaceColor= cmap(n,:);
    b1(n).EdgeColor= cmap(n,:);
end
xrange={['MHWs'],['MCSs']};
set(gca,'xtick',[1 2],'xticklabel',xrange)
ylabel('Decomposed HFlux')
legend([b1(1) b1(2) b1(3) b1(4)],'Q_S_W','Q_L_a_t','Q_S_e_n','Q_L_W','Orientation','horizontal','location','southoutside')
set(gca,'fontsize',14)
ylim([0 .8])
box on;grid on

%%
cmap2(:,1)=[0 0.5 1];
cmap2(:,2)=[0.2 0.4 0.9];

hold on
hm(1)=subtightplot(2,3,6,[.15 .15],[.1 .1],[.1 .1]);
hold on
b1=bar([1 2 ],dataadvT_bar,'facecolor', 'flat','EdgeColor',cmap2(:,1),'FaceAlpha',0.8,'linewidth',3);
for n = 1:2
    b1(n).FaceColor= cmap2(:,n);
    b1(n).EdgeColor= cmap2(:,n);
end
xrange={['MHWs'],['MCSs']};
set(gca,'xtick',[1 2],'xticklabel',xrange)
ylabel('Decomposed ADV')
legend([b1(1) b1(2) ],'HFC-M','HFC-E','Orientation','horizontal','location','southoutside')
set(gca,'fontsize',14)
ylim([0 .8])
box on;grid on
%%
% 创建 textbox
annotation(figure1,'textbox',...
    [0.320091787439613 0.413532299741602 0.0168 0.0273],'String','d）',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off');

% 创建 textbox
annotation(figure1,'textbox',...
    [0.0689758454106279 0.452459948320414 0.0168 0.027],'String','c）',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off');

% 创建 textbox
annotation(figure1,'textbox',...
    [0.646734847151323 0.419188906593152 0.01685 0.0273],'String','e）',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off');

% 创建 textbox
annotation(figure1,'textbox',...
    [0.494508947955172 0.95326173729403 0.0168000000000002 0.027],'String','b）',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off');

% 创建 textbox
annotation(figure1,'textbox',...
    [0.0346399890473116 0.964672976550283 0.0168 0.027],'String',{'a）'},...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off');

%%
 %----------------------------------------------
set(gcf,'units','points','color','w')
set(gcf,'Units','inches',...
 'Position',[1 1 8 6],'rend','painters',...
 'PaperPositionMode','auto')


figt=['step2/plt_step1_revise ' '.jpeg'];
fig = gcf;
fig.PaperPositionMode = 'auto';
%set(gca,'Color',[0.5 0.5 0.5])
set(gcf, 'InvertHardCopy', 'off');
print('-djpeg',figt,'-r600');

