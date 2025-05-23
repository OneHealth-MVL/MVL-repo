clear
clc
load('S7.mat')
Y2 = [PiPr(2:end,2), PiMr(2:end,2), MiPr(2:end,2),PiGr(2:end,2),MiMr(2:end,2),GiPr(2:end,2)...
    PiEr(2:end,2), MiGr(2:end,2), EiPr(2:end,2), MiEr(2:end,2), GiMr(2:end,2), EiMr(2:end,2)...
     GiEr(2:end,2), GiGr(2:end,2),  EiGr(2:end,2), EiEr(2:end,2)];

Y1 = [PiPr(2:end,1), PiMr(2:end,1), MiPr(2:end,1),PiGr(2:end,1), MiMr(2:end,1),GiPr(2:end,1)...
    PiEr(2:end,1),MiGr(2:end,1),EiPr(2:end,1), MiEr(2:end,1), GiMr(2:end,1), EiMr(2:end,1)...
     GiEr(2:end,1), GiGr(2:end,1),  EiGr(2:end,1), EiEr(2:end,1)];

labels = {'PiPr', 'PiMr', 'MiPr','PiGr', 'MiMr','GiPr','PiEr', 'MiGr','EiPr', 'MiEr', 'GiMr', 'EiMr','GiEr', 'GiGr',  'EiGr', 'EiEr'};

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
