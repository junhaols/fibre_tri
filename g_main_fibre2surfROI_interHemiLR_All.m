function g_main_fibre2surfROI_interHemiLR_All(SubjectID,label1_path,ROI_label1,label2_path,ROI_label2,surface1_path,surface2_path,fibre_path,start_index,end_index,threshold_distance,ResultantFolder)
%%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% This function is used to caculate the intersection between fibes connecting left and right cortical surface.
%  The endpoints of the fibres should locate at left and right hemispheres.The input variable "fibreLR_label" 

%% It caculate the intersection by 'Dist'.(Distance)

%inputs:
% *SubjectID:A subject ID.
% *label1_path:
%                        ROI parcellation mask.The different integer number
%                        represent different ROI.The format of this file
%                        should be "xxxx.gii" with field 'cdata'.
%                        
%                        
%
% *ROI_label1:
%                       The selectd ROI label value about the first surface
%                       it can also be a matrix.When it set as 'all',the
%                       whole surface will be considered including medial
%                       wall vertices.
%
% *label2_path:
%                       Be samiliar to "label1_path".
%
% *ROI_label2:
%                       Be samiliar to "ROI_label1".
%
% *surface1_path:
%                       The path of the left surface file:"xxxx.gii".
%
% *surface2_path:
%                       The path of the right surface file:"xxxx.gii".
%
% *fibre_path:
%                       the path of the fibre files:"xxxx.tck",or "xxxx.txt".
% *start_index:The start index of the fibre.
% *end_index:The end index of the fibre.
%
% * threshold_distance:
%                       The selected distance,if the distance between the endpoint of the ray and the intersection is less than
%                       the  threshold_distance,the fibre will be selectded.

% * fibreLR_label:
%                       The location information about the endpoints of the fibre.(12 or 21) "12" means that the head of the fibre is in left hemi and the ending of the fibre is in right hemi.                       

% *ResultantFolder:
%                       the file path to restore the results.

%% Outputs
%  A fibre_tri structure.
%              filed: fibre_tri_LR:The fibres come across left and right surface.(InterLR hemi)
%
%                               N*5 matrix:
%                                       column1:fibre_index
%                                       column2:LVert_index
%                                       column3:LDist
%                                       column4:RVert_index
%                                       column5:RDist
%              filed: fibre_tri_LL:The fibres come across left and left surface.[IntraLL hemi]
%                                       
%                                       column1:fibre_index
%                                       column2:LVert_index1
%                                       column3:LDist1
%                                       column4:LVert_index2
%                                       column5:LDist2
%              filed: fibre_tri_RR:The fibres come across right and right surface.[IntraRR hemi]
%
%                                       column1:fibre_index
%                                       column2:RVert_index1
%                                       column3:RDist1
%                                       column4:RVert_index2
%                                       column5:RDist2
%              

%% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
tic
 if nargin >= 12
    if ~exist(ResultantFolder, 'dir')
        mkdir(ResultantFolder);
    end
 end
 
fibre_start_index_dist=start_index-1;%the index interval of the original data and the selected data.

 
 %% judge the input pf the fibre format.
 [~,~,file_suffix]=fileparts(fibre_path);

 if strcmp(file_suffix,'.tck')
    [~,~,fibre_data1,fibre_data2]=g_read_mrtrix_tracks_pieces(fibre_path,start_index,end_index);
 end
 
