function nndata = costcomp(nndata,desiredoutput)
  
%ntrain = size(desiredoutput,2);

neterror = nndata.layer{end}.outputactivation - desiredoutput;

%noutputs=nndata.layer{end}.nunits;

nndata.train.cost(nndata.train.epoch) = call_costfun(nndata.train.costfun,neterror,'direct');

nndata.layer{end}.backin = call_costfun(nndata.train.costfun,neterror,'feedback');


return



