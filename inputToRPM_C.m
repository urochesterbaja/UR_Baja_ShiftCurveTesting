    function [RPM, firstIndex]=inputToRPM_C(time, sig, samplingRate)
    siglength = length(sig);
    
    lastStart = time(1);
    
    
    high = max(sig);
    low = min(sig);
    
    %TODO: Replace this with schmitt trigger or something else like a
    %kalman filter
    %For now, calculates the midpoint between the min and max value in the
    %data
    threshold = (high + low) / 2;

    %converts the square wave into a binary signal by setting any value
    %greater than the threshold to 1, and any value less than to 0.
    binarysig = sig > threshold;

    %IDK TBH but it didnt work without it, something to do with the types
    %in the matrix, shrug
    binarysig = logical(binarysig);
    
    %look for rising edge of wave.
    %if the difference between the two
    %samples is 1, that means we have found a rising edge!
    edges = find(diff(binarysig) == 1);
    %actual rising edge takes place at the index + 1, so shift over by one
    edge_idx = edges + 1;
    
    firstIndex = 1;
    
    %calculate all of the RPM values.
    %diff computes the difference between two adjacent elements in an
    %array, so it gives the diff erence between the two rising edges of all
    %square waves
    RPM_vals = 60 ./ diff(time(edge_idx));
    
    %
    RPM = nan(size(time));
    
    %fill in values between the rising and falling edge of the wave with
    %the value of the rpm. This makes the assumption that the RPM is
    %constant between samples, which is fine as long as we have a high
    %enough sampling rate.
    for i = 1:numel(RPM_vals)
        RPM(edge_idx(i):edge_idx(i+1)-1) = RPM_vals(i);
    end

% diff = linspace(0,0,siglength);
% error = (abs(high) + abs(low)) * 0.25;
% firstIndex = 0;
% allowNewStart = 0;
% 
% for i = 1:siglength
%     cur = time(i);
%     % signal = sig(i)
% 
%     if ((allowNewStart == 1) && (sig(i) - error < low)) %start seen
% 
%         %disp("ern... this happened" + cur + ", " + lastStart)
%         diff(i) = cur - lastStart;
%         %disp(diff(i))
%         lastStart = cur;
%         allowNewStart = 0;
%         if firstIndex == 0
%             firstIndex = i;
%         end
% 
%     elseif ((sig(i) + error > high)) %stop seen
%         allowNewStart = 1;
%         if i > 1
%             diff(i) = diff(i-1);
%         end
% 
%     else
%         if i > 1
%             diff(i) = diff(i-1);
%         end
% 
%     end
% 
% end
% 
%     RPM = 60.*1./diff;
%     %RPM = RPM ./ samplingRate .* 10^5;
% 
% end