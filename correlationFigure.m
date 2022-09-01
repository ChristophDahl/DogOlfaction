figure(2)
set(2,'Position',[1000 700 1300 450])
binx = 15;

subplot(1,3,3)
[R,P,RLO,RUP]=corrcoef(dat2.results.meanIndiv,dat.results.meanIndiv)
tx = dat2.results.meanIndiv/dat.results.meanIndiv;
yCalc = tx * dat2.results.meanIndiv;

plot([0 1],[.5 .5],'k--')
hold on
plot([.5 .5],[0 1],'k--')   

a = -.01;
b = .01;

for i = 1:length(dat.results.meanIndiv)
    randx = (b-a).*rand(2,1) + a;
    x = dat.results.meanIndiv(i);
    y = dat2.results.meanIndiv(i);
    
    if dat.results.meanIndiv(i) <= .95 
        x = x+randx(1);
    end
    
    if dat2.results.meanIndiv(i) <= .95
        y = y+randx(2);
    end
        
    plot(x,y,'o','MarkerEdgeColor','k','MarkerFaceColor','w')
    hold on
end

plot(dat2.results.meanIndiv,yCalc,'k-')
[ad da] = hist(dat2.results.meanIndiv,binx)
plot(ad./sum(ad),da,'-','color', [.5 .5 .5])
[ad da] = hist(dat.results.meanIndiv,binx)
plot(da,ad./sum(ad),'-','color', [.5 .5 .5])
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'XTick'       , [0:.25:1], ...
  'YTick'       , [0:.25:1], ...
  'XColor'      , [0 0 0], ...
  'YColor'      , [0 0 0], ...
   'LineWidth'   , 1         );
axis([0 1 0 1])
axis square
str=sprintf('r = %1.2f',R(1,2));
text(.8, .05, str)

%% paste the mean of breeds in there

for i = 1: 8
    plot(mean(dat.results.meanIndivBreed{i}),mean(dat2.results.meanIndivBreed{i}),'o','MarkerEdgeColor','k','MarkerFaceColor','k')
    hold on
end

ylabel('Discrimination task [proportion correct]')
xlabel('Detection task [proportion correct]')

text(-.25, 1.2, 'C','Fontsize',16)


subplot(1,3,1)

tx = grp2idx(d_all.IC);
tb = grp2idx(d_all.Breed);
ti = grp2idx(d_all.Subject);

ty = grp2idx(d_all.Response)-1;
t1 = find(tx == 1);
t2 = find(tx == 2);
t3 = find(tx == 3);


tx1 = [];
tx2 = [];
tx3 = [];
for i = 1: length(unique(ti))
    if ~isempty(find(tx == 1 & ti == i))
        t1 = find(tx == 1 & ti == i);
        tx1 = [tx1,mean(ty(t1))];
    end
    if ~isempty(find(tx == 2 & ti == i))
        t2 = find(tx == 2 & ti == i);
        tx2 = [tx2,mean(ty(t2))];
    end
    if ~isempty(find(tx == 3 & ti == i))
        t3 = find(tx == 3 & ti == i);
        tx3 = [tx3,mean(ty(t3))];
    end
end

plot(1,mean(tx1),'.','MarkerEdgeColor','k', 'MarkerFaceColor','k','MarkerSize',12)
hold on
plot(2,mean(tx2),'.','MarkerEdgeColor','k', 'MarkerFaceColor','k','MarkerSize',12)
plot(3,mean(tx3),'.','MarkerEdgeColor','k', 'MarkerFaceColor','k','MarkerSize',12)
plot([1 1],[mean(tx1)-std(tx1,[],2)./sqrt(numel(tx1)) mean(tx1)+std(tx1,[],2)./sqrt(numel(tx1))],'k')
plot([2 2],[mean(tx2)-std(tx2,[],2)./sqrt(numel(tx2)) mean(tx2)+std(tx2,[],2)./sqrt(numel(tx2))],'k')
plot([3 3],[mean(tx3)-std(tx3,[],2)./sqrt(numel(tx3)) mean(tx3)+std(tx3,[],2)./sqrt(numel(tx3))],'k')
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'off'      , ...
  'YMinorTick'  , 'on'      , ...
  'XTick'       , [1,2,3], ...
  'YTick'       , [0:.25:1], ...
  'XColor'      , [0 0 0], ...
  'YColor'      , [0 0 0], ...
   'LineWidth'   , 1         );
axis([0.5 3.5 0 1])
axis square
ylabel('Performance [proportion correct]')
xlabel('Cephalic index class')
text(-.25, 1.2, 'A','Fontsize',16)

subplot(1,3,2)

offset = .1;
tt = grp2idx(d_all.Task);
idx = find(tt == 1);
tx = grp2idx(d_all.IC);
tb = grp2idx(d_all.Breed);
ti = grp2idx(d_all.Subject);
ty = grp2idx(d_all.Response)-1;

