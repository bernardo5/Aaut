function nndata = trainbatch (nndata,trainpattern,desiredoutput)
%
% [net,trainvars] = trainbatch (net,trainvars,trainpattern,desiredpattern)
%
% Train a net (MLP) in batch mode.
%
%   nndata          - Network to be trained with training parameters and variables.
%   trainpattern    - Training patterns (2-d array, one pattern per column).
%   desiredoutputs  - Desired outputs (2-d array, one pattern per column).

global NN_USER_STOP_TRAIN

for i = 1:nndata.train.nepochs
  if(NN_USER_STOP_TRAIN)
    break;
  end
  
  [nndata] = dobatchepoch(nndata,trainpattern,desiredoutput);
  
  if(nndata.train.reporteveryepoch | mod(nndata.train.epoch,20) == 0 | i == nndata.train.nepochs | nndata.train.cost(nndata.train.epoch) <= nndata.train.desiredcost)
      report(nndata,trainpattern,desiredoutput)
      pause(0.01)            % This is to allow the system to display plots during the run
  end
  
  
  if nndata.train.cost(nndata.train.epoch) <= nndata.train.desiredcost
    break
  end
    
end



    
