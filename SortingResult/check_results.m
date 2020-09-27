%% fibre_tri_old
%load('/brain/gonggllab/luojunhao/test_0821/100307_ljh_result_test_6mm/fibre_tri/100307_ljh_result_test_6mm_fibre_tri.mat')
 % new script
load('/brain/gonggllab/Xiongyirong/.XYR_tmp/HCP_unrelated100/100307/100307_ljh_result_test_08212mm/fibre_tri/100307_ljh_result_test_08212mm_fibre_tri.mat')
% old scrip
load('/brain/gonggllab/luojunhao/test_0821/100307_ljh_result_10M_2mm_fibre_tri.mat');
  

%load('100307_ljh_result_10M_2mm_fibre_tri.mat');
    load('/brain/gonggllab/luojunhao/test_0821/100307_Terminate_old.txt');
    draw_fibre_index=100
    
    fibre1=X100307_Terminate_old(fibre_tri(draw_fibre_index,1),1:3);
    fibre2=X100307_Terminate_old(fibre_tri(draw_fibre_index,1),7:9);
    surfl=gifti('/brain/gonggllab/luojunhao/test_0821/100307/surface/100307.L.white_MSMAll.32k_fs_LR.surf.gii');
    surfr=gifti('/brain/gonggllab/luojunhao/test_0821/100307/surface/100307.R.white_MSMAll.32k_fs_LR.surf.gii');
    %surfl=gifti('/brain/gonggllab/luojunhao/test_0821/100307/surface/100307.pial_MSMAll_32kfs_L.surf.gii');
    %surfr=gifti('/brain/gonggllab/luojunhao/test_0821/100307/surface/100307.pial_MSMAll_32kfs_R.surf.gii');
    
    
    vertl=surfl.vertices;
    vertr=surfr.vertices;
    vert1=vertl(fibre_tri(draw_fibre_index,2),:);
    vert2=vertr(fibre_tri(draw_fibre_index,4),:);
    close(gcf)
    scatter3(fibre1(:,1),fibre1(:,2),fibre1(:,3),'*r')
    hold
    scatter3(vert1(:,1),vert1(:,2),vert1(:,3),'or')

    hold on 
    scatter3(fibre2(:,1),fibre2(:,2),fibre2(:,3),'*b')
    hold on
    scatter3(vert2(:,1),vert2(:,2),vert2(:,3),'ob')
    
    det1=fibre1-vert1;
    det11=fibre1-vert2;
    dist1=sqrt((det1(:,1).^2)+(det1(:,2).^2)+(det1(:,3).^2))
    dist11=sqrt((det11(:,1).^2)+(det11(:,2).^2)+(det11(:,3).^2))

 det2=fibre2-vert2;
 dist2=sqrt((det2(:,1).^2)+(det2(:,2).^2)+(det2(:,3).^2))
  det22=fibre2-vert1;
  dist22=sqrt((det22(:,1).^2)+(det22(:,2).^2)+(det22(:,3).^2))
 
  %%
  %a=load('/brain/gonggllab/Xiongyirong/.XYR_tmp/HCP_unrelated100/100307/100307_ljh_result_test_08212mm/100307_fibre_index_1_505101.mat')
%% test-0927

load('/data/disk2/luojunhao/test0918/subject/100307/100307TEST_2MM_0927/fibre_tri/fibre_tri.mat');

fibre_tri_LR=fibre_tri.fibre_tri_LR;
fibre_tri_LL=fibre_tri.fibre_tri_LL;
fibre_tri_RR=fibre_tri.fibre_tri_RR;
% orig fibre_index
load('/data/disk2/luojunhao/test0918/subject/100307/track/LJH_500000_Terminate.txt');
    all_fibre=read_mrtrix_tracks('/data/disk2/luojunhao/test0918/subject/100307/track/test_500000.tck');
    all_fibre_data=all_fibre.data;

    
%%   LR  
    
    draw_fibre_index=1:10;
    fibre1=LJH_500000_Terminate(fibre_tri_LR(draw_fibre_index,1),1:3);
    fibre2=LJH_500000_Terminate(fibre_tri_LR(draw_fibre_index,1),4:6);
    surfl=gifti('/data/disk2/luojunhao/test0918/subject/100307/surface/100307.L.white_MSMAll.32k_fs_LR.surf.gii');
    surfr=gifti('/data/disk2/luojunhao/test0918/subject/100307/surface/100307.R.white_MSMAll.32k_fs_LR.surf.gii');
    %surfl=gifti('/brain/gonggllab/luojunhao/test_0821/100307/surface/100307.pial_MSMAll_32kfs_L.surf.gii');
    %surfr=gifti('/brain/gonggllab/luojunhao/test_0821/100307/surface/100307.pial_MSMAll_32kfs_R.surf.gii');
    
    
    vertl=surfl.vertices;
    vertr=surfr.vertices;
    vert1=vertl(fibre_tri_LR(draw_fibre_index,2),:);
    vert2=vertr(fibre_tri_LR(draw_fibre_index,4),:);
    close(gcf)
    scatter3(fibre1(:,1),fibre1(:,2),fibre1(:,3),'*r');
    hold
    scatter3(vert1(:,1),vert1(:,2),vert1(:,3),'or');

    hold on 
    scatter3(fibre2(:,1),fibre2(:,2),fibre2(:,3),'*b')
    hold on
    scatter3(vert2(:,1),vert2(:,2),vert2(:,3),'ob')
    hold on
    
    full_fibre=all_fibre_data(fibre_tri_LR(draw_fibre_index,1));
    streamline(full_fibre);
    
    
    det1=fibre1-vert1;
    det11=fibre1-vert2;
    dist1=sqrt((det1(:,1).^2)+(det1(:,2).^2)+(det1(:,3).^2));
    dist11=sqrt((det11(:,1).^2)+(det11(:,2).^2)+(det11(:,3).^2));

    det2=fibre2-vert2;
    dist2=sqrt((det2(:,1).^2)+(det2(:,2).^2)+(det2(:,3).^2));
    det22=fibre2-vert1;
    dist22=sqrt((det22(:,1).^2)+(det22(:,2).^2)+(det22(:,3).^2));
 


