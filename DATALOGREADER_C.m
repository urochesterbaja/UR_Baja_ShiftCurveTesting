% BAJA ELECTRONICS DATA AQ THING
% This code takes input of a single csv file in the format of:
%    (time since teensy code started, primary, secondary)

% It then plots the inputs over time and plots a shift curve.

datalog = readmatrix("raw_data.csv"); % edit "file"
time = datalog(:,1);
%seconds = time.*1E-6;
sig1 = (datalog(:,2));
sig2 = (datalog(:,3));

noise_std = 0.2 * (max(sig1) - min(sig1));
noise = noise_std * randn(size(sig1));

sig1_noisy = sig1 + noise;

% [RPM1] = inputToRPM_C(time, sig1);
[RPM1] = inputToRPM_C(sig1);
[RPM2] = inputToRPM_C(sig2);
[RPM1_Noisy] = inputToRPM_C(sig1_noisy);

% First, we plot the two inputs to make sure that our inputs make sense
f = figure(1);
hold on
plot(time, RPM1);
plot(time, RPM2);

%xlim([11 30])
ylabel("RPM");
xlabel("Time (seconds)");
title("Individual RPM plots");
legend(["Primary", "Secondary"], location='northeast');
hold off
hold on
grid on

% Convert units and convert from counts -> frequency
% 
% Note - with new teensy code, these units most likely need to change (or
% we need to do more post processing on it, as the points no longer
% automatically subtract)
% 
% plot(time,RPM1);
% plot(time,RPM2);

ylabel("RPM");
xlabel("Time (seconds)");
title("Individual RPM plots");
legend(["Input 1", "Input2"], location='northeast');
hold off


% REDUCTION = 0.8;
% MPH = RPM2 .* REDUCTION

REDUCTION = 7.41;
MPH = (RPM2 ./REDUCTION) .* 5.75 .* 60 ./ 5280;


% Now we plot the shift curve, the secondary plotted over the primary.
f2 = figure(2);
hold on
grid on
plot(MPH, RPM1);
title("Shift Curve?")
%ylim([0, 200]);
ylabel("RPM 1")
xlabel("MPH")
hold off