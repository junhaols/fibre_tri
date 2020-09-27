function Fac_Vert_index=g_extract_surfROI_vert(surface,label_value,roi_label,ResultantFolder)
% inputs:
%
% *label_value:
%                     the label value of all the vertices;
%
% *roi_label:
%                     the selected roi label value.eg:roi_label=5;if it is a matrix,all the aparted ROI will be treated as a big ROI.
% *surface:
%                     the file road of the surface files. eg:'XXXXX.gii'.
%
% *ResultantFolder:
%                     the file path storing the results.
%
%returns:
%* Fac_Vert_index:

%                        All the vertice index of the ROI

if  nargin >= 4
    if ~exist(ResultantFolder, 'dir')
        mkdir(ResultantFolder);
    end
end

surft=gifti(surface);%a function to open a surface file:XXXXX.gii;
Vert = surft.vertices;%the coordinate of the point
%Fac = surft.faces; % the serial number of the points to form the triangle

%%roi_label==label_value,select the whole sueface;
if strcmp(roi_label,'all') || strcmp(roi_label,'All')
    Fac_Vert_index=1:length(Vert);
    Fac_Vert_index=Fac_Vert_index';
else
    vertice_select=[];
    for i=1:length(roi_label)
        vertice_index=find(label_value==roi_label(i));%the vertice whose value is equal to the roi_label,(select the vertice)
        vertice_label=[vertice_select;vertice_index];
        vertice_select=vertice_label;
    end    
   Fac_Vert_index=vertice_select;
end

if nargin >= 4
    save([ResultantFolder filesep 'ExtractROI_Result.mat'], 'Fac_1','Fac_1_Vert_index');
end
