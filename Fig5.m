clear;clc; close all

ystart=1993;yend=2020;
load(['../../../../../../../../datasets\GLORYS12V1d/step9_v1_BCO_STUV/data.' num2str(ystart) '.'  num2str(1)  '.mat'],'latx','lonx')
xlon=[1:length(lonx)];
ylat=[1:length(latx)];
timex=[datenum(ystart,1,1):datenum(yend,12,31)];
ttotal=length(timex);

dayt1=[1,cumsum([31,28,31,30,31,30,31,31,30,31,30,31])];
dayt2=[1,cumsum([31,29,31,30,31,30,31,31,30,31,30,31])];

latx=double(latx);
lonx=double(lonx);

index1=find(lonx>=-54 & lonx<=-49);
index2=find(latx>=-43 & latx<=-38);

%--MHW
date_in(:,1)=datenum(1993,1,4);
date_in(:,2)=datenum(2010,6,17);
date_in(:,3)=datenum(2020,11,21);

%--MCS
date_in(:,4)=datenum(1997,9,14);
date_in(:,5)=datenum(1999,4,6);
date_in(:,6)=datenum(2003,11,2);

%%
load('case1.mat' ,'data_fullx', 'data_ssh') 


%%
%--load  date
load('../../../../../../../cal_budget_analysis\Box_time_series\BCO_onset/step2_local_min.mat','MHWs','driver_days_heat','data_ano')
load('../../../../../../../cal_budget_analysis\Box_time_series\BCO_onset/step2_local_min.mat','MCSs','driver_days_cool')
%----remove two events with overlap of decay and onset phase (one is decay and the next one is onset
%-----happen simultaneously in time)
load('case1_v3_seasonal_cycle_mean_ssh.mat')
[ELEV,LONG,LAT]=m_etopo2([min(lonx) max(lonx)  min(latx) max(latx)]);
[data_elev]=grid_onto_GLORY(ELEV',LONG(1,:),LAT(:,1),lonx,latx);
[xx,yy,tt]=size(data_mean);
for t=1:tt
datax=data_mean(:,:,t);
datax(data_elev>-300)=nan;
datam1(:,:,t)=datax;
end
%%
%--------for 
[xx,yy,tt]=size(data_fullx);
[datax_low]=derive_ano_minuc_dailycycle(data_fullx,ystart,yend);
for x=1:xx
    for y=1:yy
datar(x,y,:)=detrend(squeeze(datax_low(x,y,:)));;
    end
end
%%
[xx,yy,tt,nn]=size(datar);
data_EKE=nan(xx,yy,6);
for n=1:6
locx=find(date_in(n)==timex);
data_EKE(:,:,n)=datar(:,:,locx);
end
[vx,vy]=meshgrid(lonx,latx);

xmin =-300; xmax=300;
units_name(1)={'J m^{-3}'};
data_c(:,1)=[-10 10];
dname(1)={'EKE'};
nums={'a)';'b)';'c)';'d)';'e)';'f)'};
cmap=flipud(othercolor('BrBu_10',11));
cmap(6,:)=[1 1 1];
%%
[xx,yy,nn]=size(data_EKE);
figure1=figure;
hold on
for n=1:nn
    if n<=3
hm(1)=subtightplot(2,3,n,[.04 .04],[.08 .06],[.08 .05]);
    else
hm(1)=subtightplot(2,3,n,[.04 .04],[.06 .08],[.08 .05]);        
    end
m_proj('miller','lon',[-58 max(lonx)],'lat',[-45 -33]);
hold on
m_pcolor(lonx,latx,squeeze(data_EKE(:,:,n))');
colormap(cmap);
caxis([xmin xmax]) 
if n==3 | n==6;co = colorbar; ylabel(co,units_name(1)); clear co ;end
%---------------BMC
a1=[-54 -49 -49 -54 -54];
b1=[-43 -43 -38 -38 -43];
h=m_line(a1,b1,'color','k','linewidth',2,'linestyle','-');

datam2=datam1(:,:,doy(date_in(:,n)));
m_contour(lonx,latx,squeeze(datam2)'*100+45,[-5 -5],'linecolor','k','linewidth',3,'linestyle',':')
m_contour(lonx,latx,squeeze(datam2)'*100+45,[30 30],'linecolor','r','linewidth',3,'linestyle',':')


hold on
m_coast('patch',[.7 .7 .7],'edgecolor','none');
if n<4
    m_grid('tickdir','out','linewi',2,'xtick',[-58:4:-45],'ytick',[-48:5:-28],...
   'xticklabel',[], 'fontsize',14);
else
    
m_grid('tickdir','out','linewi',2,'xtick',[-58:4:-45],'ytick',[-48:5:-28],...
    'fontsize',14);
end
if n<=3
title([cell2mat(nums(n)) ' MHW on ' datestr(date_in(:,n)) ]) 
else
title([cell2mat(nums(n)) ' MCS on ' datestr(date_in(:,n)) ]) 
end
set(gca,'box','on','fontsize',16);grid('on')   
end

% 创建 arrow
annotation(figure1,'arrow',[0.212053571428571 0.212983630952381],...
    [0.678819444444444 0.614583333333333],...
    'Color',[1 0.411764705882353 0.16078431372549],...
    'LineWidth',8,...
    'HeadWidth',25,...
    'HeadLength',25);

% 创建 arrow
annotation(figure1,'arrow',[0.756138392857143 0.793340773809524],...
    [0.576388888888889 0.583333333333333],...
    'Color',[1 0.411764705882353 0.16078431372549],...
    'LineWidth',8,...
    'HeadWidth',25,...
    'HeadLength',25);

% 创建 arrow
annotation(figure1,'arrow',[0.496651785714286 0.523623511904762],...
    [0.142361111111111 0.237847222222222],...
    'Color',[1 0.411764705882353 0.16078431372549],...
    'LineWidth',8,...
    'HeadWidth',25,...
    'HeadLength',25);

% 创建 arrow
annotation(figure1,'arrow',[0.258556547619048 0.197172619047619],...
    [0.210069444444444 0.211805555555555],...
    'Color',[1 0.411764705882353 0.16078431372549],...
    'LineWidth',8,...
    'HeadWidth',25,...
    'HeadLength',25);

% 创建 textbox
annotation(figure1,'textbox',...
    [0.49 0.828125 0.0827053571428572 0.0607638888888888],...
   'String',{'strengthened'},...
  'Color',[1 0.411764705882353 0.16078431372549],    'LineStyle','none',...
  'fontsize',16,  'FitBoxToText','on',...
    'BackgroundColor',[1 1 1]);

% 创建 textbox
annotation(figure1,'textbox',...
    [0.787621927980024 0.314574864498645 0.0827053571428572 0.060763888888889],...
   'String','weakened',...
    'Color',[1 0.411764705882353 0.16078431372549],  'fontsize',16,'LineStyle','none',...
    'FitBoxToText','on',...
    'BackgroundColor',[1 1 1]);
%%
set(gcf,'units','points','color','w')
set(gcf,'Units','inches',...
 'Position',[1 1 11 6],'rend','painters',...
 'PaperPositionMode','auto')

figt=['case2/step_2' '.jpeg'];;
%print('-djpeg',figt,'-r300');
fig = gcf;
fig.PaperPositionMode = 'auto';
%set(gca,'Color',[0.5 0.5 0.5])
set(gcf, 'InvertHardCopy', 'off');
print('-djpeg',figt,'-r600');
%close all
