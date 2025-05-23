% Load data for Scenario 1
data1 = load('Scenario1_Pd.mat'); data1 = data1.R01TR.';
data2 = load('Scenario1_Pd.mat'); data2 = data2.R02TR.';
data3 = load('Scenario1_Md.mat'); data3 = data3.R01TR.';
data4 = load('Scenario1_Md.mat'); data4 = data4.R02TR.';
data5 = load('Scenario1_Gd.mat'); data5 = data5.R01TR.';
data6 = load('Scenario1_Gd.mat'); data6 = data6.R02TR.';
data7 = load('Scenario1_Ed.mat'); data7 = data7.R01TR.';
data8 = load('Scenario1_Ed.mat'); data8 = data8.R02TR.';
labels = {'P-R01', 'P-R02', 'M-R01', 'M-R02', 'G-R01', 'G-R02', 'E-R01', 'E-R02'};

% Combine the data into a single matrix where each column is a data vector
allData = [data1, data2, data3, data4, data5, data6, data7, data8];
figure;  
% Create the boxplots
h = boxplot(allData);

set(gca,'xticklabel',labels)

for ih=1:7  % There are seven lines in a boxplot
    set(h(ih,:),'LineWidth',2);
end

% Change color of R02 boxes
% Define a color, for instance, [0.7 0.2 0.2] for a shade of red
R02Color = [0.7 0.2 0.2];
R02Indices = [2, 4, 6, 8]; % Columns corresponding to R02 in the allData matrix
for index = R02Indices
    set(h(1:6,index), 'Color', R02Color); % There are six elements that make up the box (main body, two whiskers, median line, etc.)
end

xlabel('Scenario1');
ylabel('R_0');
hold on;

