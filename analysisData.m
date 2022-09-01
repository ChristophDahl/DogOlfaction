function dat = analysisData(dat)

%% success rate according to breed and distance

temp = [];
breeds = unique(dat.breed);
for i = 1:numel(unique(dat.breed))
   dat.breednumerical(find(strcmp(dat.breed, breeds{i}) == 1)) = i;
end
dat.breednumerical = dat.breednumerical';

for i = 1:max(dat.breednumerical)
    x = dat.success(find(dat.breednumerical == i));
    temp.results.breed(i) = nansum(x)./(numel(x) - sum(isnan(x)));
end

for i = 1:max(dat.breednumerical)  %% breed on x, distance on y
    for j = 1:max(dat.amount)
        x = dat.success(find(dat.breednumerical == i & dat.amount == j));
        temp.results.breedXamount(j,i) = nansum(x)./(numel(x) - sum(isnan(x)));
    end
end

for i = 1:max(dat.breednumerical)  %% breed on x, distance on y
    for j = 1:max(dat.amount)
        for k = 1:max(dat.number)
            x = dat.success(find(dat.breednumerical == i & dat.amount == j  & dat.number == k));
            temp.results.breedXamountXsubject(j,i,k) = nansum(x)./(numel(x) - sum(isnan(x)));
        end
    end
end

% mean per indiv
for k = 1:size(temp.results.breedXamountXsubject,3)
    tx = mean(squeeze(temp.results.breedXamountXsubject(:,:,k)));
    ix(k) = tx(~isnan(tx));
end

% mean per indiv and condition
clear jx
for i = 1:size(temp.results.breedXamountXsubject,1)
    for k = 1:size(temp.results.breedXamountXsubject,3)
        tx = (squeeze(temp.results.breedXamountXsubject(i,:,k)));
        tx = tx(~isnan(tx));
        jx(i,k) = tx;
    end
end

%% reassign the breeds into an order arranged by numbers of FCI:
newOrder = [6,8,5,4,7,3,1,2];
newNames = {'MAS','WS','JR','SH','SP','GR','BB','FB'};

% mean per indiv and breed 
TX = [];
for j = 1:size(temp.results.breedXamountXsubject,2)
    Tx = [];
    for k = 1:size(temp.results.breedXamountXsubject,3)
        tx = mean(squeeze(temp.results.breedXamountXsubject(:,newOrder(j),k)));
        if ~isnan(tx)
            Tx = [Tx, tx];
        end
    end
    TX{j} = Tx;
end

% mean per indiv and dog group (FCI) 
RX = [];
gr = [1,1,2,3,3,4,5,5];
cx = 1;
Tx = [];
for j = 1:size(temp.results.breedXamountXsubject,2)
    for k = 1:size(temp.results.breedXamountXsubject,3)
        tx = mean(squeeze(temp.results.breedXamountXsubject(:,newOrder(j),k)));
        if ~isnan(tx)
            Tx = [Tx, tx];
        end
    end
    if (j ~= length(gr)) & (gr(j) ~= gr(j+1))
        RX{cx} = Tx;
        cx = cx + 1;
        Tx = [];
    elseif j == length(gr)
       RX{cx} = Tx; 
    end
end

% mean per indiv and breed and condition
PX = [];
for i = 1:size(temp.results.breedXamountXsubject,1)
    for j = 1:size(temp.results.breedXamountXsubject,2)
        Tx = [];
        for k = 1:size(temp.results.breedXamountXsubject,3)
            tx = mean(squeeze(temp.results.breedXamountXsubject(i,newOrder(j),k)));
            if ~isnan(tx)
                Tx = [Tx, tx];
            end
        end
        PX{i,j} = Tx;
    end   
end

% mean per indiv and dog group (FCI) and condition
QX = [];
gr = [1,1,2,3,3,4,5,5];
cx = 1;
Tx = [];
for j = 1:max(gr)
    for i = 1:size(temp.results.breedXamountXsubject,1)
        QX{i,j} = [];
    end
end

for j = 1:size(temp.results.breedXamountXsubject,2)
    for i = 1:size(temp.results.breedXamountXsubject,1)
        for k = 1:size(temp.results.breedXamountXsubject,3)
            tx = mean(squeeze(temp.results.breedXamountXsubject(i,newOrder(j),k)));
            if ~isnan(tx)
                Tx = [Tx, tx];
            end
        end
        
        QX{i,gr(j)} = [QX{i,gr(j)}, Tx];
        Tx = [];
        
    end
end

dat.results.breedname = newNames;
dat.results.meanIndiv = ix;
dat.results.meanIndivCondition = jx;
dat.results.meanIndivBreed = TX;
dat.results.meanIndivFCI = RX;
dat.results.meanIndivBreedCondition = PX;
dat.results.meanIndivFCICondition = QX;