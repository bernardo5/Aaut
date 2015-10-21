function [nndata] = stepadapt(nndata)

if nndata.train.epoch > 1 & (nndata.train.cost(nndata.train.epoch - 1) > nndata.train.costmin * nndata.train.costtolerance)  &  nndata.train.costcontrol

    %   Backtrack

    for i = 1:length(nndata.layer) %for each layer
        layer=nndata.layer{i};

        layer.weight = layer.weightmin;
        layer.gradient = layer.gradientmin;
        layer.etamin = layer.etamin * nndata.train.etareduce;
        layer.eta = layer.etamin;
        layer.z = zeros(size(layer.z));

        nndata.layer{i}=layer; %save layer back to structure
    end
    nndata.train.falseepochs = nndata.train.falseepochs + 1;

else

    if nndata.train.epoch > 1 & (nndata.train.cost(nndata.train.epoch - 1) < nndata.train.costmin)

        %   Record new cost minimum

        nndata.train.costmin = nndata.train.cost(nndata.train.epoch - 1);
        for i = 1:length(nndata.layer)
            layer=nndata.layer{i};

            layer.weightmin = layer.weight;
            layer.gradientmin = layer.gradient;
            layer.etamin = layer.eta;

            nndata.layer{i}=layer; %save layer back to structure

        end

    else if nndata.train.epoch == 1

            %   Record first cost as minimum

            nndata.train.costmin = nndata.train.cost(1);
            for i = 1:length(nndata.layer)
                layer=nndata.layer{i};

                layer.weightmin = layer.weight;
                layer.gradientmin = layer.gradient;
                layer.etamin = layer.eta;

                nndata.layer{i}=layer; %save layer back to structure

            end
        end
    end

    if nndata.train.adaptivesteps

        %   Adapt atep sizes

        for i = 1:length(nndata.layer)
            layer=nndata.layer{i};

            upflag = (layer.gradient .* layer.gradientold) >= 0;
            layer.eta = layer.eta .* (nndata.train.etaup * upflag + nndata.train.etadown * (1 - upflag));

            nndata.layer{i}=layer; %save layer back to structure
        end

    end

end




