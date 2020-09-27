# Fibre_tri tool description
      This functions are used to calculate the intersections between fibre endpoints and surface vertices.
      When a distance threshold is set,if the distance between the fibre's endpoint and a vertice is less
      than the distance threshold,then the fibre and the vertice are choosed.
      
# Advantage about this tool
      It's a surface based tool to calculate the intersections between fibre endpoints and surface vertices 
      so that the intersection between them are more precise.
      It can not only surport the cortical surface but also the necleus surface.
      It can read any pieces of the endpoints of a fibre,so it can reduce memory and accelerate speed.
      It can use psom packge,a pipeline system for Matlab for parallel computing.
      It can split the fibre to different suitable pieces for reducing memory.
      It can be applied to different databases.
      It is sample to learn to use.
    
# Environment requirements
     Matlab
     psom-1.0.4 or high version.(https://www.nitrc.org/projects/psom/)
     gifti-1.6 or high version.(https://github.com/gllmflndn/gifti)
     If you want to use ".tck" fibre as the fibre input,the software Mrtrix(https://www.mrtrix.org/) is needed.
     If you use the function "g_readTrackEndPoint.m" that is in the direction "ReadTrack" to
     save the endpoints of the fibre in a txt file,the software Mrtrix is not necessary.(Recommend)
     Mrtrix.()
# Applicable scene
     This tool is used to calculate the intersections between fibre endpoints and surface vertices and 
     the surface is cortical surface while the nucleus surface will be surported in next version.
     The surface file should be like "xxx.gii",so if your surface is not the gifti fomat,please convert
     it to the gifti.
     The fibre file can be like "xxxx.tck" or "xxx.txt".It is recommended that restore the fibre endpoint 
     in a txt file to reduce memory and accelerate speed.
     The label file which contain the ROI information should also be a gifti format.
     Please see the funtion for detail.
# A demo
     addpath(genpath('/data/disk2/luojunhao/test0918/code_Fibre_tri_inter_LR.v1.0.0/fibre_tri_fun')) % Add the tool package to the matlab path.

      # It is optional.Restore the fibre endpoints to a txt file.
      %% track prepared
      % fibre_path='/data/disk2/luojunhao/test0918/subject/100307/track/test_500000.tck'
      % savepath='/data/disk2/luojunhao/test0918/subject/100307/track';
      % fibre_name='LJH_500000_Terminate'
      % g_readTrackEndPoint(fibre_path,1,500000,savepath,fibre_name)
      ## function inputs
      Subject_path='/data/disk2/luojunhao/test0918/subject'; %Subject direction that contain all subjects.
      Subject_IDs=100307; % Subject ID
      Split_number=10;% Split the fibre to 10 pieces for reducing memory and accelerating speed.
      ROI_label1=1; % ROI label value
      ROI_label2=1; % ROI label value
      Surface_name1='L.white_MSMAll.32k_fs_LR.surf'; % The key words of the left surface file for seacrhing the surface file.
      Surface_name2='R.white_MSMAll.32k_fs_LR.surf'; % The key words of the right surface file for seacrhing the surface file.
      Label_name1='L.mask.32K.label'; % The key words of the left label file for seacrhing the label file.
      Label_name2='R.mask.32K.label'; % The key words of the right label file for seacrhing the label file.
      Track_type='tck ; % The input track is tck file.
      Track_name='test_500000'; % The key words of the track file for seacrhing the track file.
      threshold_distance=2; % The threshold distance.
      MyJob_Name='TEST_0927_tck'; % The job name for parcell caiculating.
      Logs_Folder='/data/disk2/luojunhao/test0918/log/log_2mm_0927_tck2'; % The log folder.
      Result_Name='TEST_2MM_0927_tck'; % The result folder to restore the results. 
      ## function command
      g_main_fibre2surfROI_interHemiLR_All_SGE(Subject_path,Subject_IDs,Split_number,ROI_label1,ROI_label2,Surface_name1,Surface_name2,Label_name1,Label_name2,Track_type,...
      Track_name,threshold_distance,MyJob_Name,Logs_Folder,Result_Name)

      ## sorting results
      ResultantFolder='/data/disk2/luojunhao/test0918/subject/100307/100307_TEST_2MM_0927_tck'
      result_path=ResultantFolder;
      g_sorting_fibre_tri(result_path)
      
## Copyright
      @copyright Junhao Luo
      Beijing Normal University
      201731430026@mail.bnu.edu.cn
      

     
     

     
     
     

     
     
