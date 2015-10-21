function result=costfun_mse(error, typ)
  
  switch typ
    case 'direct',
      result=sum(sum(error.^2))/(size(error,1)*size(error,2));
    case 'feedback',
      result=2*error/(size(error,1)*size(error,2));
    case 'configure',
      %this one does not have options. this is to be used by configurable error criteria 
      %for example using the absolute value criteria may need to select
      %slopes.
      result=[];
    case 'description',
      result='squared error';
    case 'graph',
      x=-1:.1:1;
      y=x.^2;
      result=[x;y];
    end
    
