% BAJA ELECTRONICS DATA AQ THING
% This code takes input of a single csv file where each row is in the
% following format:
% [CVT Primary Sensor Voltage, CVT Secondary Sensor Voltage]

% Plots the inputs over time and a shift curve.

samplingRate = 10000;


%gets the file with most recent timestamp in name
%not perfect, but for quick viewing, this is recommended.
d = dir('Data/Teensy/*.csv');
names = {d.name};

% Regex for: CVT_Shift_YYYY-MM-DD-HH-MM-SS.csv
pattern = '^CVT_Shift_\d{4}-\d{2}-\d{2}_\d{2}-\d{2}\.csv$';

% Keep only matching filenames
validMask = ~cellfun(@isempty, regexp(names, pattern, 'once'));
d = d(validMask);

if isempty(d)
    error('No valid timestamped files found.');
end

% Sort alphabetically (chronological)
[~, idx] = sort({d.name});

youngestFile = fullfile(d(idx(end)).folder, d(idx(end)).name);

datalog = readmatrix(youngestFile);

% datalog = readmatrix("Data/Teensy/raw_data_SHIFT_CURVE.csv"); % edit "file"


%bruh column 1 is the secondary and column 2 is primary
sig1 = (datalog(:,2));
% sig1 = sig1 .* 16.5;
sig2 = (datalog(:,1));

% signal matrix, sampling rate, pulses per revolution, fit type
[RPM1, Time1] = inputToRPM(sig1, samplingRate, 1, 'linear');
[RPM2, Time2] = inputToRPM(sig2, samplingRate, 2, 'linear');
 
% cutting off the first/last 0.5 secodnds of data, since polynomial fit has
% weird effects. This is mainly so that the graph looks good and scaling
% doesnt get thrown off.
% cutoff = (samplingRate/2);
% RPM1 = RPM1(cutoff:end - cutoff);
% RPM2 = RPM2(cutoff:end - cutoff);
% Time1 = Time1(cutoff:end - cutoff);
% Time2 = Time2(cutoff:end - cutoff);


%10, 27.1
%37, 60

startTime = 10;
endTime = 27.1;
index = startTime*samplingRate:endTime*samplingRate;

RPM1 = RPM1(index);
RPM2 = RPM2(index);
Time1 = Time1(index);
Time2 = Time2(index);


% Plot RPMs of primary and secondary vs time
f = figure(1);
hold on
plot(Time1, RPM1);
plot(Time2, RPM2);

ylabel("RPM");
xlabel("Time (seconds)");
title("Individual RPM plots");
legend(["Primary", "Secondary"], location='northeast');
ylim([0 5000]);
grid on
hold off


% REDUCTION = 0.8;
% MPH = RPM2 .* REDUCTION

% Plot secondary vs primary RPM. 
% Tons of magic numbers loosely based on real car to get
% secondary RPM --> MPH,
% but can always remove and just plot RPM vs RPM.
% REDUCTION = 7.41;
% MPH = (RPM2 ./REDUCTION) .* 5.75 .* 60 ./ 5280;
MPH = RPM2;

f2 = figure(2);
hold on
plot(MPH, RPM1);

ylabel("RPM 1")
xlabel("MPH")
title("Shift Curve!")
grid on
hold off

% answer = inputdlg("DID IT WORK?");
% 
% if answer == "yes"
%     [y, Fs] = audioread("Free Bird Solo.mp3");
%     sound(y, Fs);
% else
%     [y, Fs] = audioread("Womp.mp3");
%     sound(y, Fs);
% end
