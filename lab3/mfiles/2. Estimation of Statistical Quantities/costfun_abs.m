function result=costfun_abs(error, typ)
  
  switch typ
    case 'direct',
      result=sum(sum(abs(error)))/(size(error,1)*size(error,2));
    case 'feedback',
      result=sign(error)/(size(error,1)*size(error,2));
    case 'configure',
      %this one does not have options. this is to be used by configurable error criteria 
      %for example using the absolute value criteria may need to select
      %slopes.
      result=[];
    case 'description',
      result='absolute error';
    case 'graph',
      x=-1:.1:1;
      y=abs(x);
      result=[x;y];
    end
    
