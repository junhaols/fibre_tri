function fibre_num=g_tckinfo(fibre_path)
%% get fibre number.

try
 %The gonglab server.(small)
[~,track_info]=system(['export LD_PRELOAD=/opt/glibc-2.14/lib/libc-2.14.so;' 'tckinfo ' fibre_path ]); 
 %[~,track_info]=system(['export LD_PRELOAD=/opt/glibc-2.14/lib/libc-2.14.so;export LD_PRELOAD=/usr/lib64/libstdc++.so.6;' 'tckinfo ' fibre_path ]); 

catch                
% The whole lab server.(big)
[~,track_info]=system(['export LD_PRELOAD=/usr/lib64/libstdc++.so.6.0.19;' 'tckinfo ' fibre_path ]);
end

k1=strfind(track_info,'count:');
k2=strfind(track_info,'crop_at_gmwmi:');
track_number=str2num(track_info(k1+6:k2-1));
fibre_num=track_number;


%fibre_path='/data/disk2/luojunhao/test0918/subject/100307/track/test_500000.tck'