%  if strcmp(file_suffix,'.mat')
%      tracks=load(fibre_path);
%      fibre_coord=tracks.Terminate;
%      
%    
%      for i=1:end_index-start_index+1
%          fibre_data1{1,i}(1,:)=fibre_coord(i+fibre_start_index_dist,1:3);
%          %fibre_data1{1,i}(2,:)=fibre_coord(i+fibre_start_index_dist,4:6);
%          fibre_data2{1,i}(1,:)=fibre_coord(i+fibre_start_index_dist,10:12);
%          fibre_data2{1,i}(2,:)=fibre_coord(i+fibre_start_index_dist,7:9);
%      end
%  end 

 
  if strcmp(file_suffix,'.txt')
     fibre_coord=load(fibre_path);
   
     for i=1:end_index-start_index+1
         fibre_data1{1,i}(1,:)=fibre_coord(i+fibre_start_index_dist,1:3);
         %fibre_data1{1,i}(2,:)=fibre_coord(i+fibre_start_index_dist,4:6);
         fibre_data2{1,i}(1,:)=fibre_coord(i+fibre_start_index_dist,4:6);
         %fibre_data2{1,i}(2,:)=fibre_coord(i+fibre_start_index_dist,7:9);
     end
  end 
 

 %% Surface data and extracted ROI data.

 %the first surface
 surft1=gifti(surface1_path);
 Vert1_all=surft1.vertices;
 %Fac1=surft1.faces; 

 label1=gifti(label1_path);
 label_value1=round(label1.cdata);

Vert1_index=g_extract_surfROI_vert(surface1_path,label_value1,ROI_label1);
 
 %Get the vertice coordinates.
 Vert1=Vert1_all(Vert1_index,:);

 %the second surface
 surft2=gifti(surface2_path);
 Vert2_all = surft2.vertices;
 %Fac2 = surft2.faces; 
 
 label2=gifti(label2_path);
 label_value2=round(label2.cdata);
 
Vert2_index=g_extract_surfROI_vert(surface2_path,label_value2,ROI_label2);
 %Get the vertice coordinates.
Vert2=Vert2_all(Vert2_index,:);



%% vertice
Vert=zeros(length(Vert1)+length(Vert2),3);
Vert(1:length(Vert1_index),:)= Vert1;
Vert(length(Vert1)+1:length(Vert2_index)+length(Vert1),:)=Vert2;

%% data1
   
 %orig_fibre_index=start_index:end_index;
 new_fibre_index=1:end_index-start_index+1;

 [fibre1,vertice1]=g_intersect_fibre2surfROI_Dist(Vert,new_fibre_index,fibre_data1,threshold_distance);
 
%% data2
 for i=1:length(fibre1)
    fibre_data12{1,i}(:,:)=fibre_data2{1,fibre1(i)}(:,:);% Set fibre_data as cell format.
 end
 
 [fibre12,vertice12]=g_intersect_fibre2surfROI_Dist(Vert,fibre1,fibre_data12,threshold_distance);
 
 [fibre_index,ia,ib]=intersect(fibre1,fibre12);%% fibre_index=fibre12
 
 vertice_1=vertice1(ia,:);
 vertice_2=vertice12(ib,:);
 
 vertice=zeros(length(fibre_index),10);
 
 %% left ---right

 % initial 
 fibre_tri_LR=[];
 fibre_tri_LL=[];
 fibre_tri_RR=[]; 
 index_lr=1;
 index_ll=1;
 index_rr=1;
 
for i=1:length(fibre_index)
    if vertice_1(i,1)<=length(Vert1) && vertice_2(i,1)>length(Vert1) % LR
%         vertice(i,1:5)=vertice_1(i,:);
%         vertice(i,6:10)=vertice_2(i,:);
%         % subtract length(Vert1) 
%         vertice(i,6)=vertice(i,6)-length(Vert1);
        
        fibre_tri_LR(index_lr,1)=fibre_index(i);% fibre_index
        fibre_tri_LR(index_lr,2)=vertice_1(i,1);% L-vert-index
        fibre_tri_LR(index_lr,3)=vertice_1(i,2);% L-dist
        fibre_tri_LR(index_lr,4)=vertice_2(i,1)-length(Vert1);% R-vert-index in RIGHT surf
        fibre_tri_LR(index_lr,5)=vertice_2(i,2); % R-dist
        index_lr=index_lr+1;
    elseif vertice_1(i,1)>length(Vert1) && vertice_2(i,1)<=length(Vert1) % RL (Restored as LR)
