function g_main_fibre2surfROI_interHemiLR_All_SGE(Subject_path,Subject_IDs,Split_number,ROI_label1,ROI_label2,Surface_name1,Surface_name2,Label_name1,Label_name2,Track_type,Track_name,threshold_distance,MyJob_Name,Logs_Folder,Result_Name)

%% The nain function of caculating the intersection.If you want to run with SGE,you can focus on this function only.



%% The catalogue structure of the input files ought to be listed as follows:(of course, the folder name can be flexible.)
%Subject
%    subject1
%        surface:('Should name it as "xxxx_L.surf.gii,xxxx_R.surf.gii",or you will modify the regular expression';)
%        fibre
%        label:('Should name it as "xxxxLxxx.gii,xxxxRxxx.gii",or you will modify the regular expression';)
%       
%    subject2
%        surface
%        fibre
%        label
%       
%
%    ......


%% Main input:
% *Subject_path:The subject path,which conclude the structure as above.
% *Subject_IDs:
%        'all or 'All':All subjects will be calculated.
%        For special subject,set it as a matrix of subject id.
% *Split_number:It controls how many partitions the fibre is divided into.
% *ROI_label1:The selectd ROI label value about the first surface,it can
%             also be a matrix.If you want to caculate the entire surface,you can set it as the string 'all'.

% *ROI_label2:The selectd ROI label value about the second surface,it can 
%             also be a matrix.If you want to caculate the entire surface,you can set it as the string 'all'.
% *Surface_name1:The key words of a left surface file .Eg:Surface_name1='L.white_MSMAll.32k_fs_LR';(Surface file:100307.white_MSMAll_32kfs_L.surf.gii)
%
% *Surface_name2:The key words of a right surface file.Eg:Surface_name1='L.white_MSMAll.32k_fs_LR';(Surface file:100307.white_MSMAll_32kfs_L.surf.gii)
% *Label_name1:The key words of a left label file.
% *Label_name2:The key words of a right label file.
% *Track_type
%            'txt':Fibre endpoints restored in the txt file.See the
%                  function g_readTrackEndPoint.m for detail.(Recommend)
%            'tck':The orignal tck fibre.
% *Track_name:The key words of the fibre.
                
% *Threshold_distance:
%                       The selected distance,if the distance between the endpoint of the ray and the intersection is less than
%                       the Threshold_distance,the fibre will be
%                       selected.
% *MyJob_Name:The SGE job name.
% *Logs_Folder:The folder to restore the log files.
% *Result_Name:The name about the result.

%% Subject_path='/home/luojunhao/project/Musician';


% Pipeline_opt.mode = 'qsub';                            
% Pipeline_opt.qsub_options ='-q long -l nodes=01:ppn=10';
% Pipeline_opt.mode_pipeline_manager = 'batch';
% Pipeline_opt.max_queued = 100;
% Pipeline_opt.flag_verbose = 0;
% Pipeline_opt.flag_pause = 0;
% Pipeline_opt.path_logs = [Logs_Folder];


% Pipeline_opt.mode = 'qsub';                            
% Pipeline_opt.qsub_options =['-V -q long -l nodes=1:ppn=4'];

%[Caculate_method,Subject_path,Subject_IDs,ROI_label1,ROI_label2,Label_name1,Label_name2,Surface_name1,Surface_name2,Track_type,Split_number,Threshold_distance,Logs_Folder,Pipeline_Mode,Qsub_Opt,MyJob_Name,Result_Name] = parseInputs(varargin);

%% Notice
disp('LJH-FibreSurfTriTool.v.1.0.0')
disp('-----------------------------------------------------------------------------------------------------------------------------------------------------------------------')
disp('Before running,please make sure all the packages needed are concluded in the matlab environment.');
disp(' ')
disp('Please check the directory structure and it is recommended that all the fibre endpoints be restored in a text file such as "Terminate.txt" ');
disp('  ')
disp('Directory Structure：');
disp('  ')
disp('           100307');
disp('                 surface');
disp('                 track');
disp('                 label');
disp('           ')
disp('           100408');
disp('                 surface');
disp('                 track');
disp('                 label');
disp('           ...');
disp(' ');
disp('For saving time and storage memory,it is recommended all the fibre enpoints be restored in a text file.See the function g_readTrackEndPoint.m for detail. ');
disp(' ')
disp('If you want to use the orignal "xxx.tck" fibre file as a input,make sure the software Mrtrix has been installed to ensure the command "tckinfo" can be runned.')
disp('-----------------------------------------------------------------------------------------------------------------------------------------------------------------------')