%% LL
%%    
    
    draw_fibre_index=1:10;
    fibre1=LJH_500000_Terminate(fibre_tri_LL(draw_fibre_index,1),1:3);
    fibre2=LJH_500000_Terminate(fibre_tri_LL(draw_fibre_index,1),4:6);
    surfl=gifti('/data/disk2/luojunhao/test0918/subject/100307/surface/100307.L.white_MSMAll.32k_fs_LR.surf.gii');
    surfr=gifti('/data/disk2/luojunhao/test0918/subject/100307/surface/100307.R.white_MSMAll.32k_fs_LR.surf.gii');
    %surfl=gifti('/brain/gonggllab/luojunhao/test_0821/100307/surface/100307.pial_MSMAll_32kfs_L.surf.gii');
    %surfr=gifti('/brain/gonggllab/luojunhao/test_0821/100307/surface/100307.pial_MSMAll_32kfs_R.surf.gii');
    
    
    vertl=surfl.vertices;
    vertr=surfr.vertices;
    vert1=vertl(fibre_tri_LL(draw_fibre_index,2),:);
    vert2=vertl(fibre_tri_LL(draw_fibre_index,4),:);% left
    close(gcf)
    
    scatter3(fibre1(:,1),fibre1(:,2),fibre1(:,3),'*r');
    hold on
    scatter3(vert1(:,1),vert1(:,2),vert1(:,3),'or');

    hold on 
    scatter3(fibre2(:,1),fibre2(:,2),fibre2(:,3),'*b')
    hold on
    scatter3(vert2(:,1),vert2(:,2),vert2(:,3),'ob')
    hold on
    
    full_fibre=all_fibre_data(fibre_tri_LL(draw_fibre_index,1));
    streamline(full_fibre);
    
%     
%     det1=fibre1-vert1;
%     det11=fibre1-vert2;
%     dist1=sqrt((det1(:,1).^2)+(det1(:,2).^2)+(det1(:,3).^2));
%     dist11=sqrt((det11(:,1).^2)+(det11(:,2).^2)+(det11(:,3).^2));
% 
%     det2=fibre2-vert2;
%     dist2=sqrt((det2(:,1).^2)+(det2(:,2).^2)+(det2(:,3).^2));
%     det22=fibre2-vert1;
%     dist22=sqrt((det22(:,1).^2)+(det22(:,2).^2)+(det22(:,3).^2));
%     
    
   
%% RR

%%    
    
    draw_fibre_index=1:10;
    fibre1=LJH_500000_Terminate(fibre_tri_RR(draw_fibre_index,1),1:3);
    fibre2=LJH_500000_Terminate(fibre_tri_RR(draw_fibre_index,1),4:6);
    surfl=gifti('/data/disk2/luojunhao/test0918/subject/100307/surface/100307.L.white_MSMAll.32k_fs_LR.surf.gii');
    surfr=gifti('/data/disk2/luojunhao/test0918/subject/100307/surface/100307.R.white_MSMAll.32k_fs_LR.surf.gii');
    %surfl=gifti('/brain/gonggllab/luojunhao/test_0821/100307/surface/100307.pial_MSMAll_32kfs_L.surf.gii');
    %surfr=gifti('/brain/gonggllab/luojunhao/test_0821/100307/surface/100307.pial_MSMAll_32kfs_R.surf.gii');
    
    
    vertl=surfl.vertices;
    vertr=surfr.vertices;
    vert1=vertr(fibre_tri_RR(draw_fibre_index,2),:);
    vert2=vertr(fibre_tri_RR(draw_fibre_index,4),:);
    close(gcf)
    scatter3(fibre1(:,1),fibre1(:,2),fibre1(:,3),'*r');
    hold
    scatter3(vert1(:,1),vert1(:,2),vert1(:,3),'or');

    hold on 
    scatter3(fibre2(:,1),fibre2(:,2),fibre2(:,3),'*b')
    hold on
    scatter3(vert2(:,1),vert2(:,2),vert2(:,3),'ob')
    hold on
    
    full_fibre=all_fibre_data(fibre_tri_RR(draw_fibre_index,1));
    streamline(full_fibre);
    
    
%     det1=fibre1-vert1;
%     det11=fibre1-vert2;
%     dist1=sqrt((det1(:,1).^2)+(det1(:,2).^2)+(det1(:,3).^2));
%     dist11=sqrt((det11(:,1).^2)+(det11(:,2).^2)+(det11(:,3).^2));
% 
%     det2=fibre2-vert2;
%     dist2=sqrt((det2(:,1).^2)+(det2(:,2).^2)+(det2(:,3).^2));
%     det22=fibre2-vert1;
%     dist22=sqrt((det22(:,1).^2)+(det22(:,2).^2)+(det22(:,3).^2));


%%