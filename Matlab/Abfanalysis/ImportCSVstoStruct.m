function abf = ImportCSVstoStruct(mainfolder, savename)
%ImportCSVstoStruct import csv metadatatables created by
%   xAbfMetadataParallel script. convert tables to structures and restore
%   nested hierarchical order.
%
%   mainfolder is the path to the folder containing the necessary
%   subfolders: Abffiles, Channels, Analogins, Sweeps, Epochs and
%   Actionpotentials. which all contain the corresponding CSV file with similar name.
%   for instance: mainfolder contains a subfolder Abffiles which contains
%   Abffiles.csv

%   savename is the filename of the .mat file containing the resulting
%   struct to be saved

%   Written by Djai Heyer

%% import CSV files
abfs = table2struct(CSVimportabfs(fullfile(mainfolder, 'Abffiles','Abffiles.csv'))) ;
channels = table2struct(CSVimportchannels(fullfile(mainfolder, 'Channels','Channels.csv'))) ;
ins = table2struct(CSVimportins(fullfile(mainfolder, 'Analogins','Analogins.csv'))) ;
sweeps = table2struct(CSVimportsweeps(fullfile(mainfolder, 'Sweeps','Sweeps.csv'))) ;
epochs = table2struct(CSVimportepochs(fullfile(mainfolder, 'Epochs','Epochs.csv'))) ;
aps = table2struct(CSVimportaps(fullfile(mainfolder, 'Actionpotentials','Actionpotentials.csv'))) ;

%% Create nested structure
for i = 1:length(epochs)    
        epochs(i).ap = aps([aps.parent_guid] == epochs(i).guid) ;    
end

for i = 1:length(sweeps)    
        sweeps(i).epoch = epochs([epochs.guid_swp] == sweeps(i).guid) ;    
end

for i = 1:length(ins)    
        ins(i).sweep = sweeps([sweeps.guid_in] == ins(i).guid) ;    
end

for i = 1:length(channels)    
        channels(i).in = ins([ins.guid_channel] == channels(i).guid) ;    
end

for i = 1:length(abfs)    
        abfs(i).channel = channels([channels.guid_abf] == abfs(i).guid) ;    
end

abf = abfs ;
%% Save struct
save(fullfile(mainfolder, savename), 'abf') ;

end

