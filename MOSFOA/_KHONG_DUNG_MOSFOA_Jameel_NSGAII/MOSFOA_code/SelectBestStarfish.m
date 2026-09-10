function ab=SelectBestStarfish(pop,ncolumn)
[d2,ind]=sort(pop(:,ncolumn),'descend');
d2(1:2)=d2(3);
d2=d2/(sum(d2));
r=rand;
C=cumsum(d2);
i=find(r<=C,1,'first');
ab=pop(ind(i),:);
end