%% SGE paramesters
psom_gb_vars


Pipeline_opt.mode = 'qsub'; 
Pipeline_opt.qsub_options ='-V -q short -l nodes=1:ppn=4';

%Pipeline_opt.mode_pipeline_manager = 'batch';
Pipeline_opt.max_queued = 10;
Pipeline_opt.flag_verbose = 0;
Pipeline_opt.flag_pause = 0;

%Logs_Folder=[Subject_path filesep 'HCP_pt_pt'];

Pipeline_opt.path_logs = [Logs_Folder]; 

if ~exist(Logs_Folder,'dir')
    mkdir(Logs_Folder)
end

%% LOG
command_window_log= [Logs_Folder,'/',Result_Name,'_command_window_log.txt'];

diary (command_window_log);
diary on

%%

%Pipeline_opt.path_logs =  [Logs_Folder];

%Job_Name=cell(length(subject),n);
%% subject-track info
subject=g_ls([Subject_path '/*']);
if strcmp(Track_type,'txt')
    if exist([Logs_Folder '_trackno'],'file')==0 
        for k=1:length(subject)
            if isdir(subject{k})
                [~,subjid]=fileparts(subject{k});
                %system(['echo ' subjid ' $(cat ' subject{k} '/track/' subjid  '_Terminate.txt|wc -l)>>' Logs_Folder '_trackno']);
                system(['echo ' subjid ' $(cat ' subject{k} '/track/*' Track_name '*.txt|wc -l)>>' Logs_Folder '_trackno']);

            else
                disp([subjid,' is empty!']);
                continue;
            end
        end
    end
    trackno = load([Logs_Folder '_trackno']);
    fibreNum=trackno(:,2);% The total fibre number
    PRE_SubjectID=trackno(:,1); %Subject ID
    
elseif strcmp(Track_type,'tck')
    if exist([Logs_Folder '_trackno1.txt'],'file')==0 
        fid=fopen([Logs_Folder '_trackno1.txt'],'a');

            for k=1:length(subject)
                if isdir(subject{k})
                    [~,subjid]=fileparts(subject{k});
                    fibre_path=cell2mat(g_ls([subject{k} '/track/*' Track_name '*.tck']));
                    fibre_num=g_tckinfo(fibre_path);
                    fprintf(fid,'%s %s\n',subjid,num2str(fibre_num));
                    %system(['echo ' subjid ' $(cat ' subject{k} '/track/' subjid  '_Terminate.txt|wc -l)>>' Logs_Folder '_trackno']);
                    %system(['echo ' subjid ' >> ' Logs_Folder '_trackno1']);
                else
                    disp([subjid,' is empty!']);
                    continue;
                end
            end
    end
    trackno1 = load([Logs_Folder '_trackno1.txt']);
    fibreNum=trackno1(:,2);% The total fibre number
    PRE_SubjectID=trackno1(:,1); %Subject ID
    
end

disp('The subject information has been restored in matrix "PRE_SubjectID" ');


if strcmp(Subject_IDs,'all') || strcmp(Subject_IDs,'All') 
   disp([num2str(length(PRE_SubjectID)),' subjects will be calculated...']);
end

if ismember(Subject_IDs,PRE_SubjectID)
    PRE_SubjectID=Subject_IDs;
    disp([num2str(length(PRE_SubjectID)),' subjects will be calculated...']);
end

if isempty(Subject_IDs) 
    disp('<Subject_IDs> shouled be set,"all","All" or the integer number of subject id')
    error('<Subject_IDs> is empty,please set the "Subject_IDs" paramester.');
end

