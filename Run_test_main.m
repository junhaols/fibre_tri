addpath(genpath('/data/disk2/luojunhao/test0918/code_Fibre_tri_inter_LR.v1.0.0/fibre_tri_fun'))


%% track prepared
% fibre_path='/data/disk2/luojunhao/test0918/subject/100307/track/test_500000.tck'
% savepath='/data/disk2/luojunhao/test0918/subject/100307/track';
% fibre_name='LJH_500000_Terminate'
% 
% g_readTrackEndPoint(fibre_path,1,500000,savepath,fibre_name)

%%

Subject_path='/data/disk2/luojunhao/test0918/subject';

%Subject_IDs='all';
Subject_IDs=100307;
Split_number=10;

Track_type='tck';
Label_name1='L.mask.32K.label';
Label_name2='R.mask.32K.label';
Surface_name1='L.white_MSMAll.32k_fs_LR.surf';
Surface_name2='R.white_MSMAll.32k_fs_LR.surf';
% track_label_name='_LR'

label1_path='/data/disk2/luojunhao/test0918/subject/100307/label/S1200.L.mask.32K.label.gii';
label2_path='/data/disk2/luojunhao/test0918/subject/100307/label/S1200.R.mask.32K.label.gii';
surface1_path='/data/disk2/luojunhao/test0918/subject/100307/surface/100307.L.white_MSMAll.32k_fs_LR.surf.gii'
surface2_path='/data/disk2/luojunhao/test0918/subject/100307/surface/100307.R.white_MSMAll.32k_fs_LR.surf.gii'
threshold_distance=2
ROI_label1=1;
ROI_label2=1;
Track_name='test_500000'
MyJob_Name='TEST_0927_tck'
Result_Name='TEST_2MM_0927_tck3'
Logs_Folder='/data/disk2/luojunhao/test0918/log/log_2mm_0927_tck2'

g_main_fibre2surfROI_interHemiLR_All_SGE(Subject_path,Subject_IDs,Split_number,ROI_label1,ROI_label2,Surface_name1,Surface_name2,Label_name1,Label_name2,Track_type,Track_name,threshold_distance,MyJob_Name,Logs_Folder,Result_Name)

%% sorting results

% ResultantFolder='/data/disk2/luojunhao/test0918/subject/100307/100307TEST_2MM_0927'
% result_path=ResultantFolder;
%  g_sorting_fibre_tri(result_path)

