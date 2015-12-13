function [ mean ] = mean_three( x )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Calc mean
mean=0;
for i=1:24
    mean=mean+x(:,i);
end

mean=mean./24;

end

