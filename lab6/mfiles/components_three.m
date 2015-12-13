function [ order ] =components_three( eigvalues,orderedeig )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
c=diag(eigvalues);
    for i=1:3000
       for j=1:3000
           if c(j)==max(orderedeig(i:3000))
                order(i)=j;
           end
       end
    end

end

