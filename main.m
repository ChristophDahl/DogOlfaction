clear all
close all
addpath('~/hd1/olfactionDog2/programs/')
mainpath = '~/hd1/olfactionDog2';
progpath = '~/hd1/olfactionDog2/programs';
cd(progpath)

dat = '~/hd1/olfactionDog2/data';
cd(dat)

res = '~/hd1/olfactionDog2/res';

% detection
dat = dataFile
dat = analysisData(dat)
figureDetection

% discrimination
dat2 = dataFile2
dat2 = analysisData2(dat2)
figureDiscrimination

statisticsModelling
correlationFigure

cd(res)
for i=1:2
    cd(res)
    figure(i)
    set(gcf,'renderer','painters')
    print(gcf,strcat('figure',num2str(i),'.tiff'),'-dtiff','-r300');
    
    set(gcf,'renderer','painters')
    print(gcf,'-depsc2',strcat('figure',num2str(i),'.eps')); 
    
    set(gcf,'renderer','painters')
    print(gcf,'-dpng',strcat('figure',num2str(i),'.png')); 
end

close all