 %Excel files
fileNames = {'pHI1_pHI2_data_s1-4.xlsx', 'pHI1_pHI2_data_s5.xlsx', 'pHI1_pHI2_data_s6.xlsx', 'pHI1_pHI2_data_s7.xlsx', 'pHI1_pHI2_data_s8.xlsx'};

% vector names for drug-susceptible and drug-resistant strains
vectorNames1 = {'pHI1s1Ed', 'pHI1s1Gd', 'pHI1s1Md', 'pHI1s1Pd',... 
    'pHI1s2Ei', 'pHI1s2Gi', 'pHI1s2Mi', 'pHI1s2Pi',... 
    'pHI1s3E', 'pHI1s3G', 'pHI1s3M', 'pHI1s3P',... 
    'pHI1s4Eeta', 'pHI1s4Geta', 'pHI1s4Meta', 'pHI1s4Peta',...
    'pHI1s5EdEi', 'pHI1s5EdGi', 'pHI1s5EdMi', 'pHI1s5EdPi',...
    'pHI1s5GdEi', 'pHI1s5GdGi', 'pHI1s5GdMi', 'pHI1s5GdPi',...
    'pHI1s5MdEi', 'pHI1s5MdGi', 'pHI1s5MdMi', 'pHI1s5MdPi',...
    'pHI1s5PdEi', 'pHI1s5PdGi', 'pHI1s5PdMi', 'pHI1s5PdPi',...
    'pHI1s6EdEr', 'pHI1s6EdGr', 'pHI1s6EdMr', 'pHI1s6EdPr',...
    'pHI1s6GdEr', 'pHI1s6GdGr', 'pHI1s6GdMr', 'pHI1s6GdPr',... 
    'pHI1s6MdEr', 'pHI1s6MdGr', 'pHI1s6MdMr', 'pHI1s6MdPr',... 
    'pHI1s6PdEr', 'pHI1s6PdGr', 'pHI1s6PdMr', 'pHI1s6PdPr',...
    'pHI1s7EiEr', 'pHI1s7EiGr', 'pHI1s7EiMr', 'pHI1s7EiPr',... 
    'pHI1s7GiEr', 'pHI1s7GiGr', 'pHI1s7GiMr', 'pHI1s7GiPr',... 
    'pHI1s7MiEr', 'pHI1s7MiGr', 'pHI1s7MiMr', 'pHI1s7MiPr',... 
    'pHI1s7PiEr', 'pHI1s7PiGr', 'pHI1s7PiMr', 'pHI1s7PiPr',...
    'pHI1s8EdEiEr', 'pHI1s8PdPiPr'};
vectorNames2 ={'pHI2s1Ed', 'pHI2s1Gd', 'pHI2s1Md', 'pHI2s1Pd',... 
    'pHI2s2Ei', 'pHI2s2Gi', 'pHI2s2Mi', 'pHI2s2Pi',... 
    'pHI2s3E', 'pHI2s3G', 'pHI2s3M', 'pHI2s3P',... 
    'pHI2s4Eeta', 'pHI2s4Geta', 'pHI2s4Meta', 'pHI2s4Peta',...
    'pHI2s5EdEi', 'pHI2s5EdGi', 'pHI2s5EdMi', 'pHI2s5EdPi',...
    'pHI2s5GdEi', 'pHI2s5GdGi', 'pHI2s5GdMi', 'pHI2s5GdPi',...
    'pHI2s5MdEi', 'pHI2s5MdGi', 'pHI2s5MdMi', 'pHI2s5MdPi',...
    'pHI2s5PdEi', 'pHI2s5PdGi', 'pHI2s5PdMi', 'pHI2s5PdPi',...
    'pHI2s6EdEr', 'pHI2s6EdGr', 'pHI2s6EdMr', 'pHI2s6EdPr',...
    'pHI2s6GdEr', 'pHI2s6GdGr', 'pHI2s6GdMr', 'pHI2s6GdPr',... 
    'pHI2s6MdEr', 'pHI2s6MdGr', 'pHI2s6MdMr', 'pHI2s6MdPr',... 
    'pHI2s6PdEr', 'pHI2s6PdGr', 'pHI2s6PdMr', 'pHI2s6PdPr',...
    'pHI2s7EiEr', 'pHI2s7EiGr', 'pHI2s7EiMr', 'pHI2s7EiPr',... 
    'pHI2s7GiEr', 'pHI2s7GiGr', 'pHI2s7GiMr', 'pHI2s7GiPr',... 
    'pHI2s7MiEr', 'pHI2s7MiGr', 'pHI2s7MiMr', 'pHI2s7MiPr',... 
    'pHI2s7PiEr', 'pHI2s7PiGr', 'pHI2s7PiMr', 'pHI2s7PiPr',...
    'pHI2s8EdEiEr', 'pHI2s8PdPiPr'};

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
    
    % Process drug-susceptible data (pHI1)
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
    
    % Process drug-resistant data (pHI2)
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
        % Drug-susceptible data (pHI1)
        line([ciLower1(vecIdx1), ciUpper1(vecIdx1)], [i, i], 'Color', [0, 0, 1], 'LineWidth', 2);
        plot(meanValues1(vecIdx1), i, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 4);
    end
    
    if i <= length(validVecIdx2)
        vecIdx2 = validVecIdx2(i);
        % Drug-resistant data (pHI2)
        line([ciLower2(vecIdx2), ciUpper2(vecIdx2)], [i, i], 'Color', [0, 0, 0], 'LineWidth', 2);
        plot(meanValues2(vecIdx2), i, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4);
    end
end

% Graph customization
set(gca, 'YTick', 1:numScenarios, 'YTickLabel', strrep(vectorNames1(validVecIdx1), 'pHI1', ''));
xlabel('Prevalence of Drug-Susceptible and Drug-Resistant Strains Among Farmworkers');
%ylabel('Scenarios');
%title('Prevalence of Drug-Susceptible and Drug-Resistant Strains');
grid on;
set(gca, 'FontSize', 10);
set(gcf, 'Color', 'w');

% Set x-axis limits to encompass all data
xlim([50 90]); % Adjust as necessary to fit your data

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


