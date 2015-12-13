function [ xr ] = reconstruct_three( mean, x, vectors, number )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
for i=1:24
    for j=1:number
        y(j)=x(:,i)'*vectors(:,(3000-j+1));
    end
    x_aux=0;
   for j=1:number
        x_aux=x_aux+y(j)*vectors(:,(3000-j+1));
   end
   xr(:,i)=x_aux+mean;
end

end
