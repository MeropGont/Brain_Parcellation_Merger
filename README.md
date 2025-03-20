# Brain_Parcellation_Merger
This repository contains a MATLAB pipeline for merging the Lausanne2018 parcellation (with over 1000 cortical nodes) and the cerebellar parcellation from the CERES pipeline (26 lobule volumes) into a unified brain atlas. The script ensures robust label handling, prevents region overlap, and logs the merging process for quality control.
Combining Lausanne2018 Cortical and CERES Cerebellar Parcellations into a Unified Atlas
Authors: Fatemeh Sadeghi & Jakub Vohryzek
Date: November 2022
________________________________________
Overview
This repository provides a MATLAB pipeline for merging two widely used brain parcellations:
1.	Lausanne2018 Atlas – A high-resolution cortical parcellation with over 1000 nodes.
2.	CERES Cerebellar Atlas – A cerebellar parcellation consisting of 26 lobule volumes.
The script ensures a robust and accurate integration of these atlases by:
•	Loading and validating individual subject parcellations.
•	Standardizing label assignments to avoid conflicts.
•	Merging the two atlases while preserving anatomical integrity.
•	Logging key processing steps for quality control.
•	Generating unique hexadecimal color codes for visualization.
This approach allows researchers to work with a single, unified brain atlas that integrates both cortical and cerebellar structures in a consistent manner.
________________________________________
Repository Structure
graphql
KopierenBearbeiten
Lausanne2018-CERES-Merger/
│── data/                      # Input data directory (expected structure)
│   ├── sub-XXX/               # Individual subject folders
│   │   ├── sub-XXX_atlas-L2018_res-scale5_dseg.nii.gz   # Lausanne2018 parcellation
│   │   ├── sub-XXX_atlas-cerebellum_res-scale1_dseg.nii.gz  # CERES cerebellum
│── logs/                      # Logs directory (auto-generated)
│   ├── sub-XXX/               # Logs for each subject
│   │   ├── sub-XXX_log.txt    # Log file with label statistics
│── combined/                   # Output directory (auto-generated)
│   ├── sub-XXX/               # Combined parcellation results for each subject
│   │   ├── sub-XXX_atlas-LC_res-scale5_dseg.nii.gz  # Merged atlas
│── tsv/                        # Color label storage
│   ├── color_labels.csv        # Generated hex color codes
│── merge_parcellations.m       # Main MATLAB script for merging
│── README.md                   # Documentation (this file)
________________________________________
Requirements
Software
•	MATLAB (Tested on R2022a and later)
•	Image Processing Toolbox (for handling NIfTI files)
MATLAB Functions Used
•	niftiread(), niftiinfo(), niftiwrite()
•	mkdir(), fopen(), fclose(), fprintf()
•	unique(), intersect(), randperm(), dec2hex()
________________________________________
Usage
Input Data Format
The script expects subject-specific parcellation files stored in the following structure:
bash
KopierenBearbeiten
data/sub-XXX/
Required Files:
•	Lausanne2018 Parcellation: 
lua
KopierenBearbeiten
sub-XXX_atlas-L2018_res-scale5_dseg.nii.gz
•	CERES Cerebellar Parcellation: 
lua
KopierenBearbeiten
sub-XXX_atlas-cerebellum_res-scale1_dseg.nii.gz
Running the Script
1.	Open MATLAB and navigate to the repository directory.
2.	Modify the subject list (sub_list) in merge_parcellations.m as needed.
3.	Run the script: 
matlab
KopierenBearbeiten
merge_parcellations
Processing Steps
1.	Load Data – Reads NIfTI parcellation files for Lausanne2018 and CERES.
2.	Validate Labels – Extracts unique labels and checks for inconsistencies.
3.	Standardize Labeling – Assigns sequential numbering to cerebellar labels.
4.	Check Overlaps – Ensures no cortical and cerebellar regions share labels.
5.	Merge Atlases – Integrates Lausanne2018 and CERES into a unified atlas.
6.	Save Outputs – Stores merged atlases and logs processing details.
7.	Generate Color Codes – Creates unique hexadecimal colors for visualization.
________________________________________
Output Files
Logs
Each subject's processing details are recorded in:
bash
KopierenBearbeiten
logs/sub-XXX/sub-XXX_log.txt
This file includes the number of labels, any detected overlaps, and completion status.
Merged Atlas (NIfTI format)
The unified parcellation is saved in:
bash
KopierenBearbeiten
combined/sub-XXX/sub-XXX_atlas-LC_res-scale5_dseg.nii.gz
Color Labels (CSV format)
A file containing unique hex color codes for visualization:
bash
KopierenBearbeiten
tsv/color_labels.csv
________________________________________
Example Log Output
yaml
KopierenBearbeiten
Log created on: 20-Mar-2025
Number of Lausanne 2018 labels: 1015
Number of Cerebellum labels: 26
Number of overlapping labels: 0
Number of total labels in combined atlas: 1085
Process finished for subject: 106
________________________________________
Visualization
The merged atlas can be visualized using standard neuroimaging tools that support the NIfTI format:
•	FreeSurfer (freeview)
•	FSLeyes
•	MRIcron
•	MATLAB (volshow)
For color mapping, use color_labels.csv to assign unique colors to each label.
________________________________________
Troubleshooting
Error: "Overlap detected between Lausanne2018 and Cerebellum regions!"
Cause: Label overlap due to incorrect preprocessing.
Solution: Ensure the original Lausanne2018 and CERES files are correctly preprocessed before merging.
Error: "File not found: sub-XXX_atlas-cerebellum_res-scale1_dseg.nii.gz"
Cause: Missing input data.
Solution: Verify that all required subject parcellation files exist in the /data/ directory.
________________________________________
Contributing
Contributions are welcome. If you have suggestions or improvements, please open an issue or submit a pull request.
________________________________________
License
This project is licensed under the MIT License. See the LICENSE file for details.
________________________________________
Contact
For any questions or issues, please use the GitHub Issues section.
