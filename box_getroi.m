%This script gets the coordinates for the ROI that will ID the corners of the data
%box.  It uses the lines that were calculated in get_perimeter.m

%Noted: when the data box is off the image (the original image is skewed
%that much), it doesn't crash, it actually gives a value for the point, but
%of course doesn't plot it.  Good to know.
if (xy_longleft(2,1))==xy_longleft(1,1)%This adds one pixel to the end point's
    %x-value if the left line is horizontal.  A cheap way to get around an
    %infinite slope.
    aa=xy_longleft(2,1); %And these lines just reflect my ignorance about proper
    %indexing and nomenclature.  They make it work which is fine.
    bb=aa+1;  %Adding one pixel to the endpoint's x-value. Ha.
    xy_longleft(2,1)=bb;
    %(xy_longleft(2,1))==((xy_longleft(2,1))+1);
    clear aa
    clear bb
    
end
if (xy_longright(2,1))==xy_longright(1,1)  %Same for the right line now.
    aa=xy_longright(2,1);
    bb=aa+1;
    xy_longright(2,1)=bb;
    %(xy_longright(2,1))==((xy_longright(2,1))+1);%Saving this because it
    %shows what didn't work.
    clear aa
    clear bb
end

slope_top=((xy_longtop(2,2))-(xy_longtop(1,2)))/((xy_longtop(2,1))-(xy_longtop(1,1)));
b_top=(xy_longtop(2,2))-slope_top*(xy_longtop(2,1));

slope_left=((xy_longleft(2,2))-(xy_longleft(1,2)))/((xy_longleft(2,1))-(xy_longleft(1,1)));
b_left=(xy_longleft(2,2))-slope_left*(xy_longleft(2,1));

slope_bottom=((xy_longbottom(2,2))-(xy_longbottom(1,2)))/((xy_longbottom(2,1))-(xy_longbottom(1,1)));
b_bottom=(xy_longbottom(2,2))-slope_bottom*(xy_longbottom(2,1));

slope_right=((xy_longright(2,2))-(xy_longright(1,2)))/((xy_longright(2,1))-(xy_longright(1,1)));
b_right=(xy_longright(2,2))-slope_right*(xy_longright(2,1));

x_roi_ul=(b_top-b_left)/(slope_left-slope_top);
x_roi_ur=(b_right-b_top)/(slope_top-slope_right);
x_roi_ll=(b_bottom-b_left)/(slope_left-slope_bottom);
x_roi_lr=(b_bottom-b_right)/(slope_right-slope_bottom);

y_roi_ul=slope_top*x_roi_ul+b_top;
y_roi_ll=slope_left*x_roi_ll+b_left;
y_roi_ur=slope_top*x_roi_ur+b_top;
y_roi_lr=slope_bottom*x_roi_lr+b_bottom;
%imshow(BW3)
%imshow(I)
%hold on
%plot(x_roi_ul,y_roi_ul,'--gs','MarkerSize',10,'LineWidth',5);
%plot(x_roi_ll,y_roi_ll,'--gs','MarkerSize',10,'LineWidth',5);
%plot(x_roi_ur,y_roi_ur,'--gs','MarkerSize',10,'LineWidth',5);
%plot(x_roi_lr,y_roi_lr,'--gs','MarkerSize',10,'LineWidth',5);


%hold off

%create array with ROI point.  Start at UL and go clockwise
roiarray=zeros(4,2);
roiarray(1,1)=x_roi_ul;
roiarray(1,2)=y_roi_ul;
roiarray(2,1)=x_roi_ur;
roiarray(2,2)=y_roi_ur;
roiarray(3,1)=x_roi_lr;
roiarray(3,2)=y_roi_lr;
roiarray(4,1)=x_roi_ll;
roiarray(4,2)=y_roi_ll;

sample_roi_array = [struct('x',1,'y',1)]; 
roi_array = repmat(sample_roi_array,1,4);
%Put the ROI in Firebase.  This could be done more cleanly, but it works
%since there are always only four corner points. 
 
roi_array(:,1) = [struct('x',roiarray(1,1),'y',roiarray(1,2))];
roidata1 = savejson('', roi_array(:,1));
urlread2(strcat('https://seismogram.firebaseio.com/metadata/',seisname,'/corners/topLeft.json'),'PUT',roidata1,'');

%urlread2('https://seismogram.firebaseio.com/metadata/070877_0505_0023_04/corners/topLeft.json','PUT',roidata1,'') ;

roi_array(:,2) = [struct('x',roiarray(2,1),'y',roiarray(2,2))];
roidata2 = savejson('', roi_array(:,2));
urlread2(strcat('https://seismogram.firebaseio.com/metadata/',seisname,'/corners/topRight.json'),'PUT',roidata2,'') ;
 
roi_array(:,3) = [struct('x',roiarray(3,1),'y',roiarray(3,2))];
roidata3 = savejson('', roi_array(:,3));
urlread2(strcat('https://seismogram.firebaseio.com/metadata/',seisname,'/corners/bottomRight.json'),'PUT',roidata3,'') ;
 
roi_array(:,4) = [struct('x',roiarray(4,1),'y',roiarray(4,2))];
roidata4 = savejson('', roi_array(:,4));
urlread2(strcat('https://seismogram.firebaseio.com/metadata/',seisname,'/corners/bottomLeft.json'),'PUT',roidata4,'') ;

%Put in the image dimensions in Firebase
image_size=size(BW);
heightVal=image_size(1);
widthVal=image_size(2);
structData = struct('width', widthVal, 'height', heightVal);
dimjsonData = savejson('', structData);
urlread2(strcat('https://seismogram.firebaseio.com/metadata/',seisname,'/dimensions.json'),'PUT',dimjsonData,'');
%urlread2('https://seismogram.firebaseio.com/metadata/070877_0505_0023_04/dimensions.json', 'PUT', jsonData)


