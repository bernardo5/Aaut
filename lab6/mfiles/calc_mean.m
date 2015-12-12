function [ mean ] = calc_mean( x )
%Calc mean
mean=0;
for i=1:354
    mean=mean+x(:,i);
end

mean=mean./354;

end

