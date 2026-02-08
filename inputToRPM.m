function [RPM, Time]=inputToRPM(sig)

% CONSTANTS -- Do not change unless you know what these do please!
% -------------------------------------------------------------
samplingRate = 100000;
fitPoints = 100;
%sl = [-2.35, 2.1];
fitType = 'smooth';
% -------------------------------------------------------------

%RPM = tachorpm(sig,samplingRate,'FitPoints', fitPoints, 'StateLevels',sl, 'FitType',fitType);

[RPM, Time] = tachorpm(sig,samplingRate,'FitPoints', fitPoints, 'FitType',fitType);


% binarysig = sigToBinary(sig);
% 
% %look for rising edge of wave.
% %if the difference between the two
% %samples is 1, that means we have found a rising edge!
% edges = find(diff(binarysig) == 1);
% %actual rising edge takes place at the index + 1, so shift over by one
% edge_idx = edges + 1;
% 
% %calculate all of the RPM values.
% %diff computes the difference between two adjacent elements in an
% %array, so it gives the diff erence between the two rising edges of all
% %square waves
% RPM_vals = 60 ./ diff(time(edge_idx));
% 
% %
% RPM = nan(size(time));
% 
% %fill in values between the rising and falling edge of the wave with
% %the value of the rpm. This makes the assumption that the RPM is
% %constant between samples, which is fine as long as we have a high
% %enough sampling rate.
% for i = 1:numel(RPM_vals)
%     RPM(edge_idx(i):edge_idx(i+1)-1) = RPM_vals(i);
% end
% 
