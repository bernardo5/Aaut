function [ order ] = components( eigvalues,orderedeig )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
c=diag(eigvalues);
    for i=1:20
       for j=1:20
           if c(j)==max(orderedeig(i:20))
                order(i)=j;
           end
       end
    end

end

