function eqm=test_cost(nndata, trainpattern, desired_output)
  %returns the eqm of a set of test patterns
  
  nndata=forward(nndata, trainpattern);
  nndata=costcomp(nndata, desired_output);
  
  eqm=nndata.train.cost(nndata.train.epoch);
  
  
