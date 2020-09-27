function [fibre_index vertice] =g_intersect_fibre2surfROI_Dist(Vert,orig_fibre_index,fibre_data,threshold_distance,ResultantFolder)
%% This function is used to caculate the intersection by searching the minmum distance between the vertice in the surface and the end point of the fibre,which we call caculating by 'Dist'.



%inputs:
% 
%
% *Vert:
%            All the coordinates of the vertices that form the tringles.
% *orig_fibre_number:
%           The original serial number of the fibres.
% *fibre_data:
%           The coordinates of the fibres,datatype:cell;

%
% *orig_tri_index:
%           The original serial number of the triangles.
%
% * threshold_distance:
%            The selected distance,if the distance between the endpoint of the ray and the intersection is less than the  threshold_distance,the fibre will be selectded.
%
% * ResultantFolder:
%            The file path storing the results.
%
%returns:
%
% 
%* fibre_index:
%              Save the index of the fibre.

%  *vertice:    N*5 matrix.                
%                       1 column:Save the serial number of the vertice of the triangles who
%                                is closest to the end point of the fibre.
%        
%                       2 column:Save the distance between the vertice and
%                                the end point of the fibre.

%                       3-5 column:Save the cooridate of the vertice.
% * Vert:It's the same as the input "Vert".

if nargin >5
    if ~exist(ResultantFolder, 'dir')
        mkdir(ResultantFolder);
    end
end

nfibre=length(fibre_data);

nVert=length(Vert);

for i=1:nfibre
      fibre_end_data=fibre_data{1,i}(1,:);
      % repmat the fibre end coord
      fibre_end_data_new=repmat(fibre_end_data,[nVert,1]);
      fibre_triVert=fibre_end_data_new-Vert;
      Dist=sqrt(sum(fibre_triVert.^2,2));%the vecnorm of the rows.
      [minDist minDistIndex]=min(Dist);
      %all_fibre_index(i)=orig_fibre_index(i); 
      if ~isempty(minDist)
          all_fibre_index(i)=i; 
          all_Dist(i)=minDist;  
          all_VertIndex(i)=minDistIndex;
          all_VertCoord(i,:)=Vert(minDistIndex,:);
      else
          continue
      end
end

%fibre_index_intersect=find(all_fibre_index>0);
fibre_index=orig_fibre_index(all_fibre_index);
%distance=all_Dist(fibre_index_intersect);
%% caculate the vertice
distance_select=find(all_Dist<threshold_distance);

if ~isempty(distance_select)
    distance=all_Dist(distance_select);
    VertIndex=all_VertIndex(distance_select);
    fibre_index=fibre_index(distance_select);
    vertice_coord=all_VertCoord(distance_select,:);
    vertice(:,1)=VertIndex;
    vertice(:,2)=distance;
    vertice(:,3:5)=vertice_coord;
else
    
    fibre_index=[];
    vertice=[];
end
% 
if nargin >= 5
    save([ResultantFolder filesep 'fibreTriResults.mat'],'fibre_index','vertice');
end










