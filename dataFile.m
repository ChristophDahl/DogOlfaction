function dat = dataFile 

[NUMERIC,TXT,RAW] = xlsread('DATA_Food Source localisation.xlsx');

% NUMERIC = NUMERIC(85:end,:);
% TXT = TXT(85:end,:);

dat = [];
dat.number = NUMERIC(:,1);
dat.repetition = NUMERIC(:,4);
dat.amount = NUMERIC(:,5);
dat.distance = NUMERIC(:,6);
dat.success = NUMERIC(:,9);


dat.dogname = TXT(2:end,2);
dat.breed = TXT(2:end,3);
dat.side = TXT(2:end,7);
dat.chosenSide = TXT(2:end,8);



