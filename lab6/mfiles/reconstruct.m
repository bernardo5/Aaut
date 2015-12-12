function [ xr ] = reconstruct( mean, x, vectors )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
for i=1:354
   y1=x(:,i)'*vectors(:,20);
   y2=x(:,i)'*vectors(:,19);
   xr(:,i)=y1*vectors(:,20)+y2*vectors(:,19)+mean;
end

end

