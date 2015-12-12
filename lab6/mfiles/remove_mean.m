function [ x ] = remove_mean( x, mean )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
for i=1:354
    x(:,i)=x(:,i)-mean;
end
end

