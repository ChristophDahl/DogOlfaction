%% statistics 

for i = 1:length(dat.side)
   if strcmp(dat.side(i),'D')
        side(i) = 1;
   elseif strcmp(dat.side(i),'G')
        side(i) = 2;
   end
end
for i = 1:length(dat2.side)
   if strcmp(dat2.side(i),'D')
        side2(i) = 1;
   elseif strcmp(dat2.side(i),'G')
        side2(i) = 2;
   end
end

newOrder = [6,8,5,4,7,3,1,2];
gr = [1,1,2,3,3,4,5,5];
newvector = zeros(length(dat.side),1);
for i = 1:length(unique(dat.breed))
    idx = find(dat.breednumerical == newOrder(i));
    newvector(idx,1) = gr(i);
end
newOrder = [6,8,5,4,7,3,1,2];
gr = [1,1,2,3,3,4,5,5];
newvector2 = zeros(length(dat2.side),1);
for i = 1:length(unique(dat2.breed))
    idx = find(dat2.breednumerical == newOrder(i));
    newvector2(idx,1) = gr(i);
end

r1= repmat(1,length(dat.success),1);
r2 = repmat(2,length(dat2.success),1);

CI = [3,3,2,3,1,2,1,1];

vec1 = zeros(length(dat.breednumerical),1);
ci1 = zeros(length(dat.breednumerical),1);
for i = 1:max(dat.breednumerical)
    is = find(dat.breednumerical == newOrder(i));
    vec1(is) = i;
    ci1(is) = CI(i);
end
vec2 = zeros(length(dat2.breednumerical),1);
ci2 = zeros(length(dat2.breednumerical),1);
for i = 1:max(dat2.breednumerical)
    is = find(dat2.breednumerical == newOrder(i));
    vec2(is) = i;
    ci2(is) = CI(i);
end

agx = [12, 33, 15, 57, 27, 53, 26, 25, 53, 12, 15, 71, 47, 26, 5, 4, 7, 3, 2, 3, 4, 4, 5, 3, 3, 6, 4, 3, 9, 2, 3, 4, 13, 9, 3, 4, 2, 7, 132, 72, 72];
sexx = [1,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,2,2,1,1,1,2,1,1,1,2,2,2,2,1,1,2,2,1,1,1,2,1,1,2,1];

agx(find(agx < 7)) = 0;
agx(find(agx >= 7)) = 1;

for i = 1:length(dat.breednumerical)
    agex(i) = agx(dat.number(i));
    sexex(i) = sexx(dat.number(i));
end
    
for i = 1:length(dat2.breednumerical)
    agex2(i) = agx(dat2.number(i));
    sexex2(i) = sexx(dat2.number(i));
end

%% calculate a model with breed as fixed effect

