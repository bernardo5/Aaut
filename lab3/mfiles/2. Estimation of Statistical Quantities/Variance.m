fileid = fopen('STAT1.TXT');
i=2;
%while i < 400
desired_output=fscanf(fileid,'%f');

%i=i+1;
%end
variance=0;
while i<=800
variance=variance+(desired_output(i))^2;
%fprintf('\n\n %f \n\n', desired_output(i))
i=i+2;
end
variance=variance/400
fclose(fileid);



fileid = fopen('STAT2.TXT');
i=2;
%while i < 400
desired_output=fscanf(fileid,'%f');

%i=i+1;
%end
variance=0;
while i<=800
variance=variance+(desired_output(i))^2;
%fprintf('\n\n %f \n\n', desired_output(i))
i=i+2;
end
variance=variance/400
fclose(fileid);