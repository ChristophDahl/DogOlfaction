function dat2 = analysisData2(dat2)


%% success rate according to breed and distance

temp = [];
breeds = unique(dat2.breed);
for i = 1:numel(unique(dat2.breed))
   dat2.breednumerical(find(strcmp(dat2.breed, breeds{i}) == 1)) = i;
end
dat2.breednumerical = dat2.breednumerical';

for i = 1:max(dat2.breednumerical)
    x = dat2.success(find(dat2.breednumerical == i));
    temp.results.breed(i) = nansum(x)./(numel(x) - sum(isnan(x)));
end

%% uncorrect for biases 

for i = 1:max(dat2.breednumerical)  %% breed on x, distance on y
    for j = 2:max(dat2.amount)
        x = dat2.success(find(dat2.breednumerical == i & dat2.amount == j));
        temp.results.breedXamount(j-1,i) = nansum(x)./(numel(x) - sum(isnan(x)));
    end
end

for i = 1:max(dat2.breednumerical)  %% breed on x, distance on y
    for j = 2:max(dat2.amount)
        for k = 1:max(dat2.number)
            x = dat2.success(find(dat2.breednumerical == i & dat2.amount == j  & dat2.number == k));
            temp.results.breedXamountXsubject(j-1,i,k) = nansum(x)./(numel(x) - sum(isnan(x)));
        end
    end
end

% mean per indiv
for k = 1:size(temp.results.breedXamountXsubject,3)
    tx = mean(squeeze(temp.results.breedXamountXsubject(:,:,k)));
    ix(k) = tx(~isnan(tx));
end

% mean per indiv
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

dat2.results.breedname = newNames;
dat2.results.meanIndiv = ix;
dat2.results.meanIndivCondition = jx;
dat2.results.meanIndivBreed = TX;
dat2.results.meanIndivFCI = RX;
dat2.results.meanIndivBreedCondition = PX;
dat2.results.meanIndivFCICondition = QX;