datx = [dat.number, vec1, dat.repetition, dat.amount, dat.success, side', agex', sexex', ci1];
daty = [dat2.number, vec2, dat2.repetition, dat2.amount-1, dat2.success,side2', agex2', sexex2', ci2];
t1 = table(categorical(datx(:,1)),categorical(datx(:,2)),categorical(datx(:,3)),categorical(datx(:,4)),datx(:,5),categorical(datx(:,6)),categorical(datx(:,7)),categorical(datx(:,8)),categorical(datx(:,9)));
t2 = table(categorical(daty(:,1)),categorical(daty(:,2)),categorical(daty(:,3)),categorical(daty(:,4)),daty(:,5),categorical(daty(:,6)),categorical(daty(:,7)),categorical(daty(:,8)),categorical(daty(:,9)));
header = {'Subject','Breed','Repetition','Amount','Response','Side','Age','Sex','IC'};
ds = cell2table(table2cell(t1), 'VariableNames', header);
ds2 = cell2table(table2cell(t2), 'VariableNames', header);

header2 = {'Subject','Breed','Repetition','Amount','Response','Side','Task','Age','Sex','IC'};
t1x = table(categorical(datx(:,1)),categorical(datx(:,2)),categorical(datx(:,3)),categorical(datx(:,4)),datx(:,5),categorical(datx(:,6)),categorical(r1),categorical(datx(:,7)),categorical(datx(:,8)),categorical(datx(:,9)));
t2x = table(categorical(daty(:,1)),categorical(daty(:,2)),categorical(daty(:,3)),categorical(daty(:,4)),daty(:,5),categorical(daty(:,6)),categorical(r2),categorical(daty(:,7)),categorical(daty(:,8)),categorical(daty(:,9)));

t_all = table(categorical([datx(:,1);daty(:,1)]),categorical([datx(:,2);daty(:,2)]),categorical([datx(:,3);daty(:,3)]),categorical([datx(:,4);daty(:,4)]),...
    ([datx(:,5);daty(:,5)]),categorical([datx(:,6);daty(:,6)]),categorical([r1;r2]),categorical([datx(:,7);daty(:,7)]),categorical([datx(:,8);daty(:,8)]),categorical([datx(:,9);daty(:,9)]));
d_all = cell2table(table2cell(t_all), 'VariableNames', header2);

%% define full model

FullModelA = fitglme(d_all,'Response ~ 1 + Breed + Amount + Side + Task + Breed:Amount + Breed:Side + Breed:Task + Side:Task + Amount:Task + Amount:Side + Breed:Side:Task + Breed:Amount:Task + Breed:Amount:Side + Amount:Side:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

FullModelB = fitglme(d_all,'Response ~ 1 + IC + Amount + Side + Task + IC:Amount + IC:Side + IC:Task + Side:Task + Amount:Task + Amount:Side + IC:Side:Task + IC:Amount:Task + IC:Amount:Side + Amount:Side:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');


%% define null model

NullModelA = fitglme(d_all,'Response ~ 1 + Breed + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

NullModelB = fitglme(d_all,'Response ~ 1 + IC + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

results = compare(FullModelA,NullModelA,'CheckNesting',true)     
results = compare(FullModelB,NullModelB,'CheckNesting',true) 


% significant? then continue:
% take out all non-significant interactions

anova(FullModelA)    
anova(FullModelB)

FinalModelA = fitglme(d_all,'Response ~ 1 + Breed + Amount + Side + Task + Breed:Amount + Breed:Task + Amount:Task + Breed:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

FinalModelB = fitglme(d_all,'Response ~ 1 + IC + Amount + Side + Task + IC:Amount + IC:Task + Amount:Task + IC:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

results = compare(FullModelA,FinalModelA,'CheckNesting',true)
results = compare(FullModelB,FinalModelB,'CheckNesting',true) 

[beta,betanames,stats2] = randomEffects(FinalModelA,'alpha',0.05)

BreedModel = fitglme(d_all,'Response ~ 1 - Breed + Amount + Side + Task + Breed:Amount + Breed:Task + Amount:Task + Breed:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

ICModel = fitglme(d_all,'Response ~ 1 - IC + Amount + Side + Task + IC:Amount + IC:Task + Amount:Task + IC:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

results = compare(FinalModelA,BreedModel,'CheckNesting',true) 
results = compare(FinalModelB,ICModel,'CheckNesting',true) 

AmountModelA = fitglme(d_all,'Response ~ 1 + Breed - Amount + Side + Task + Breed:Amount + Breed:Task + Amount:Task + Breed:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

AmountModelB = fitglme(d_all,'Response ~ 1 + IC - Amount + Side + Task + IC:Amount + IC:Task + Amount:Task + IC:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');
results = compare(FinalModelA,AmountModelA,'CheckNesting',true)
results = compare(FinalModelB,AmountModelB,'CheckNesting',true)

SideModelA = fitglme(d_all,'Response ~ 1 + Breed + Amount - Side + Task + Breed:Amount + Breed:Task + Amount:Task + Breed:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

SideModelB = fitglme(d_all,'Response ~ 1 + IC + Amount - Side + Task + IC:Amount + IC:Task + Amount:Task + IC:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');
results = compare(FinalModelA,SideModelA,'CheckNesting',true) 
results = compare(FinalModelB,SideModelB,'CheckNesting',true)    

TaskModelA = fitglme(d_all,'Response ~ 1 + Breed + Amount + Side - Task + Breed:Amount + Breed:Task + Amount:Task + Breed:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

TaskModelB = fitglme(d_all,'Response ~ 1 + IC + Amount + Side - Task + IC:Amount + IC:Task + Amount:Task + IC:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');
results = compare(FinalModelA,TaskModelA,'CheckNesting',true)
results = compare(FinalModelB,TaskModelB,'CheckNesting',true)

BreedAmountModel = fitglme(d_all,'Response ~ 1 + Breed + Amount + Side + Task - Breed:Amount + Breed:Task + Amount:Task + Breed:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

ICAmountModel = fitglme(d_all,'Response ~ 1 + IC + Amount + Side + Task - IC:Amount + IC:Task + Amount:Task + IC:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

results = compare(FinalModelA,BreedAmountModel,'CheckNesting',true) 
results = compare(FinalModelB,ICAmountModel,'CheckNesting',true) 

BreedTaskModel = fitglme(d_all,'Response ~ 1 + Breed + Amount + Side + Task + Breed:Amount - Breed:Task + Amount:Task + Breed:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

ICTaskModel = fitglme(d_all,'Response ~ 1 + IC + Amount + Side + Task + IC:Amount - IC:Task + Amount:Task + IC:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

results = compare(FinalModelA,BreedTaskModel,'CheckNesting',true) 
results = compare(FinalModelB,ICTaskModel,'CheckNesting',true) 

AmountTaskModelA = fitglme(d_all,'Response ~ 1 + Breed + Amount + Side + Task + Breed:Amount + Breed:Task - Amount:Task + Breed:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

AmountTaskModelB = fitglme(d_all,'Response ~ 1 + IC + Amount + Side + Task + IC:Amount + IC:Task - Amount:Task + IC:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

results = compare(FinalModelA,AmountTaskModelA,'CheckNesting',true)
results = compare(FinalModelB,AmountTaskModelB,'CheckNesting',true)

BreedAmountTaskModel = fitglme(d_all,'Response ~ 1 + Breed + Amount + Side + Task + Breed:Amount + Breed:Task + Amount:Task - Breed:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

ICAmountTaskModel = fitglme(d_all,'Response ~ 1 + IC + Amount + Side + Task + IC:Amount + IC:Task + Amount:Task - IC:Amount:Task + (Side|Subject) + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

results = compare(FinalModelA,BreedAmountTaskModel,'CheckNesting',true)
results = compare(FinalModelB,ICAmountTaskModel,'CheckNesting',true)

SubjectSideModelA = fitglme(d_all,'Response ~ 1 + Breed + Amount + Side + Task + Breed:Amount + Breed:Task + Amount:Task + Breed:Amount:Task + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

SubjectSideModelB = fitglme(d_all,'Response ~ 1 + IC + Amount + Side + Task + IC:Amount + IC:Task + Amount:Task + IC:Amount:Task + (Task|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

results = compare(FinalModelA,SubjectSideModelA,'CheckNesting',true)
results = compare(FinalModelB,SubjectSideModelB,'CheckNesting',true)

SubjectTaskModelA = fitglme(d_all,'Response ~ 1 + Breed + Amount + Side + Task + Breed:Amount + Breed:Task + Amount:Task + Breed:Amount:Task + (Side|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

SubjectTaskModelB = fitglme(d_all,'Response ~ 1 + IC + Amount + Side + Task + IC:Amount + IC:Task + Amount:Task + IC:Amount:Task + (Side|Subject) + (Amount|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

results = compare(FinalModelA,SubjectTaskModelA,'CheckNesting',true)
results = compare(FinalModelB,SubjectTaskModelB,'CheckNesting',true)

SubjectAmountModelA = fitglme(d_all,'Response ~ 1 + Breed + Amount + Side + Task + Breed:Amount + Breed:Task + Amount:Task + Breed:Amount:Task + (Side|Subject) + (Task|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

SubjectAmountModelB = fitglme(d_all,'Response ~ 1 + IC + Amount + Side + Task + IC:Amount + IC:Task + Amount:Task + IC:Amount:Task + (Side|Subject) + (Task|Subject)', ...
    'Distribution','binomial','Link','probit','FitMethod','Laplace', 'DummyVarCoding','effects');

results = compare(FinalModelA,SubjectAmountModelA,'CheckNesting',true)
results = compare(FinalModelB,SubjectAmountModelB,'CheckNesting',true)


