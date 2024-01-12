clear;clc; close all
ystart=1993;yend=2020;
load(['../../../../../../../../datasets\GLORYS12V1d/step9_v1_BCO_STUV/data.' num2str(ystart) '.'  num2str(1)  '.mat'],'latx','lonx')
timex=[datenum(ystart,1,1):datenum(yend,12,31)];
ttotal=length(timex);


timex=[datenum(ystart,1,1):datenum(yend,12,31)];

%%
datasets={'HFlux-driven MHWs';'ADV-driven MHWs ';'HFlux-driven MCSs';'ADV-driven MCSs'};

load('../step3v2_hobday_therm_9v2.mat')
[xx,yy,nn,mm]=size(data_mean);

[vx2,vy2]=meshgrid(lonx,latx);

tmp_start=[8 9 10 11 12];nt=length(tmp_start);
pden_start=[26 26.5 27.23];np=length(pden_start);

%-----------(3)  thermocline

xmin(1:4,1) =-10; xmax(1:4,1)=10;
units_name={'m'};
dname={'8^oC';'9^oC';'10^oC';'11^oC';'12^oC'};
data_c(:,1)=[-10 10];
%%

figure1=figure;
hold on
for m=1:mm
   for n=1:nn
hm(1)=subtightplot(mm,4,(m-1)*4+n,[.02 .02],[.04 .04],[.04 .04]);
m_proj('miller','lon',[-60 -45],'lat',[-48 -28]);

hold on
m_pcolor(lonx,latx,squeeze(data_mean(:,:,n,m))');
colormap(othercolor('BuDRd_12',16));
caxis([xmin(n,1) xmax(n,1)]) 
%[c,h]=m_contour(lonx,latx,squeeze(data_m(:,:,n,m))',data_c(:,m),'linestyle','-','linecolor','k');
%clabel(c,h,data_c(:,m),'Color', 'k', 'Rotation', 0,'labelspacing', 1200,'fontsize',14);
if n==nn;co = colorbar; ylabel(co,units_name(1)); clear co ;end

if m==5;[vx,vy]=meshgrid(lonx,latx);
%[h1]=m_quiver(vx,vy,squeeze(datau1(:,:,n))'*5,squeeze(datav1(:,:,n))'*5.5,0,'MaxHeadSize',2,'color','r'); 
%set(h1,'color','k','MaxHeadSize',2,'Linewidth',1.2)
%axis equal
end
%------BMC
a1=[-54 -49 -49 -54 -54];
b1=[-43 -43 -38 -38 -43];
h=m_line(a1,b1,'color','k','linewidth',2,'linestyle','-');

hold on
m_coast('patch',[.7 .7 .7],'edgecolor','none');
if m==4
m_grid('tickdir','out','linewi',2,...
    'xtick',[-60:15:-45],'ytick',[-48:5:-28],...
    'fontsize',12);
else
 m_grid('tickdir','out','linewi',2,...
    'xtick',[-60:15:-45],'ytick',[-48:5:-28],'xticklabel',[],...
    'fontsize',12);   
end

set(gca,'box','on','fontsize',16);grid('on') 
if m==1;title([cell2mat(datasets(n))],'fontsize',14) ;end
if n==1;ylabel([cell2mat(dname(m))],'fontsize',14);end   
   end
end
%-------


%%
set(gcf,'units','points','color','w')
set(gcf,'Units','inches',...
 'Position',[0 0 9.5 8],'rend','painters',...
 'PaperPositionMode','auto')

figt=['step1v2 thermocline9.jpeg'];;
%print('-djpeg',figt,'-r300');
fig = gcf;
fig.PaperPositionMode = 'auto';
%set(gca,'Color',[0.5 0.5 0.5])
set(gcf, 'InvertHardCopy', 'off');
print('-djpeg',figt,'-r600');