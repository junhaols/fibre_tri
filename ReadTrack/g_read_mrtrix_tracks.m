function [NaN_position,tracks,fibre_data1,fibre_data2] = g_read_mrtrix_tracks(filename,N_split)

%% Function: You can split the fibre to different pieces and the read the coordinate of the endpoints and the second point of the fibre.
% Returns a structure containing the header information and data for the MRtrix 
% format track file 'filename' (i.e. files with the extension '.tck'). 
% The track data will be stored as a cell array in the 'data' field of the
% return variable.

%% Input:

% *filename:the fibre file;
% *N_split:The number to split the fibre,then the coordinate will be read piece by piece.
%Return:
% *NaN_position:The position of the nan values to split different fibres.
% *tracks:Store the main information of the fibre.
% *fibre_data1:A 1*N cell,N is the total number of the fibre.It restore the coordinates of first 2 start points.
... One cell is a 2*3 matrix,where the 1st row is the coordinate of the start endpoint,and the 2nd row is the coordinate of the second point. 
    
% *fibre_data2:A 1*N cell,N is the total number of the fibre.It restore the coordinates of last 2 end points.
... One cell is a 2*3 matrix,where the 1st row is the coordinate of the last endpoint,and the 2nd row is the coordinate of the last second point. 


%% 

tic
if (nargin<2)
    N_split=100; %Split the fibre,read it piece by piece.     
end         

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
fibreCount=length(m);

remainder=mod(length(m),N_split);

if(remainder==0)

    interval=length(m)/N_split;
    %index=[interval:interval:length(m)];
    for i=1:N_split
        %for j=1:interval
            start_index=interval*(i-1)+1;
            end_index=interval*i;
    
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
                tracks.data1{j+(i-1)*interval}=temp(pk:(pk+1),:);
                tracks.data2{j+(i-1)*interval}(1,:)=temp(mm(j)-1,:);
                tracks.data2{j+(i-1)*interval}(2,:)=temp(mm(j)-2,:);
                pk=mm(j)+1;
            end
    end
else
    interval=ceil(length(m)/N_split);
    %index=[interval:interval:length(m)];
    
    for i=1:N_split
        %for j=1:interval
        if(fibreCount-interval*i>=0) 
            start_index=interval*(i-1)+1;
            end_index=interval*i;
    
            f = fopen (filename, 'r', 'l');

            if start_index==1
                p=1;
                fseek (f, offset+(p-1)*3*4, -1);
                temp = fread(f, [3,m(end_index)], datatype)';

            else

                p=m(start_index-1)+1;

                fseek (f, offset+(p-1)*3*4, -1);
                
                %disp(i);

                temp = fread(f, [3,m(end_index)-m(start_index-1)], datatype)';  

            end
            fclose (f);

            mm=find(isnan(temp(:,1)));

            pk=1;
            for j=1:end_index-start_index+1        
                tracks.data1{j+(i-1)*interval}=temp(pk:(pk+1),:);
                tracks.data2{j+(i-1)*interval}(1,:)=temp(mm(j)-1,:);
                tracks.data2{j+(i-1)*interval}(2,:)=temp(mm(j)-2,:);
                pk=mm(j)+1;
            end
        else
            
            start_index=interval*(i-1)+1;
            end_index=length(m);%The last part.
    
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
                tracks.data1{j+(i-1)*interval}=temp(pk:(pk+1),:);
                tracks.data2{j+(i-1)*interval}(1,:)=temp(mm(j)-1,:);
                tracks.data2{j+(i-1)*interval}(2,:)=temp(mm(j)-2,:);
                pk=mm(j)+1;
            end
            disp(['Notice:The total number of fibre cannot be divisible by the N_split,it is divided into ' num2str(i) ' parts,it is OK if the number of the parts is less than N_split!']);
            break; %The last section of the fibre is reading,so drop out of the loop.The i may be less than the N_split.
        end
    end
end
                  
temp=[];
data=[];

fibre_data1=tracks.data1;
fibre_data2=tracks.data2;
NaN_position=m;

toc
% fibre_data1(cellfun(@isempty,fibre_data1))=[];
% fibre_data2(cellfun(@isempty,fibre_data2))=[];

