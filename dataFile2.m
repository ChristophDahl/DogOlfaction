function dat = dataFile 

[NUMERIC,TXT,RAW] = xlsread('DATA_Food quantity discrimination.xlsx');

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



