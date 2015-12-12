clear;
mean=0;

x=load('points.txt');

mean=calc_mean(x);

x=remove_mean(x,mean);

R=r(x);

[vectors, eigvalues]=eig(R);

orderedeig=sort(diag(eigvalues), 'descend');

order=components( eigvalues,orderedeig )';


gp=sum(diag(eigvalues));

for i=1:20
   if (sum(orderedeig(1:i))/gp)>=0.95
      break; 
   end
end

gp=sum(diag(eigvalues));

gl=sum(orderedeig(1:2));

energy=gl/gp;

xr=reconstruct( mean, x, vectors );
