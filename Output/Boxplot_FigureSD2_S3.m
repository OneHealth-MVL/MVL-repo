data17 = load('Scenario3_P.mat'); data17 = data17.R01TR.';
data18 = load('Scenario3_P.mat'); data18 = data18.R02TR.';
data19 = load('Scenario3_M.mat'); data19 = data19.R01TR.';
data20 = load('Scenario3_M.mat'); data20 = data20.R02TR.';
data21 = load('Scenario3_G.mat'); data21 = data21.R01TR.';
data22 = load('Scenario3_G.mat'); data22 = data22.R02TR.';
data23 = load('Scenario3_E.mat'); data23 = data23.R01TR.';
data24 = load('Scenario3_E.mat'); data24 = data24.R02TR.';
labels = {'P-R01', 'P-R02', 'M-R01', 'M-R02', 'G-R01', 'G-R02', 'E-R01', 'E-R02'};

% Combine the data into a single matrix where each column is a data vector
allData = [data17, data18, data19, data20, data21, data22, data23, data24];

figure; 

% Create the boxplots
h = boxplot(allData, 'symbol', '');

set(gca,'xticklabel',labels)

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

xlabel('Scenario 3');
ylabel('R_0');
