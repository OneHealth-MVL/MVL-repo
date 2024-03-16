data9 = load('Scenario2_Pi.mat');  data9 = data9.R01TR;
data10 = load('Scenario2_Pi.mat'); data10 = data10.R02TR;
data11 = load('Scenario2_Mi.mat'); data11 = data11.R01TR;
data12 = load('Scenario2_Mi.mat'); data12 = data12.R02TR; 
data13 = load('Scenario2_Gi.mat'); data13 = data13.R01TR;
data14 = load('Scenario2_Gi.mat'); data14 = data14.R02TR;
data15 = load('Scenario2_Ei.mat'); data15 = data15.R01TR;
data16 = load('Scenario2_Ei.mat'); data16 = data16.R02TR;
labels = {'P-R01', 'P-R02', 'M-R01', 'M-R02', 'G-R01', 'G-R02', 'E-R01', 'E-R02'};

% Combine the data into a single matrix where each column is a data vector
allData = [data9, data10, data11, data12, data13, data14, data15, data16];
figure;  % Create a new figure

% Create the boxplots
h = boxplot(allData, 'symbol', ''); 

% Set x-axis labels
set(gca,'xticklabel',labels);

% Make boxplot lines thicker
for ih=1:7  % There are seven lines in a boxplot
    set(h(ih,:),'LineWidth',2);
end

% Define a color, for instance, [0.7 0.2 0.2] for a shade of red
R02Color = [0.7 0.2 0.2];
R02Indices = [2, 4, 6, 8]; % Columns corresponding to R02 in the allData matrix
for index = R02Indices
    set(h(1:6,index), 'Color', R02Color); % There are six elements that make up the box (main body, two whiskers, median line, etc.)
end

xlabel('Scenario2');
ylabel('R_0');

