function pfdata = ParseStripChartData(pfname, num_chs)
% ParseStripChartData - Parse a strip chart file generated by strip chart tool.
%
%   pfdata = ParseStripChartData(pfname, num_chs) reads the strip chart file
%   with the name pfname and returns the information in a matrix
%
%   Input:
%       pfname - name of the strip chart file
%       
%       num_chs - number of channels in the strip chart file excluding the
%       date / time (number of channels added to the strip chart tool when
%       set up)
%   
%   Output:
%       pfdata - data recorded in the strip chart file in (# data point x
%       num_chs) matrix format

pattern = ['%s %s'];
for i = 1:1:num_chs
    pattern = [pattern, ' %f'];
end
%%% CHECK IF FILE EXISTS
fid = fopen(pfname, 'r');
if(fid == -1)
    beep;
    error('Cannot open file:\n  %s\n', pfname);
end

lindata = fgetl(fid);
BadVal  = 1;
while ~feof(fid) && BadVal
    lindata = fgetl(fid);
    if isempty(strfind(lindata, 'BadVal'))
        BadVal  = 0;
    end
end

lindata0    = textscan(lindata, pattern);

%%% START READING IN DATA FROM FILE
lindata = textscan(fid, pattern);
fclose(fid);

pfdata  = zeros(length(lindata{1})+1, num_chs);
for i = 1:1:num_chs
    pfdata(:,i)	= [lindata0{i+2}; lindata{i+2}];
end