%% Neonatal Visual Cotex Projects (NVCP)
% the research flow of our paper "Development of visual
% cortex in human neonates are selectively modified by postnatal experience"
% doi: https://doi.org/10.1101/2022.03.16.484671 (bioRxiv)
% In fact, this work didn't  generate new algorithm and most codes here
% were the use of other tools such as:
% FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/)
% SPM (https://www.fil.ion.ucl.ac.uk/spm/software/spm12/)
% connectome workbench (https//www.humanconnectome.org/software/connectome-workbench)
% dpabi (http://rfmri.org/dpabi)
% BCT toolbox (https://www.nitrc.org/projects/bct/)
% Therefore, the function contains embedded file path to speed up the analysis instead of a 
% prededinition of data path. 
% We put the codes here to help interested reader understand our processing.
% Meantime, we find this may be a easier way to follow the text methods in the parper. 
%% The main process of this paper as following: 
% dHCP Data preporcessing, surface-based analysis - sturcutre
% Data: dHCP derivatives from release3
% The detailed information of filtered subjects are listed in SubInfo.mat
%% 1. registering individual metrics to the dHCP template (Bozek2018,40w) using MSM-all
Batch01_NVCP_r3_surfreg
%% 2. Calculating morphological measures in the ventral mask
Batch02_NCVP_r3_average_left(right)% averaging surface measures across ages in termed subjects
Batch03_NVCP_r3_anatmicalROIs % Averaging differnt measures in the mask including V34 VOTC, V1
Batch04_NVCP_r3_Prepare_Data % save all data in matlab mat
% the above process wolud output a 32492 * numofsubject matrix per hemisphere;
% then one can do vertex or ROI -based analysis
%% 3. r-fMRI preprocessing
% preporcessing of r-fMRI in the individal space
% crop data to remove high headmotion part
% detrend >> regress nuisance signal and headmotion >> filter 0.01~0.08 HZ
% register volume to template surface(Bozek2018,40w)
Batch05_NVCP_FuncPre
% ROI-based connectivity
Batch06_NVCP_Func_connectivity_v34_bi % V34 left and right >>> 68 * 68 matrix
Batch06_NVCP_Func_connectivity_votc4_bi % V1-VOTC left and right >>> 4 * 4 matrix
% The above process would output ROI-based connectivity matrix in left and righ ventral
% mask and V1-VOTC in right and left hemisphere
%% 4. MDS and clustering analysis
Batch07_NVCP_Func_MDS_cluster % examplar MDS clustering analysis
%% 5. the statistical analysis were based on basic statistical function in matlab
% if you have any question with the method in our paper
% please contact us  
