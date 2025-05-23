clear
clc
load('S5.mat')
Y2 = [PdPi(2:end,2), PdMi(2:end,2), PdGi(2:end,2), PdEi(2:end,2), MdPi(2:end,2), MdMi(2:end,2),...
      GdPi(2:end,2), EdPi(2:end,2), MdGi(2:end,2), MdEi(2:end,2), GdMi(2:end,2), EdMi(2:end,2),...
      GdGi(2:end,2), GdEi(2:end,2), EdGi(2:end,2), EdEi(2:end,2)];

Y1 = [PdPi(2:end,1), PdMi(2:end,1), PdGi(2:end,1), PdEi(2:end,1), MdPi(2:end,1), MdMi(2:end,1),...
      GdPi(2:end,1), EdPi(2:end,1), MdGi(2:end,1), MdEi(2:end,1), GdMi(2:end,1), EdMi(2:end,1),...
      GdGi(2:end,1), GdEi(2:end,1), EdGi(2:end,1), EdEi(2:end,1)];

labels = {'PdPi', 'PdMi', 'PdGi', 'PdEi', 'MdPi', 'MdMi', 'GdPi', 'EdPi', 'MdGi', 'MdEi', 'GdMi', 'EdMi', 'GdGi', 'GdEi', 'EdGi', 'EdEi'};

% Create a box plot for Y1 (R0[1])
figure 
b1 = boxplot(Y1);
ylabel('basic reproduction number')
ax1 = gca; % Get the current axes
ax1.XTickLabel = labels; % Set x-axis labels
ax1.XTickLabelRotation = 45; % Rotate labels for better visibility

% Setting color and line width for each individual component
color = [0 0 1]; % Blue color
for j = 1:size(b1, 2)
    for i = 1:size(b1, 1)
        set(b1(i,j), 'Color', color, 'LineWidth', 1.5); % Set line width to 2
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
