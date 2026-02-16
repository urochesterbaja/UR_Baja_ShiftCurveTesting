% BAJA ELECTRONICS DATA AQ THING
% This code takes input of a single csv file where each row is in the
% following format:
% [CVT Primary Sensor Voltage, CVT Secondary Sensor Voltage]

% Plots the inputs over time and a shift curve.

samplingRate = 10000;

% gets the most recently modified file
% not perfect, but for quick viewing, this is recommended.
d = dir('Data/Teensy/*.csv');
[~, index] = max([d.datenum]);
youngestFile = fullfile(d(index).folder, d(index).name);

datalog = readmatrix(youngestFile);

% datalog = readmatrix("Data/Teensy/raw_data_teensy_newwwww.csv"); % edit "file"

sig1 = (datalog(:,1));
sig2 = (datalog(:,2));

% noise_std = 0.2 * (max(sig1) - min(sig1));
% noise = noise_std * randn(size(sig1));
% 
% sig1_noisy = sig1 + noise;

[RPM1, Time1] = inputToRPM(sig1, samplingRate);
[RPM2, Time2] = inputToRPM(sig2, samplingRate);

% cutting off the first/last 0.5 secodnds of data, since polynomial fit has
% weird effects. This is mainly so that the graph looks good and scaling
% doesnt get thrown off.
cutoff = (samplingRate/2);
RPM1 = RPM1(cutoff:end - cutoff);
RPM2 = RPM2(cutoff:end - cutoff);
Time1 = Time1(cutoff:end - cutoff);
Time2 = Time2(cutoff:end - cutoff);

% Plot RPMs of primary and secondary vs time
f = figure(1);
hold on
plot(Time1, RPM1);
plot(Time2, RPM2);

ylabel("RPM");
xlabel("Time (seconds)");
title("Individual RPM plots");
legend(["Primary", "Secondary"], location='northeast');
grid on
hold off


% REDUCTION = 0.8;
% MPH = RPM2 .* REDUCTION

% Plot secondary vs primary RPM. 
% Tons of magic numbers loosely based on real car to get
% secondary RPM --> MPH,
% but can always remove and just plot RPM vs RPM.
REDUCTION = 7.41;
MPH = (RPM2 ./REDUCTION) .* 5.75 .* 60 ./ 5280;

f2 = figure(2);
hold on
plot(MPH, RPM1);

ylabel("RPM 1")
xlabel("MPH")
title("Shift Curve!")
grid on
hold off