function nndata=reset_net(nndata)
  %net=netdefine(nndata)
  %given a neural network object, resets all the training variables 


  for i=1:length(nndata.layer) %for each layer
    layer=nndata.layer{i};
    
    if (i==1)    %find number of inputs to this layer
      ninputsthislayer=nndata.ninputs;
    else
      ninputsthislayer=nndata.layer{i-1}.nunits;
    end
    

    layer.outputactivation=zeros(layer.nunits,1);           %all units output 0
    layer.weight= 2 * nndata.train.weightrange * (rand(layer.nunits,ninputsthislayer+1) - .5);  %random weights uniformly distributed 
    
    layer.eta = nndata.train.eta0*ones(size(layer.weight));         %initial step
    layer.gradient = zeros(size(layer.weight));    
    layer.gradientold = zeros(size(layer.weight));
    layer.z = zeros(size(layer.weight));
    
    nndata.layer{i}=layer;
    
    
    nndata.train.epoch = 0;                  %current epoch
    nndata.train.falseepochs = 0;            %???
    nndata.train.costmin = inf;              %minimum cost achieved thus far
    nndata.train.cost = [];%inf;                 %save cost values
    
    
  end


