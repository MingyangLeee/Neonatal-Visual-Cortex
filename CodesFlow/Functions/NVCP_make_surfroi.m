function rois = NVCP_make_surfroi(ROIName)
%% creat surface-ROI 
% quickly create masks for analysis
% ROIName: label_hemisphere
switch ROIName
    case 'VOTC_right'
        a = gifti('~/VOTC15_R_binary.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1; 
    case 'VOTC_left'
        a = gifti('~/VOTC15_L_binary.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1;   
    case 'V1_right'
        a = gifti('~/mmp180_R.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b == 1) = 1; 
    case 'V1_left'
        a = gifti('~/mmp180_L.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b == 181) = 1;        
    case 'V34_right'
        a = gifti('~/VOTC34_R_binary.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1; 
    case 'V34_left'
        a = gifti('~/VOTC34_L_binary.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1;     
end
