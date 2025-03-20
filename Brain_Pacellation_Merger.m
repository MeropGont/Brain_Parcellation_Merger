%% Merging Lausanne 2018 and CERES Parcellations
% This script combines the Lausanne2018 (with >1000 nodes) and the cerebellar
% parcellation (obtained from the CERES pipeline, including 26 lobule volumes)
% into a unified atlas in a robust manner.

% Author: Fatemeh Sadeghi & Jakub Vohryzek
% Date: November 2022


%% Clear previous data and close all figures
clc;
clear;

% Set Paths and Subject List
% Define the base directory where data is stored
pathname = 'C:\Users\Sadeg\Documents\GitHub\4_Model_Deco\parcellation\L2018_cerebellum_merge\';

% Input: Define the list of subjects
% Example: Subjects 101-104
sub_list = num2str([101:104].', '%02d');  % Convert numeric IDs to string format

% Alternatively, process a single subject
sub_list = {'106'};  % Use cell format for consistency

%% Combine Parcellations for Each Subject
for i = 1:numel(sub_list)
    % Extract subject ID
    sub_ID = string(sub_list(i));
    folder_name = strcat('sub-', sub_ID);
    
    % Create necessary directories for logging and storing results
    mkdir([pathname, 'logs\', folder_name]);
    mkdir([pathname, 'combined\', folder_name]);

    %% Load the Cerebellum Atlas
    atlas = 'cerebellum';
    scale = 'scale1';
    
    % Define the path to the cerebellum parcellation file
    data_path = strcat(pathname, 'data\', 'sub-', sub_ID, '\', ...
                       'sub-', sub_ID, '_atlas-', atlas, '_res-', scale, '_dseg.nii.gz');
    
    % Read cerebellum NIfTI file
    info_cerebellum = niftiinfo(data_path);
    V_cerebellum = niftiread(info_cerebellum);

    %% Load the Cortical Atlas (Lausanne 2018)
    atlas = 'L2018';
    scale = 'scale5';
    
    % Define the path to the cortical parcellation file
    data_path = strcat(pathname, 'data\', 'sub-', sub_ID, '\', ...
                       'sub-', sub_ID, '_atlas-', atlas, '_res-', scale, '_dseg.nii.gz');
    
    % Read cortical NIfTI file
    info_cortex = niftiinfo(data_path);
    V_cortex = niftiread(info_cortex);

    %% Validate Labels
    % Extract unique labels from each atlas
    unique_cerebellum_labels = unique(V_cerebellum);
    unique_cortex_labels = unique(V_cortex);

    % Log total number of labels in each atlas
    log_file = strcat(pathname, 'logs\', folder_name, '\', 'sub-', sub_ID, '_log.txt');
    fileID = fopen(log_file, 'w');
    
    fprintf(fileID, 'Log created on: %s\n', datestr(datetime("today")));
    fprintf(fileID, 'Number of Lausanne 2018 labels: %d\n', numel(unique_cortex_labels));
    fprintf(fileID, 'Number of Cerebellum labels: %d\n', numel(unique_cerebellum_labels));
    fclose(fileID);

    %% Convert to Double Precision for Processing
    V_cerebellum = double(V_cerebellum);
    V_cortex = double(V_cortex);

    %% Standardize Cerebellar Labels (Re-index from 1 to 26)
    % Remove background label (first element)
    unique_cerebellum_labels(1) = [];

    % Renumber cerebellar labels sequentially
    for j = 14:length(unique_cerebellum_labels)
        V_cerebellum(V_cerebellum == unique_cerebellum_labels(j)) = j;
        unique_cerebellum_labels(j) = j;
    end

    %% Relabel Cerebellar Regions from 1059 Onward
    for j = 1:length(unique_cerebellum_labels)
        V_cerebellum(V_cerebellum == unique_cerebellum_labels(j)) = 1058 + j;
    end

    %% Check for Overlapping Regions
    overlapping_regions = intersect(V_cerebellum, V_cortex);
    if ~isempty(overlapping_regions)
        error("Overlap detected between Lausanne2018 and Cerebellum regions!");
    end

    % Log overlapping labels count
    fileID = fopen(log_file, 'a');
    fprintf(fileID, 'Number of overlapping labels: %d\n', numel(overlapping_regions));
    fclose(fileID);

    %% Merge the Two Atlases
    % Override overlapping cortex values with cerebellum regions
    V_cortex(V_cerebellum > 0) = 0;
    
    % Combine cortical and cerebellar atlases into one
    V_brain = int16(V_cortex + V_cerebellum);
    unique_brain_labels = unique(V_brain);

    % Log total number of labels in merged atlas
    fileID = fopen(log_file, 'a');
    fprintf(fileID, 'Number of total labels in combined atlas: %d\n', numel(unique_brain_labels));
    fclose(fileID);

    %% Save Combined Atlas as NIfTI
    combined_atlas = 'LC';  % Combined Lausanne2018 & Cerebellum
    res_path = strcat(pathname, 'combined\', folder_name, '\sub-', sub_ID, ...
                      '_atlas-', combined_atlas, '_res-', scale, '_dseg');

    niftiwrite(V_brain, res_path, info_cortex, 'Compressed', true);

    % Log completion message
    fileID = fopen(log_file, 'a');
    fprintf(fileID, 'Process finished for subject: %s\n', sub_ID);
    fclose(fileID);

    % Clear variables for next subject iteration
    clearvars -except pathname sub_list;
end

%% Generate Unique Hexadecimal Color Codes for Labels
% Define the output path for color labels
color_label_path = fullfile(pathname, 'tsv', 'color_labels.csv');

% Generate a shuffled sequence of numbers (1 to 1085)
randomized_labels = randperm(1085);

% Convert numbers to 6-digit hexadecimal format
hex_codes = strcat('#', dec2hex(randomized_labels, 6));

% Save the generated hex color codes as a CSV file
writematrix(hex_codes, color_label_path);

%% End of Script
disp('Processing complete. Combined atlases saved.');
