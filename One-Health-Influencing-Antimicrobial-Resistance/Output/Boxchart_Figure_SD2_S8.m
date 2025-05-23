clear
clc
load('S8.mat')
Y2 = [S8PdPiPr(2:end,2), S8EdEiEr(2:end,2)];

Y1 = [S8PdPiPr(2:end,1), S8EdEiEr(2:end,1)];

labels = {'PdPiPr', 'EdEiEr'};

% Create a box plot for Y1 (R0[1])
figure 
b1 = boxplot(Y1,'symbol', '');
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
b2 = boxplot(Y2, 'Symbol','');
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
