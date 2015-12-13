function [ x ] =remove_mean_three( x, mean )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
for i=1:24
    x(:,i)=x(:,i)-mean;
end

end

