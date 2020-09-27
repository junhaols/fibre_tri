function g_sorting_fibre_tri_multi(Subject_path,Subject_IDs,Result_Name)
% Sorting the results
%% Main input:
% *Subject_path:The subject path,which conclude the structure as above.
% *Subject_IDs:
%        'all or 'All':All subjects will be calculated.
%        For special subject,set it as a matrix of subject id.
% *Result_Name:The name about the result.

if strcmp(Subject_IDs,'All') || strcmp(Subject_IDs,'all') 
    result=g_ls([Subject_path,'/*/','*',Result_Name,'*']);
    for j=1:length(result)
        result_path=result{j}   
        fibre_tri=g_sorting_fibre_tri(result_path);
    end
else
    for k=1:length(Subject_IDs)
        subj=num2str(Subject_IDs(k));
        result_path=cell2mat(g_ls([Subject_path,'/',subj,'/*',Result_Name,'*']));
        fibre_tri=g_sorting_fibre_tri(result_path);
    end
   
end
