gp=sum(diag(eigvalues));

for i=1:20
   if (sum(orderedeig(1:i))/gp)>=0.95
      break; 
   end
end