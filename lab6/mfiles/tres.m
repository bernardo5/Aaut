clear;

loadimg;

mean=mean_three( y );

y=remove_mean_three( y, mean );

R= r_three( y );

[vectors, eigvalues]=eig(R);

orderedeig=sort(diag(eigvalues), 'descend');

order=components_three( eigvalues,orderedeig )';

% for i=0:100
%     yr=0;
%     yr=reconstruct_three( mean, y, vectors , i );
%     figure
%     showimg(yr(:,1:3));
% end

%knee part

for m=0:3000
    hold on
    plot(m, sum(orderedeig(m+1:3000)), 'r.')
end