tx = tx(idx);
tb = tb(idx);
ti = ti(idx);
ty = ty(idx);


t1 = find(tx == 1);
t2 = find(tx == 2);
t3 = find(tx == 3);

tx1 = [];
tx2 = [];
tx3 = [];
for i = 1: length(unique(ti))
    if ~isempty(find(tx == 1 & ti == i))
        t1 = find(tx == 1 & ti == i);
        tx1 = [tx1,mean(ty(t1))];
    end
    if ~isempty(find(tx == 2 & ti == i))
        t2 = find(tx == 2 & ti == i);
        tx2 = [tx2,mean(ty(t2))];
    end
    if ~isempty(find(tx == 3 & ti == i))
        t3 = find(tx == 3 & ti == i);
        tx3 = [tx3,mean(ty(t3))];
    end
end


plot(1-offset,mean(tx1),'.','MarkerEdgeColor','k', 'MarkerFaceColor','k','MarkerSize',12)
hold on
plot(2-offset,mean(tx2),'.','MarkerEdgeColor','k', 'MarkerFaceColor','k','MarkerSize',12)
plot(3-offset,mean(tx3),'.','MarkerEdgeColor','k', 'MarkerFaceColor','k','MarkerSize',12)

plot([1 2]-offset,[mean(tx1) mean(tx2)],'k-.')
plot([2 3]-offset,[mean(tx2) mean(tx3)],'k-.')

plot([1 1]-offset,[mean(tx1)-std(tx1,[],2)./sqrt(numel(tx1)) mean(tx1)+std(tx1,[],2)./sqrt(numel(tx1))],'k')
plot([2 2]-offset,[mean(tx2)-std(tx2,[],2)./sqrt(numel(tx2)) mean(tx2)+std(tx2,[],2)./sqrt(numel(tx2))],'k')
plot([3 3]-offset,[mean(tx3)-std(tx3,[],2)./sqrt(numel(tx3)) mean(tx3)+std(tx3,[],2)./sqrt(numel(tx3))],'k')

tt = grp2idx(d_all.Task);
idx = find(tt == 2);
tx = grp2idx(d_all.IC);
tb = grp2idx(d_all.Breed);
ti = grp2idx(d_all.Subject);
ty = grp2idx(d_all.Response)-1;

tx = tx(idx);
tb = tb(idx);
ti = ti(idx);
ty = ty(idx);


t1 = find(tx == 1);
t2 = find(tx == 2);
t3 = find(tx == 3);

tx1 = [];
tx2 = [];
tx3 = [];
for i = 1: length(unique(ti))
    if ~isempty(find(tx == 1 & ti == i))
        t1 = find(tx == 1 & ti == i);
        tx1 = [tx1,mean(ty(t1))];
    end
    if ~isempty(find(tx == 2 & ti == i))
        t2 = find(tx == 2 & ti == i);
        tx2 = [tx2,mean(ty(t2))];
    end
    if ~isempty(find(tx == 3 & ti == i))
        t3 = find(tx == 3 & ti == i);
        tx3 = [tx3,mean(ty(t3))];
    end
end


plot(1+offset,mean(tx1),'.','MarkerEdgeColor','k', 'MarkerFaceColor','k','MarkerSize',12)
hold on
plot(2+offset,mean(tx2),'.','MarkerEdgeColor','k', 'MarkerFaceColor','k','MarkerSize',12)
plot(3+offset,mean(tx3),'.','MarkerEdgeColor','k', 'MarkerFaceColor','k','MarkerSize',12)

plot([1 2]+offset,[mean(tx1) mean(tx2)],'k--')
plot([2 3]+offset,[mean(tx2) mean(tx3)],'k--')


plot([1 1]+offset,[mean(tx1)-std(tx1,[],2)./sqrt(numel(tx1)) mean(tx1)+std(tx1,[],2)./sqrt(numel(tx1))],'k')
plot([2 2]+offset,[mean(tx2)-std(tx2,[],2)./sqrt(numel(tx2)) mean(tx2)+std(tx2,[],2)./sqrt(numel(tx2))],'k')
plot([3 3]+offset,[mean(tx3)-std(tx3,[],2)./sqrt(numel(tx3)) mean(tx3)+std(tx3,[],2)./sqrt(numel(tx3))],'k')

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'off'      , ...
  'YMinorTick'  , 'on'      , ...
  'XTick'       , [1,2,3], ...
  'YTick'       , [0:.25:1], ...
  'XColor'      , [0 0 0], ...
  'YColor'      , [0 0 0], ...
   'LineWidth'   , 1         );
axis([0.5 3.5 0 1])
axis square
ylabel('Performance [proportion correct]')
xlabel('Cephalic index class')

text(-.25, 1.2, 'B','Fontsize',16)