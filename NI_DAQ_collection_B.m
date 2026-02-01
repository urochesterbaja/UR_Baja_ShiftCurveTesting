%% Initialize NI Daq device
filename = 'raw_data.csv';
samplingRate = 100000; % set sampling rate
d = daqlist('ni'); % list available data acquisition devices
deviceInfo = d{1,'DeviceInfo'}; % see info about the device
dq = daq('ni');
dq.Rate = samplingRate;
addinput(dq, 'cDAQ1Mod1', 'ai0', 'Voltage');
addinput(dq, 'cDAQ1Mod1', 'ai1', 'Voltage');
 
%% Collect data, graph, and save
% Collect data for a duration of read_time in seconds
read_time = 5; % duration of data collection (seconds)
TT = read(dq, seconds(read_time)); % Read the data
TT.Properties.VariableNames = {'Input1', 'Input2'};

% Save data
fid = fopen(filename, 'w');
rt = seconds(TT.Properties.RowTimes);
M = [rt, TT{:,:}];
writematrix(M, filename);
fclose(fid);

% Graph
t = TT.Time;
s1 = TT.Input1;
s2 = TT.Input2;
tiledlayout(2, 1)

% Top plot
nexttile
plot(t, s1)
title('Input1')
xlabel('Time (s)')
ylabel('Voltage (V)')

% Bottom plot
nexttile
plot(t, s2)
title('Input2')
xlabel('Time (s)')
ylabel('Voltage (V)')

hold off