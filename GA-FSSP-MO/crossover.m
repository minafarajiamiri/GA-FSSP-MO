function  cpop=crossover(cpop,pop,npop,ncross,data,w)

for i=1:npop
f(i)=[pop(i).value(3)];
end
f=1./f;
f=f./sum(f);
f=cumsum(f);

nvar=size(pop(1).position,2);

for k=1:2:ncross

    i1=find(rand<=f,1,'first');
    i2=find(rand<=f,1,'first');

pc1=pop(i1).position;
pc2=pop(i2).position;

j=randi([1 nvar-1]);

o1=[pc1(:,1:j) pc2(:,j+1:end)];
o2=[pc2(:,1:j) pc1(:,j+1:end)];

o1(1,:)=unique([o1(1,:) randperm(nvar)],'stable');
o2(1,:)=unique([o2(1,:) randperm(nvar)],'stable');

cpop(k).position=o1;
[a1,a2,a3]=fitness(cpop(k).position,data,w);
cpop(k).value=[a1,a2,a3];

cpop(k+1).position=o2;
[b1,b2,b3]=fitness(cpop(k+1).position,data,w);
cpop(k+1).value=[b1,b2,b3];

end

end



















