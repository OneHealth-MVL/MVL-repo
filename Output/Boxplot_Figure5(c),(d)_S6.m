clear
clc
load('S6.mat')
Y2 = [PdPr(2:end,2), PdMr(2:end,2), PdGr(2:end,2), PdEr(2:end,2), MdPr(2:end,2), MdMr(2:end,2),...
     MdGr(2:end,2), MdEr(2:end,2), GdPr(2:end,2), EdPr(2:end,2),  GdMr(2:end,2), EdMr(2:end,2),...
      GdGr(2:end,2), GdEr(2:end,2), EdGr(2:end,2), EdEr(2:end,2)];

Y1 = [PdPr(2:end,1), PdMr(2:end,1), PdGr(2:end,1), PdEr(2:end,1), MdPr(2:end,1), MdMr(2:end,1),...
     MdGr(2:end,1), MdEr(2:end,1), GdPr(2:end,1), EdPr(2:end,1),  GdMr(2:end,1), EdMr(2:end,1),...
      GdGr(2:end,1), GdEr(2:end,1), EdGr(2:end,1), EdEr(2:end,1)];

labels = {'PdPr', 'PdMr', 'PdGr', 'PdEr', 'MdPr', 'MdMr','MdGr', 'MdEr', 'GdPr', 'GdEr',  'GdMr', 'EdMr', 'GdGr', 'GdEr', 'EdGr', 'EdEr'};

% Create a box plot for Y1 (R0[1])
figure 
b1 = boxplot(Y1);
ylabel('Basic Reproduction Number')
ax1 = gca; % Get the current axes
ax1.XTickLabel = labels; % Set x-axis labels
ax1.XTickLabelRotation = 45; % Rotate labels for better visibility

% Setting color and line width for each individual component
color = [0 0 1]; % Blue color
for j = 1:size(b1, 2)
    for i = 1:size(b1, 1)
        set(b1(i,j), 'Color', color, 'LineWidth', 1); % Set line width to 2
    end
end

% Create a box plot for Y2 (R0[2])
figure
b2 = boxplot(Y2);
ylabel('Basic Reproduction Number')
ax2 = gca; % Get the current axes
ax2.XTickLabel = labels; % Set x-axis labels
ax2.XTickLabelRotation = 45; % Rotate labels for better visibility

% Setting color and line width for each individual component
color = [0.6350 0.0780 0.1840]; % Reddish color
for j = 1:size(b2, 2)
    for i = 1:size(b2, 1)
        set(b2(i,j), 'Color', color, 'LineWidth', 1.5); % Set line width to 2
    end
end
