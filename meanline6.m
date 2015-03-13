%9/18/14   This replaces meanline5.  Way better.

%This is from meanline2, just eliminated the centroid finding which wasn't
%doing anything. 

%9/4/14   Using the whole trace lines as done in this script, vs. just
%their centroids, seems to work a lot better.   Recommend using this method
%for all work in the future.   At least for mean lines.  Investigate
%further for timing mark detections.

 
 
 
%I=imread('rotatecroptest.tif'); %This is the LP for complete quiescent seismo in the Drive
%I=imread('LP_hard_T.png');
%I=imread('020166_0640_0023_06-crop.tif'); %This is an active seismo.
%level=graythresh(I);
level=graythresh(maskedimage);  %maskedimage comes from temp_mask, which was
%run after boxall, using the quiescent seismo image.  
BW=im2bw(maskedimage,level); 

%Now, using Hough, peak and lines to find traces.
BW2=bwareaopen(BW,500); %This gets rid of anything < 500 pixels, i.e. timing marks.
 
imshow(BW2)  
hold on  
%BWperimTop=imcrop(BWperim,[0 0 BW3X 0.5*BW3Y]);
[H,T,R] = hough(BW2,'RhoResolution',18 ,'Theta',-90:0.5:-70); %limiting 
%the search for near horizontal lines.   Still need to clarify the proper range
%for lines on either side of 90 degrees.
%P  = houghpeaks(H,50,'threshold',(0.5*max(H(:))),'NHoodSize',[5 5]); %original values
P  = houghpeaks(H,150,'threshold',(0.5*max(H(:))),'NHoodSize',[9 25 ]); %messin.
%The first value is rho and this should be more important in
%suppressing multiple parallel lines.  
 lines = houghlines(BW2,T,R,P,'FillGap',3255,'MinLength',37); %need to add comments
 %on parameter selection. 
 
max_len = 0;
for k = 1:length(lines);
    %for k = 14:14;
    xy = [lines(k).point1; lines(k).point2];
   % Determine the endpoints of the longest line segment
  % len = norm(lines(k).point1 - lines(k).point2);
  % if ( len > max_len)
     % max_len = len;
     % xy_longtop = xy;
    
 %  plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
 plot(xy(:,1),xy(:,2),'LineWidth',5,'Color',rand(1,3));  
%pause(1)

end
%keyboard
linecount=size(lines);
linecount=linecount(2); %How many lines are in the image.   
linearray=zeros(linecount,4); %create an array to put the x, y coordinates in.
vartest=zeros(linecount,8); %Probably just a relic.
for linct=1:linecount  %this puts the x and y points of the mean lines in the array 'linearray'
temp={lines(linct).point1(1)}; 
linearray(linct,1)=cell2mat(temp);%starting x
temp={lines(linct).point1(2)}; 
linearray(linct,2)=cell2mat(temp); %starting y
temp={lines(linct).point2(1)};
linearray(linct,3)=cell2mat(temp); %ending x
temp={lines(linct).point2(2)};
linearray(linct,4)=cell2mat(temp); %ending y

end

%This is Ben's work.  9/19/14.  NOTE  URLread2 and JSON folders need to be
%on the path for this to work. 

% store meanline data in one Matlab object
sample_struct_array = [struct('x',1,'y',1); struct('x',1,'y',1)];   
meanline_array = repmat(sample_struct_array,1,numel(lines));


for i=1:numel(lines)
    meanline_array(:,i) = [struct('x',linearray(i,1),'y',linearray(i,2)); struct('x',linearray(i,3),'y',linearray(i,4))]; %square brackets ARE needed
end

% convert Matlab object into JSON
 
data = savejson('', meanline_array);
[pathstr,seisname,ext] = fileparts(image); %gets the file name for placement in firebase.  Need to do this for roi and dimensions too.
% upload JSON to Firebase

urlread2(strcat('https://seismogram.firebaseio.com/metadata/',seisname,'/meanlines.json'),'PUT',data,'');
%urlread2('https://seismogram.firebaseio.com/metadata/070877_0505_0023_04/meanlines.json','PUT',data,'') ;

