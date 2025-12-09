clear
close all
clc
format short
tic
%% problem definition
data=load('data.mat');
m=data.m; 
n=data.n; 
%% parameters setting
npop=120; 
maxiter=100; 
pc=0.7; 
nc=2*round((npop*pc)/2); 
pm=0.5; 
nm=round(npop*pm);
wp=100;
expr=zeros(wp,3);
randsol.position=[];
randsol.value=[];
pareto=repmat(randsol,wp,1);
for l=1:wp
    w=unique(rand);
    %% initial population algorithm
    pop=repmat(randsol,npop,1);
    for i=1:npop
        x=zeros(m+1,n);
        x(1,:)=randperm(n);
        for j=2:m+1
        x(j,:)=randi([1,3],1,n);
        end
        pop(i).position=x;
        [y1,y2,y3]=fitness(pop(i).position,data,w);
        pop(i).value=[y1,y2,y3];
    end
    %% main loop algorithm
    BEST=repmat(randsol,maxiter,1);
    for iter=1:maxiter
     %crossover
     cpop=repmat(randsol,nc,1);
     cpop=crossover(cpop,pop,npop,nc,data,w);
     %mutation
     mpop=repmat(randsol,nm,1);   
     mpop=mutation(mpop,pop,nm,npop,data,w); 
     %selection
     [pop]=[pop;cpop;mpop];
     for k=1:npop+nc+nm
         v(k)=pop(k).value(3);
     end
     [value,index]=sort(v);     
     pop=pop(index);
     gpop=pop(1);
     pop=pop(1:npop);
    %% results
    BEST(iter).value=gpop.value;
    BEST(iter).position=gpop.position;
    bst=BEST(maxiter);
    end
pareto(l)=bst;
f1(l)=pareto(l).value(1);
f2(l)=pareto(l).value(2);
disp(['l=' num2str(l)  ' w=' num2str(w)  '  f1=' num2str(f1(l))  ' f2=' num2str(f2(l))  ' pareto=' num2str(pareto(l).value(3))])
expr(l,:)=[pareto(l).value(1),pareto(l).value(2),pareto(l).value(3)];
end
filename = '8large.xlsx';
xlswrite(filename,expr,1,'A1:C100');
disp([ ' Time = '  num2str(toc)])
figure(1)
plot(f1,f2,'-r*')
xlable('f1')
ylable('f2')
title('ga pareto front')
