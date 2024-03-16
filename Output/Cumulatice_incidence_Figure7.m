 %Excel files
fileNames = {'cI1_cI2_data_s1-4.xlsx', 'cI1_cI2_data_s5.xlsx', 'cI1_cI2_data_s6.xlsx', 'cI1_cI2_data_s7.xlsx', 'cI1_cI2_data_s8.xlsx'};

% vector names for drug-susceptible and drug-resistant strains
vectorNames1 = {'cI1s1Ed', 'cI1s1Gd', 'cI1s1Md', 'cI1s1Pd', 'cI1s2Ei', 'cI1s2Gi', 'cI1s2Mi', 'cI1s2Pi',...
               'cI1s3E', 'cI1s3G', 'cI1s3M', 'cI1s3P', 'cI1s4Eeta', 'cI1s4Geta', 'cI1s4Meta', 'cI1s4Peta',...
               'cI1s5EdEi','cI1s5EdGi', 'cI1s5EdMi', 'cI1s5EdPi', 'cI1s5GdEi', 'cI1s5GdGi', 'cI1s5GdMi', 'cI1s5GdPi',...
               'cI1s5MdEi', 'cI1s5MdGi', 'cI1s5MdMi', 'cI1s5MdPi', 'cI1s5PdEi', 'cI1s5PdGi', 'cI1s5PdMi', 'cI1s5PdPi',...
               'cI1s6EdEr', 'cI1s6EdGr', 'cI1s6EdMr', 'cI1s6EdPr', 'cI1s6GdEr', 'cI1s6GdGr', 'cI1s6GdMr', 'cI1s6GdPr',...
               'cI1s6MdEr', 'cI1s6MdGr', 'cI1s6MdMr', 'cI1s6MdPr', 'cI1s6PdEr', 'cI1s6PdGr', 'cI1s6PdMr', 'cI1s6PdPr',...
               'cI1s7EiEr', 'cI1s7EiGr', 'cI1s7EiMr', 'cI1s7EiPr', 'cI1s7GiEr', 'cI1s7GiGr', 'cI1s7GiMr', 'cI1s7GiPr',...
               'cI1s7MiEr', 'cI1s7MiGr', 'cI1s7MiMr', 'cI1s7MiPr', 'cI1s7PiEr', 'cI1s7PiGr', 'cI1s7PiMr', 'cI1s7PiPr',...
               'cI1s8EdEiEr', 'cI1s8PdPiPr'};
vectorNames2 ={'cI2s1Ed', 'cI2s1Gd', 'cI2s1Md', 'cI2s1Pd', 'cI2s2Ei', 'cI2s2Gi', 'cI2s2Mi', 'cI2s2Pi',...
               'cI2s3E', 'cI2s3G', 'cI2s3M', 'cI2s3P', 'cI2s4Eeta', 'cI2s4Geta', 'cI2s4Meta', 'cI2s4Peta',...
               'cI2s5EdEi','cI2s5EdGi', 'cI2s5EdMi', 'cI2s5EdPi', 'cI2s5GdEi', 'cI2s5GdGi', 'cI2s5GdMi', 'cI2s5GdPi',...
               'cI2s5MdEi', 'cI2s5MdGi', 'cI2s5MdMi', 'cI2s5MdPi', 'cI2s5PdEi', 'cI2s5PdGi', 'cI2s5PdMi', 'cI2s5PdPi',...
               'cI2s6EdEr', 'cI2s6EdGr', 'cI2s6EdMr', 'cI2s6EdPr', 'cI2s6GdEr', 'cI2s6GdGr', 'cI2s6GdMr', 'cI2s6GdPr',...
               'cI2s6MdEr', 'cI2s6MdGr', 'cI2s6MdMr', 'cI2s6MdPr', 'cI2s6PdEr', 'cI2s6PdGr', 'cI2s6PdMr', 'cI2s6PdPr',...
               'cI2s7EiEr', 'cI2s7EiGr', 'cI2s7EiMr', 'cI2s7EiPr', 'cI2s7GiEr', 'cI2s7GiGr', 'cI2s7GiMr', 'cI2s7GiPr',...
               'cI2s7MiEr', 'cI2s7MiGr', 'cI2s7MiMr', 'cI2s7MiPr', 'cI2s7PiEr', 'cI2s7PiGr', 'cI2s7PiMr', 'cI2s7PiPr',...
               'cI2s8EdEiEr', 'cI2s8PdPiPr'};

