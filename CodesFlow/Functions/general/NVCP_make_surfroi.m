function rois = NVCP_make_surfroi(ROIName)
%% creat surface-ROI 
% ROIName: label_hemisphere
switch ROIName
    case 'whole_right'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/mmp180_R.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1; 
    case 'whole_left'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/mmp180_L.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1; 
    case 'VOTC_right'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/VOTC15_R_binary.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1; 
    case 'VOTC_left'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/VOTC15_L_binary.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1;   
    case 'V1_right'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/mmp180_R.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b == 1) = 1; 
    case 'V1_left'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/mmp180_L.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b == 181) = 1; 
    case 'TGv_right'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/mmp180_R.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b == 172) = 1; 
    case 'TGv_left'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/mmp180_L.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b == 352) = 1;         
    case 'FFA_right'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/WM_FACE_R.func.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1; 
    case 'FFA_left'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/WM_FACE_L.func.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1; 
    case 'EBA_right'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/WM_BODY_R.func.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1; 
    case 'EBA_left'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/WM_BODY_L.func.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1;
    case 'PPA_right'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/WM_PLACE_R.func.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1; 
    case 'PPA_left'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/WM_PLACE_L.func.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1;
    case 'V34_right'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/VOTC34_R_binary.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1; 
    case 'V34_left'
        a = gifti('/home/limingyang/WorkSpace/NVCP/Results/1surface/VOTC34_L_binary.label.gii'); 
        b = a.cdata;
        clear a;
        rois = single(0*b);
        rois(b > 0) = 1;     
end
