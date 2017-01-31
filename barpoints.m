function [patchcoords,barcoords] = barpoints(nbars,ticks,wbar,gap)
%wbar: relative width of bar, 1 means direct contact between bars of one
%group
%gap: relative gap between GROUP of bars

interv = diff(ticks);
mininterv = min(interv);

if nargin < 3 || isempty(wbar)
%     if isempty(mininterv)
%         wbar = 0.7;
%     else
        wbar = 1;%0.9;
%     end
end
if nargin < 4 || isempty(gap)
    gap = 0.1;
end
mgap = 0.2;
% totalbars = prod(nbars);

% midwin = -(totalbars-1)*1/2:(totalbars-1)*1/2;
midwin = 0;
% midwin = -(nbars(1)-1)*1/2:(nbars(1)-1)*1/2;
totalbars = 1;
for n = 1:numel(nbars)
    totalbars = totalbars * nbars(n);
%    for nn = 1:nbars(n)
%         for nnn = 1:nbars(n-1)
            old = (-(nbars(n)-1)/2:(nbars(n)-1)/2);
            if n > 1
                wbar = wbar *(1-mgap)/numel(midwin);
            end
            midwin = reshape(repmat(midwin',1,numel(old))*(1-mgap)/numel(midwin) + repmat(old,numel(midwin),1),1,totalbars);
            
%         end
%    end
end
if isempty(mininterv) %only one tick
    fac = 1;
else
    fac = (1-gap) * mininterv / (nbars(n)); % factor to reduce bar width if more than one bar has to be fitted in
end


patchcoords = zeros(2,numel(ticks),totalbars);
for t = 1:numel(ticks)
    patchcoords(1,t,:) = ticks(t) + (midwin - wbar/2)*fac;
    patchcoords(2,t,:) = ticks(t) + (midwin + wbar/2)*fac;
end

if nargout > 1
    barcoords(1:2,:,:) = repmat(mean(patchcoords,1),2,1);
    barcoords(3,:,:) = barcoords(1,:,:) + wbar/4*fac;
    barcoords(4,:,:) = barcoords(1,:,:) - wbar/4*fac;
end