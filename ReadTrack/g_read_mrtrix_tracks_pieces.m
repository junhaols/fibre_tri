function [NaN_position,tracks,fibre_data1,fibre_data2] = g_read_mrtrix_tracks_pieces(filename,start_index,end_index)

%% Function: You can read the coordinate of the endpoint and the second point as you select the pieces.

% Returns a structure containing the header information and data for the MRtrix 
% format track file 'filename' (i.e. files with the extension '.tck'). 
% The track data will be stored as a cell array in the 'data' field of the
% return variable.

%Input:

% *filename:the fibre file;
% *start_index:The start number of the track;
% *end_index:The end number of the track;
% If only the filename is given,the fibre will not be splited.

%Return:
% *NaN_position:The position of the nan values to split different fibres.
% *tracks:Store the main information of the fibre.
% *fibre_data1:The coordinates of first 2 endpoints.
% *fibre_data2:The coordinates of last 2 endpoints.

%% Set default paramester.

if (nargin==1)
    

         [~,~,fileSuffix]=fileparts(filename);
         fibre_path=filename;
         if (fileSuffix=='.tck')
             [~,track_info]=system(['export LD_PRELOAD=/opt/glibc-2.14/lib/libc-2.14.so;' 'tckinfo ' fibre_path ]);
             k1=strfind(track_info,'count:');
             k2=strfind(track_info,'crop_at_gmwmi:');
             track_number=str2num(track_info(k1+6:k2-1));
             start_index=1;
             end_index=track_number;
             
%          elseif(fileSuffix=='.mat')
%              
%              tracks=load(fibre_path);
%              fibre_coord=tracks.Terminate; 
%              track_number=length(fibre_coord);
%              start_index=1;
%              end_index=track_number;
         end
end
%% 

image.comments = {};

f = fopen (filename, 'r');
assert(f ~= -1, 'error opening %s', filename);
L = fgetl(f);
if ~strncmp(L, 'mrtrix tracks', 13)
  fclose(f);
  error('%s is not in MRtrix format', filename);
end

tracks = struct();

while 1
  L = fgetl(f);
  if ~ischar(L), break, end;
  L = strtrim(L);
  if strcmp(L, 'END'), break, end;
  d = strfind (L,':');
  if isempty(d)
    disp (['invalid line in header: ''' L ''' - ignored']);
  else
    key = lower(strtrim(L(1:d(1)-1)));
    value = strtrim(L(d(1)+1:end));
    if strcmp(key, 'file')
      file = value;
    elseif strcmp(key, 'datatype')
      tracks.datatype = value;
    else 
      tracks = setfield (tracks, key, value);
    end
  end
end
fclose(f);

assert(exist('file') && isfield(tracks, 'datatype'), ...
  'critical entries missing in header - aborting');

[ file, offset ] = strtok(file);
assert(strcmp(file, '.'), ...
  'unexpected file entry (should be set to current ''.'') - aborting');

assert(~isempty(offset), 'no offset specified - aborting');
offset = str2num(char(offset));

datatype = lower(tracks.datatype);
byteorder = datatype(end-1:end);

if strcmp(byteorder, 'le')
  f = fopen (filename, 'r', 'l');
  datatype = datatype(1:end-2);
elseif strcmp(byteorder, 'be')
  f = fopen (filename, 'r', 'b');
  datatype = datatype(1:end-2);
else
  error('unexpected data type - aborting');
end

assert(f ~= -1, 'error opening %s', filename);

f = fopen (filename, 'r', 'l');
fseek (f, offset, -1);
data = fread(f, inf, datatype,8);%skip 2 1=4byte
fclose (f);

m=find(isnan(data));

%%split the fibre


%read coordinate
    
f = fopen (filename, 'r', 'l');

if start_index==1
    p=1;
    fseek (f, offset+(p-1)*3*4, -1);
    temp = fread(f, [3,m(end_index)], datatype)';
    
else
    
    p=m(start_index-1)+1;

    fseek (f, offset+(p-1)*3*4, -1);
    
    temp = fread(f, [3,m(end_index)-m(start_index-1)], datatype)';  
    
end
fclose (f);

mm=find(isnan(temp(:,1)));

pk=1;
for j=1:end_index-start_index+1        
    tracks.data1{j}=temp(pk:(pk+1),:);
    tracks.data2{j}(1,:)=temp(mm(j)-1,:);
    tracks.data2{j}(2,:)=temp(mm(j)-2,:);
    pk=mm(j)+1;
end
temp=[];
data=[];

fibre_data1=tracks.data1;
fibre_data2=tracks.data2;
NaN_position=m;


% fibre_data1(cellfun(@isempty,fibre_data1))=[];
% fibre_data2(cellfun(@isempty,fibre_data2))=[];