%% Import functions
function Abffiles = CSVimportabfs(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   ABFFILES = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   ABFFILES = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   Abffiles = importfile('Abffiles.csv', 2, 5);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2017/10/10 13:44:46

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format for each line of text:
%   column1: text (%s)
%	column2: datetimes (%{yyyy-MM-dd HH:mm:ss.SSSSSS}D)
%   column3: datetimes (%{dd-MMM-yyyy HH:mm:ss}D)
%	column4: text (%s)
%   column5: text (%s)
%	column6: text (%s)
%   column7: text (%s)
%	column8: double (%f)
%   column9: datetimes (%{HH:mm:ss.SSSSSS}D)
%	column10: datetimes (%{yyyy-MM-dd HH:mm:ss.SSSSSS}D)
%   column11: datetimes (%{yyyy-MM-dd HH:mm:ss.SSSSSS}D)
%	column12: text (%s)
%   column13: text (%s)
%	column14: text (%s)
%   column15: text (%s)
%	column16: double (%f)
%   column17: datetimes (%{HH:mm:ss}D)
%	column18: double (%f)
%   column19: text (%s)
%	column20: text (%s)
%   column21: double (%f)
%	column22: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%{yyyy-MM-dd HH:mm:ss.SSSSSS}D%{dd-MMM-yyyy HH:mm:ss}D%s%s%s%s%f%{HH:mm:ss.SSSSSS}D%{yyyy-MM-dd HH:mm:ss.SSSSSS}D%{yyyy-MM-dd HH:mm:ss.SSSSSS}D%s%s%s%s%f%{HH:mm:ss}D%f%s%s%f%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
Abffiles = table(dataArray{1:end-1}, 'VariableNames', {'guid_batch','fileconversiondate','filesystemdate','filename','filedirectory','filetype','fileversion','filesize','fileduration','filetimestart','filetimeend','datadimorderstr','proname','prodirectory','operationmodestr','samplefreq','stopwatchtime','nrofsweeps','userid','setupsettingsname','nrofchannels','guid'});

% For code requiring serial dates (datenum) instead of datetime, uncomment
% the following line(s) below to return the imported dates as datenum(s).

% Abffiles.fileconversiondate=datenum(Abffiles.fileconversiondate);
% Abffiles.filesystemdate=datenum(Abffiles.filesystemdate);
% Abffiles.fileduration=datenum(Abffiles.fileduration);
% Abffiles.filetimestart=datenum(Abffiles.filetimestart);
% Abffiles.filetimeend=datenum(Abffiles.filetimeend);
% Abffiles.stopwatchtime=datenum(Abffiles.stopwatchtime);

end

function Channels = CSVimportchannels(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   CHANNELS = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   CHANNELS = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   Channels = importfile('Channels.csv', 2, 5);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2017/10/10 14:05:36

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format for each line of text:
%   column1: text (%s)
%	column2: text (%s)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%f%f%f%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
Channels = table(dataArray{1:end-1}, 'VariableNames', {'guid_abf','filename','number','nrofanalogins','nrofanalogouts','guid'});

end

function Analogins = CSVimportins(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   ANALOGINS = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   ANALOGINS = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   Analogins = importfile('Analogins.csv', 2, 5);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2017/10/10 14:23:41

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: text (%s)
%	column4: text (%s)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: text (%s)
%	column14: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%s%s%f%f%f%f%f%f%f%f%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
Analogins = table(dataArray{1:end-1}, 'VariableNames', {'guid_channel','number','adcusername','units','telegraphenabled','telegraphinstrument','gain','lowpassfilter','instrumentscalefactor','protocollag','samplefreq','nrofsweeps','signal','guid'});

end

function Sweeps = CSVimportsweeps(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   SWEEPS = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   SWEEPS = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   Sweeps = importfile('Sweeps.csv', 2, 79);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2017/10/10 14:37:47

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format for each line of text:
%   column1: double (%f)
%	column2: text (%s)
%   column3: double (%f)
%	column4: double (%f)
%   column5: text (%s)
%	column6: text (%s)
%   column7: text (%s)
%	column8: text (%s)
%   column9: text (%s)
%	column10: double (%f)
%   column11: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%s%f%f%s%s%s%s%s%f%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
Sweeps = table(dataArray{1:end-1}, 'VariableNames', {'number','guid_in','nrofepochs','sweeplagpnts','sweeplagtime','guid','datetimestart','datetimeend','timespan','nrofaps','Name'});

end

function Epochs = CSVimportepochs(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   EPOCHS = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   EPOCHS = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   Epochs = importfile('Epochs.csv', 2, 391);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2017/10/10 14:44:27

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: text (%s)
%	column4: text (%s)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: text (%s)
%   column13: text (%s)
%	column14: text (%s)
%   column15: double (%f)
%	column16: datetimes (%{HH:mm:ss.SSSSSSS}D)
%   column17: double (%f)
%	column18: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%s%s%f%f%f%f%f%f%f%s%s%s%f%{HH:mm:ss.SSSSSSS}D%f%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
Epochs = table(dataArray{1:end-1}, 'VariableNames', {'guid_swp','number','idxstr','typestr','stepdiff','tau','steadystate','steadystate_diff','sag','rinput','vstep','guid','datetimestart','datetimeend','samplefreq','timespan','nrofaps','Name'});

% For code requiring serial dates (datenum) instead of datetime, uncomment
% the following line(s) below to return the imported dates as datenum(s).

% Epochs.timespan=datenum(Epochs.timespan);

end

function Actionpotentials = CSVimportaps(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   ACTIONPOTENTIALS = IMPORTFILE(FILENAME) Reads data from text file
%   FILENAME for the default selection.
%
%   ACTIONPOTENTIALS = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data
%   from rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   Actionpotentials = importfile('Actionpotentials.csv', 2, 1742);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2017/10/10 14:46:54

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
%	column16: double (%f)
%   column17: double (%f)
%	column18: double (%f)
%   column19: double (%f)
%	column20: double (%f)
%   column21: double (%f)
%	column22: double (%f)
%   column23: double (%f)
%	column24: double (%f)
%   column25: double (%f)
%	column26: double (%f)
%   column27: double (%f)
%	column28: double (%f)
%   column29: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
Actionpotentials = table(dataArray{1:end-1}, 'VariableNames', {'parent_guid','start_time','end_time','peak','peak_time','ahp','ahp_time','relahp','adp','adp_time','reladp','thresh','thresh_time','amp','halfwidth','halfwidth_strt_time','halfwidth_end_time','maxdvdt','maxdvdt_time','mindvdt','mindvdt_time','onsetrapidity','onsetrapfit_1','onsetrapfit_2','onsetrapvm','isi','freq','number','guid'});

end










