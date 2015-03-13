
%NOTE.  3/11/15. The writing to firebase has been commented out just to
%test running this with interactive picking in boxall2.  But if put back in 
%the automatic running of a folder, as in box_all2 will work.  

%test for box area
%This works with box_all.m but not with boxall2.m.  Because 'nname' is not
%defined in boxall2.  This only writes  a failure notice to my personal
%Firebase account, so it can be commented out for now.  Done.
toplength=sqrt((x_roi_ul-x_roi_ur)^2+(y_roi_ul-y_roi_ur)^2);
leftlength=sqrt((x_roi_ul-x_roi_ll)^2+(y_roi_ul-y_roi_ll)^2);
bottomlength=sqrt((x_roi_ll-x_roi_lr)^2+(y_roi_ll-y_roi_lr)^2);
rightlength=sqrt((x_roi_ur-x_roi_lr)^2+(y_roi_ur-y_roi_lr)^2);
area1=toplength*leftlength;
area2=leftlength*bottomlength;
area3=bottomlength*rightlength;
area4=rightlength*toplength; 
areaaverage=(area1+area2+area3+area4)/4;
failcount=0;
disp('boxareatest ran')%This is here for a test.  Delete when done.
%disp(nname)%also a test
areafailflag='areafailflag';
failflag=1;
%%slopetop=(y_roi_ur-y_roi_ul)/(x_roi_ur-x_roi_ul)
%slopebottom=(y_roi_lr-y_roi_ll)/(x_roi_lr-x_roi_ll)
if abs(1-(abs((areaaverage)/65352425)))>0.03  
    abs(1-(abs((areaaverage)/65352425)));
   myformat = '%s \r\n';  %These will work eventually in a sequential
   %open.
   failcount=failcount+1;
   fprintf(fid, myformat,fullFileName); 
    disp('Maybe you didnt find the box')
    %failcommand= sprintf('curl -X PUT -d \"%d\" https://flickering-fire-3977.firebaseio.com/%s/%s.json', failflag, nname, areafailflag);
%dos(failcommand);
    %Add a write to firebase with a flag for failure.      
    %This writes to firebase, but only temporarily.  Figure this out.
end

%Use numimages as the size of the matrix that will store the areas for
%later checking of accuracy, ie. the maybareaeyoudidn'tfindthebox business.