%         vertice(i,1:5)=vertice_2(i,:);
%         vertice(i,6:10)=vertice_1(i,:);
%         vertice(i,6)=vertice(i,6)-length(Vert1);
%         
        fibre_tri_LR(index_lr,1)=fibre_index(i);% fibre_index
        fibre_tri_LR(index_lr,2)=vertice_2(i,1);% L-vert-index
        fibre_tri_LR(index_lr,3)=vertice_2(i,2);% L-dist
        fibre_tri_LR(index_lr,4)=vertice_1(i,1)-length(Vert1);% R-vert-index in RIGHT surf
        fibre_tri_LR(index_lr,5)=vertice_1(i,2); % R-dist
        index_lr=index_lr+1;
        
        
    elseif vertice_1(i,1)<=length(Vert1) && vertice_2(i,1)<=length(Vert1) % LL
        fibre_tri_LL(index_ll,1)=fibre_index(i);% fibre_index
        fibre_tri_LL(index_ll,2)=vertice_1(i,1);% L-vert-index
        fibre_tri_LL(index_ll,3)=vertice_1(i,2);% L-dist
        fibre_tri_LL(index_ll,4)=vertice_2(i,1);% L-vert-index in LIGHT surf
        fibre_tri_LL(index_ll,5)=vertice_2(i,2); % L-dist
        index_ll=index_ll+1;
    else                                                                % RR
        fibre_tri_RR(index_rr,1)=fibre_index(i);% fibre_index
        fibre_tri_RR(index_rr,2)=vertice_1(i,1)-length(Vert1);% R-vert-index
        fibre_tri_RR(index_rr,3)=vertice_1(i,2);% R-dist
        fibre_tri_RR(index_rr,4)=vertice_2(i,1)-length(Vert1);% R-vert-index in RIGHT surf
        fibre_tri_RR(index_rr,5)=vertice_2(i,2); % R-dist
        index_rr=index_rr+1;
        
    end
end
% All the index have beed added 1,so we should sbutract it 
sum_index=index_lr-1+index_ll-1+index_rr-1;

if sum_index==length(fibre_index)
    disp('good');
else
    error('There is something wrong,pleae check your results.');
end



%% Return the orignal fibre_index and left right vertice index.

if ~isempty(fibre_tri_LR)

   
   fibre_index=fibre_index+fibre_start_index_dist;
   fibre_tri_LR(:,1)=fibre_tri_LR(:,1)+fibre_start_index_dist;
 
   fibre_tri_LR(:,2)=Vert1_index(fibre_tri_LR(:,2));
   fibre_tri_LR(:,4)=Vert2_index(fibre_tri_LR(:,4));
   
end

if ~isempty(fibre_tri_LL)
  

   fibre_tri_LL(:,1)=fibre_tri_LL(:,1)+fibre_start_index_dist;
   fibre_tri_LL(:,2)=Vert1_index(fibre_tri_LL(:,2));
   fibre_tri_LL(:,4)=Vert1_index(fibre_tri_LL(:,4));
   
end


if ~isempty(fibre_tri_RR)
  
   fibre_tri_RR(:,1)=fibre_tri_RR(:,1)+fibre_start_index_dist;
   fibre_tri_RR(:,2)=Vert2_index(fibre_tri_RR(:,2));
   fibre_tri_RR(:,4)=Vert2_index(fibre_tri_RR(:,4));
   
end
if ~ischar(SubjectID)
    SubjectID=num2str(SubjectID);
end

if nargin >= 12
        fibre_tri_path=fullfile(ResultantFolder,[SubjectID,'_fibre_tri_',num2str(start_index),'_',num2str(end_index),'.mat']);
        
        save(fibre_tri_path, 'fibre_tri_LR','fibre_tri_LL','fibre_tri_RR');
end
  
 toc 

