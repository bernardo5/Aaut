function result=call_costfun(costfun_name,argument, typ)
  
  name=strcat('costfun_',costfun_name); 
  
  result=feval(name,argument,typ);
  
  
  
