function [nndata] = dobatchepoch(nndata,trainpattern,desiredoutput)

% Start by copying input arguments into output ones, because we want to
% keep all the input data when we exit the function.

nndata.train.epoch=nndata.train.epoch + 1 ;

if nndata.train.epoch == 1                        % In the first epoch we need to start with some extra processing
  
  [nndata] = forward(nndata,trainpattern);        % Propagate forward
  
  [nndata] = costcomp(nndata,desiredoutput);     % Compute cost function, and its derivatives for backpropagation
  
  [nndata] = back(nndata);                        % Propagate backward
  
  [nndata] = compgrad(nndata,trainpattern);       % Compute gradients
  
end
  
[nndata] = stepadapt(nndata);                   % Adapt step sizes; backtrack if necessary    
  
[nndata] = weightadapt(nndata);                 % Adapt weights

[nndata] = forward(nndata,trainpattern);        % Propagate forward

[nndata] = costcomp(nndata,desiredoutput);     % Compute cost function, and its derivatives for backpropagation

[nndata] = back(nndata);                        % Propagate backward

[nndata] = compgrad(nndata,trainpattern);       % Compute gradients