% Initialize arrays for mean values and confidence intervals
meanValues1 = zeros(1, length(vectorNames1));
ciLower1 = zeros(1, length(vectorNames1));
ciUpper1 = zeros(1, length(vectorNames1));
meanValues2 = zeros(1, length(vectorNames2));
ciLower2 = zeros(1, length(vectorNames2));
ciUpper2 = zeros(1, length(vectorNames2));

validVecIdx1 = []; % For drug-susceptible
validVecIdx2 = []; % For drug-resistant

% Process the data from the files
for fileIdx = 1:length(fileNames)
    data = readtable(fileNames{fileIdx});
    
    % Process drug-susceptible data (CI1)
    for vecIdx = 1:length(vectorNames1)
        if ismember(vectorNames1{vecIdx}, data.Properties.VariableNames)
            vector = data.(vectorNames1{vecIdx});
            [meanVal, ciLower, ciUpper] = processVectorData(vector);
            meanValues1(vecIdx) = meanVal;
            ciLower1(vecIdx) = ciLower;
            ciUpper1(vecIdx) = ciUpper;
            if (ciUpper - ciLower) >= 0.5
                validVecIdx1 = [validVecIdx1, vecIdx];
            end
        end
    end
    
    % Process drug-resistant data (CI2)
    for vecIdx = 1:length(vectorNames2)
        if ismember(vectorNames2{vecIdx}, data.Properties.VariableNames)
            vector = data.(vectorNames2{vecIdx});
            [meanVal, ciLower, ciUpper] = processVectorData(vector);
            meanValues2(vecIdx) = meanVal;
            ciLower2(vecIdx) = ciLower;
            ciUpper2(vecIdx) = ciUpper;
            if (ciUpper - ciLower) >= 0.5
                validVecIdx2 = [validVecIdx2, vecIdx];
            end
        end
    end
end

% Create the combined graph
figure; hold on;

% Determine the total number of scenarios to plot
numScenarios = max(length(validVecIdx1), length(validVecIdx2));

% Plotting for both drug-susceptible and drug-resistant data
for i = 1:numScenarios
    if i <= length(validVecIdx1)
        vecIdx1 = validVecIdx1(i);
        % Drug-susceptible data (CI1)
        line([ciLower1(vecIdx1), ciUpper1(vecIdx1)], [i, i], 'Color', [0, 0, 1], 'LineWidth', 2);
        plot(meanValues1(vecIdx1), i, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 4);
    end
    
    if i <= length(validVecIdx2)
        vecIdx2 = validVecIdx2(i);
        % Drug-resistant data (CI2)
        line([ciLower2(vecIdx2), ciUpper2(vecIdx2)], [i, i], 'Color', [0, 0, 0], 'LineWidth', 2);
        plot(meanValues2(vecIdx2), i, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4);
    end
end

% Graph customization
set(gca, 'YTick', 1:numScenarios, 'YTickLabel', strrep(vectorNames1(validVecIdx1), 'cI1', ''));
xlabel('Cumulative Incidence of Drug-Susceptible and Drug-Resistant Strains in Cattle Population');
%ylabel('Scenarios');
%title('Prevalence of Drug-Susceptible and Drug-Resistant Strains');
grid on;
set(gca, 'FontSize', 10);
set(gcf, 'Color', 'w');

% Set x-axis limits to encompass all data
xlim([20 70]); % Adjust as necessary to fit your data

hold off;

% Function to process vector data and calculate confidence intervals
function [meanVal, ciLower, ciUpper] = processVectorData(vector)
    meanVal = mean(vector);
    ciLower = 0;
    ciUpper = 0;
    if length(vector) > 1
        confInterval = tinv(0.975, length(vector) - 1) * std(vector) / sqrt(length(vector));
        ciLower = meanVal - confInterval;
        ciUpper = meanVal + confInterval;
    end
end

