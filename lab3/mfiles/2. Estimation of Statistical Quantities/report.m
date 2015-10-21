function report(nndata,trainpattern,desiredoutput)
%
% report(net,trainvars,trainpattern,desiredpattern)
%
% This function is called by 'trainbatch', at the end of each epoch, 
% to output data about the training process. It is not intended to be called
% by the user.
%
% This function may be edited to suit the user's needs regarding the
% contents and format of the output during training.

fprintf(1,'epoch %6d,   cost = %11.8f,   improvement = %11.8f\n',nndata.train.epoch, nndata.train.cost(nndata.train.epoch), nndata.train.costmin - nndata.train.cost(nndata.train.epoch))

%if trainvars.epoch > 1
%    figure(1)
    %plot(trainvars.cost), axis([0,trainvars.epoch,0,max(trainvars.cost)])       % Linear plot
%    semilogy(trainvars.cost)                                                    % Logarithmic plot
%    title('Training-set cost')
%end


return
