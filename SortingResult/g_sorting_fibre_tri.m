function fibre_tri=g_sorting_fibre_tri(result_path)

%*result_path:The path containing the results.

%% FibreCount_Vert1.mat:A cell format files.Cell1:The index of the fibre.Cell2:The total number of the fibres.Cell3:The vertice in the surface1 that these fibres intersert to.
%  FibreCount_Surf1.gii:A fibre count weighted label file.The number of fibers intersect the vertices in surface1.(Regard surface2 as a big ROI)


%  FibreCount_Vert2.mat:A cell format files.Cell1:The index of the fibre.Cell2:The total number of the fibres.Cell3:The vertice in the surface2 that these fibres intersert to.
%  FibreCount_Surf2.gii:A fibre count weighted label file.The number of fibers intersect the vertices in surface2.(Regard surface1 as a big ROI)


% fibre_tri.mat:A cell.
%                       
%                  
%                       Column1:The serial number of the fibre;
%                       Column2:The serial number of the vertice in the surface1;
%                       Column3:The distance between the end point of the fibre and the vertice in the surface1;
%                       Column4:The serial number of the vertice in the surface2;
%                       Column5:The distance between the end point of the fibre and the vertice in the surface2;
%                       


fibre_tri_file=g_ls([result_path '/*fibre_tri*']);

fibre_tri_LR_All=[];
fibre_tri_LL_All=[];
fibre_tri_RR_All=[];

for i=1:length(fibre_tri_file)
    file_path=fibre_tri_file{i};
    fibre_tri_result=load(file_path);
    fibre_tri_LR=fibre_tri_result.fibre_tri_LR;
    fibre_tri_LL=fibre_tri_result.fibre_tri_LL;
    fibre_tri_RR=fibre_tri_result.fibre_tri_RR;
    
    
    if ~isempty(fibre_tri_LR)
        fibre_tri_LR_All=[fibre_tri_LR_All;fibre_tri_LR];
    end
    if ~isempty(fibre_tri_LL)
        fibre_tri_LL_All=[fibre_tri_LL_All;fibre_tri_LL];
    end
    
    if ~isempty(fibre_tri_RR)
        fibre_tri_RR_All=[fibre_tri_RR_All;fibre_tri_RR];
    end     
end

 
if ~isempty(fibre_tri_LR)
    fibre_tri_LR_All=sortrows(fibre_tri_LR_All,1);
end

if ~isempty(fibre_tri_LL)
    fibre_tri_LL_All=sortrows(fibre_tri_LL_All,1);
end

if ~isempty(fibre_tri_RR)
    fibre_tri_RR_All=sortrows(fibre_tri_RR_All,1);
end

save_path=[result_path filesep 'fibre_tri'];

if ~exist(save_path,'dir')
    mkdir(save_path);
end

fibre_tri.fibre_tri_LR=fibre_tri_LR_All;
fibre_tri.fibre_tri_LL=fibre_tri_LL_All;
fibre_tri.fibre_tri_RR=fibre_tri_RR_All;
fibre_tri.ResultInfoLR=['fibre_tri_LR: FibreIndex ','LVertIndex ','LDist ','RVertIndex ','RDist ']
fibre_tri.ResultInfoLL=['fibre_tri_LL: FibreIndex ','LVertIndex ','LDist ','LVertIndex ','LDist ']
fibre_tri.ResultInfoRR=['fibre_tri_RR: FibreIndex ','RVertIndex ','RDist ','RVertIndex ','RDist ']

save([save_path,'/fibre_tri.mat'],'fibre_tri');
% sortrows(a,1) sorting as column 1
    