for j=1:length(PRE_SubjectID)
  
    SubjectDir =Subject_path;
    SubjectID=num2str(PRE_SubjectID(j));
    
    disp(['Start: ', SubjectID, ' is submitted...,total fibre number: ',num2str(fibreNum(j)), '. All fibres will be splited into ',num2str(Split_number),' pieces,please wait for a while.']);
    
     ResultantFolder=[SubjectDir filesep SubjectID '/' SubjectID '_' Result_Name];
     if ~exist(ResultantFolder, 'dir')% dir:List the files
            mkdir(ResultantFolder);% mkdir:creat a filefolder;
     end
     
    %% Get fibre_path and the number of fibre.
        switch Track_type   
              
              case 'txt'
                  fibre=cell2mat(g_ls([SubjectDir filesep SubjectID '/track/*' Track_name '.*txt']));
                  
                  if isempty(fibre)
                      disp(SubjectID);
                      continue;
                  else

                      fibre_path=fibre;
                      track_number=fibreNum(j);
                      if Split_number>track_number
                        error('The "spilt_number" should not be greater than the "fibre_number",please input a "Split_number again"!')
                      end

                  end
                  
              case 'tck'
                   fibre=cell2mat(g_ls([SubjectDir filesep SubjectID '/track/*' Track_name '.*tck']));
                   fibre_path=fibre;
                   track_number=fibreNum(j);
                 
                    if Split_number>track_number
                        error('The "spilt_number" should not be greater than the "fibre_number",please input a "Split_number again"!')
                    end
             otherwise
                    error('Please input "Track_type":"txt" or "tck".');
        end
        
   %% the label and surface files
     
        
        label1_path=cell2mat(g_ls([SubjectDir filesep SubjectID '/label/*' Label_name1 '*.gii']));
        label2_path=cell2mat(g_ls([SubjectDir filesep SubjectID '/label/*' Label_name2 '*.gii']));
        surface1_path=cell2mat(g_ls([SubjectDir filesep SubjectID '/surface/*' Surface_name1 '*.gii']));
        surface2_path=cell2mat(g_ls([SubjectDir filesep SubjectID '/surface/*' Surface_name2 '*.gii']));
        

    %            
       
        for i=1:Split_number; % eg:1M fibre divided into 100 parts

            Job_Name = [MyJob_Name '_' SubjectID '_' num2str(i)];% It can be modifed as you like.

            %% Split the fibre into pieces.

            if mod(track_number,Split_number)==0
                interval=track_number/Split_number;
                start_index=interval*(i-1)+1;%
                end_index=interval*i;
            else
                interval=ceil(track_number/Split_number);
                if (track_number-interval*i>=0) 

                    start_index=interval*(i-1)+1;
                    end_index=interval*i;
                else
                    start_index=interval*(i-1)+1;
                    end_index=track_number;
                end
            end

        

            Pipeline.(Job_Name).command   = 'g_main_fibre2surfROI_interHemiLR_All(opt.parameters1, opt.parameters2,opt.parameters3, opt.parameters4, opt.parameters5, opt.parameters6,opt.parameters7,opt.parameters8,opt.parameters9,opt.parameters10,opt.parameters11,opt.parameters12)';
  
            Pipeline.(Job_Name).opt.parameters1 = SubjectID;
            Pipeline.(Job_Name).opt.parameters2 = label1_path;
            Pipeline.(Job_Name).opt.parameters3=  ROI_label1;
            Pipeline.(Job_Name).opt.parameters4 = label2_path;
            Pipeline.(Job_Name).opt.parameters5 = ROI_label2;
            Pipeline.(Job_Name).opt.parameters6 = surface1_path;
            Pipeline.(Job_Name).opt.parameters7 = surface2_path;
            Pipeline.(Job_Name).opt.parameters8 = fibre_path;
            Pipeline.(Job_Name).opt.parameters9 = start_index;
            Pipeline.(Job_Name).opt.parameters10 = end_index;
            Pipeline.(Job_Name).opt.parameters11 = threshold_distance;
            Pipeline.(Job_Name).opt.parameters12 = ResultantFolder;
            
           if j==1
                disp('Please check the inputs of the first subject.');
                disp(['The ',num2str(i) 'th pieces of the fibre.']);
                disp(['SubjectID:  ',SubjectID]);
                disp(['label1_path:  ',label1_path]);
                disp(['ROI_label1:  ',num2str(ROI_label1)]);
                disp(['label2_path:  ',label2_path]);
                disp(['ROI_label2:  ',num2str(ROI_label2)]);
                disp(['surface1_path:  ',surface1_path]);
                disp(['surface2_path:  ',surface2_path]);
                disp(['fibre_path:  ',fibre_path]);
                disp(['start_index:  ',num2str(start_index)]);
                disp(['end_index:  ',num2str(end_index)]);
                disp(['threshold_distance:  ',num2str(threshold_distance)]);
                disp(['ResultantFolder:  ',num2str(ResultantFolder)]);
                disp('   ')
            end
        
           
               
        end 
        
        %% Check the first subject inputs
        
         
     disp(['Keep going: ', SubjectID, ' has been submitted']);
   
                
end

psom_run_pipeline(Pipeline,Pipeline_opt);
 
disp(['Good! All the subjects have been submitted.']);

diary off
 
 
