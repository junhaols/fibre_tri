function g_readTrackEndPoint(fibre_path,start_index,end_index,savepath,fibre_name)


% addpath(genpath('/data/disk2/luojunhao/test0918/code_Fibre_tri_inter_LR.v1.0.0'));
% %fibre_path='/data/disk2/luojunhao/test0918/subject/100307/track/100307_iFOD2_100M_SIFT_10M.tck';
% fibre_path='/data/disk2/luojunhao/test0918/subject/100307/track/test_10000.tck'
tic
[fibre_NaN_position,~,fibre_data1,fibre_data2] = g_read_mrtrix_tracks_pieces(fibre_path,start_index,end_index); 
 
 Nfibre=length(fibre_data1);

 get_first_row=@(x) x(1,:);
 
 %% start point

 start_point=fibre_data1(1:Nfibre);
 StartPoint=cellfun(get_first_row,start_point,'UniformOutput',false);
 temp1=cell2mat(StartPoint);
 StartPoint_new=reshape(temp1,[3,Nfibre]);
 StartPoint_new=StartPoint_new';
 
 %% endpoint
 
 end_point=fibre_data2(1:Nfibre);
 EndPoint=cellfun(get_first_row,end_point,'UniformOutput',false);
 temp2=cell2mat(EndPoint);
 EndPoint_new=reshape(temp2,[3,Nfibre]);
 EndPoint_new=EndPoint_new';
 
 Terminate=[StartPoint_new,EndPoint_new];

 fibreInfo.fibre_NaN_position=fibre_NaN_position;
 fibreInfo.ColumnInfo=['1--3: StartPoint_xyz     ', '4--6: EndPoint_xyz'];
 %name=' Terminate'
 save([savepath,'/',fibre_name,'.txt'],'Terminate','-ascii');
 save([savepath,'/fibreInfo.mat'],'fibreInfo');
 
 toc

 
 
 
 
 
 
 
 