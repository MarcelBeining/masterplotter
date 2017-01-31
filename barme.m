function [p,xposvec,barwidth] = barme(xdata,data,stdev,gstruct,ostruct)
if nargin < 4 %|| isempty(xdata)
    gstruct.col = colorme(numel(data));
    gstruct.group = 1:numel(data);
    gstruct.ugroupdef = {sprintfc('Group %d\n',1:numel(data))};
end
if nargin < 5 || isempty(ostruct)
    ostruct.LineWidth = 1;
end
if ~isfield(ostruct,'gap')
    ostruct.gap = 0.1;
end

if ~isfield(ostruct,'LineWidth')
    ostruct.LineWidth = 1;
end
if ~isfield(ostruct,'wbar')
    ostruct.wbar = 1;
end

[~,allgroups,~,newcol] = getsubgroup(gstruct);

if isempty(xdata)
    xdata = 1:size(allgroups,2);
end
if size(newcol,1) < numel(allgroups(:,1))
    newcol = colorme(numel(allgroups(:,1)))';
    warndlg('Too few colors specified. Replaced by standard colors')
end

[xposvec,barsx] = barpoints(cellfun(@numel,gstruct.ugroupdef),xdata,ostruct.wbar,ostruct.gap);
barwidth = xposvec(2,1,1) - xposvec(1,1,1);
p = zeros(size(allgroups,1),1);
b = zeros(size(allgroups,1),numel(xdata),2);
for g = 1:size(allgroups,1)
    
    p(g) = patch(cat(1,xposvec(:,:,g),flipud(xposvec(:,:,g))),cat(1,zeros(2,numel(xdata)),repmat(data(:,g)',2,1)),newcol{g},'edgecolor','k','linewidth',ostruct.LineWidth);
    %                     b(g,:) = line(barsx(:,:,g),cat(1,data(:,g)',repmat(data(:,g)'+stdev(:,g)'.*sign(data(:,g)'),3,1,1)),'color',edgecolors{gistinf(g)+1},'ostruct.LineWidth',ostruct.ostruct.LineWidth);
    b(g,:,1) = line(barsx(1:2,:,g),cat(1,data(:,g)',data(:,g)'+stdev(:,g,1)'.*sign(data(:,g)')),'color','k','LineWidth',ostruct.LineWidth);
    b(g,:,2) = line(barsx(3:4,:,g),repmat(data(:,g)'+stdev(:,g,1)'.*sign(data(:,g)'),2,1,1),'color','k','LineWidth',ostruct.LineWidth);
end

set(gca,'XTick',(-(numel(gstruct.ugroupdef{end})-1)/2:(numel(gstruct.ugroupdef{end})-1)/2)+1)
set(gca,'XTickLabel',gstruct.ugroupdef{1})