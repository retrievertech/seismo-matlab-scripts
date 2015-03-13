%This is the same as boxdetection6a except it calls for an interactive pick
%of the file.   This is so I can use it with boxall (not box_all, which is
%to sequentially open files in a folder)
%I think the difference between this and 6 is now I am (correctly )
%comparing areas, not perimeters.
%THE difference between this and boxdetection5 is in resizing (this has none),
%the creation of BW3X which is necessary for follow on .m file
%box_get_perimeter, etc., and a speeding up by eliminating histogram work,
%extra morphological processing. 3/7/14

[image, user_canceled] = imgetfile;
[pathstr,seisname,ext] = fileparts(image); %gets the file name for placement in firebase.  This should do it for all writes with urlread2.
Iorig=imread(image); 
I=imresize(Iorig,1.0); % Relic of scaling.  Can bring it back but requires 
%adjusting other followons in box_perimeter, etc.  

 level=graythresh(I); %Otsu's method to determine global threshold.   
 
 BW=im2bw(I,level);  %Creating a binary image before morphological opening 
 %and other processing.
 se=strel('disk',17); %Morphological opening removes the traces, which otherwise
 %can cause unwanted problems. Use  strel = 7 or so for full size x 0.25x 
 %images. Note: if too large,
 %it will pull in data from outside the box.  Too small and traces can get
 %pulled in especially at the edge.   37 is too big, btw.
 
 BW2=imopen(BW,se);  %This performs morphological opening and removes the traces.
% keyboard

%Other morphological processing can be done, obviously. 
BW3=imcomplement(BW2); %Need to invert the binary image. Maybe. This is a leftover
%from using bwconncomp. It still works.
 sizeBW3=size(BW3);%Getting the size of the binary image for later use.
 BW3X=sizeBW3(2); %The x dimension for later
 BW3Y=sizeBW3(1);  %The y dimension for later
%Look for the largest object using bwboundaries.
[B,LL]=bwboundaries(BW3,'noholes');  %B is the perimeter, what we want.
stats3=regionprops(LL,I,'Area'); 
thearea1=0;
%Bsize1=0;
for kk=1:(size(B))
   %Bsize2=numel( B{kk,1}(:,1));
    %Bsize2=numel( B{kk,1}(:,1));
   thearea2=stats3(kk).Area;
   if thearea2>thearea1
       thearea1=thearea2;
       Bvalue=kk;
   end
  
end
 
%stats3=regionprops(LL,I,'PixelValues','Perimeter','Area'); %Get the pixel 
%intensity values and Area for later.  Perimeter can be used as needed.
%Ivalues=double (stats3(Bvalue).PixelValues);%The intensity values of the data box.
%histmin=min(Ivalues); %The range of the histogram of the data box.
%histmax=max(Ivalues);
%imshow(I)%.  I commented out all displaying in this script.

%hold on
%plot ((B{Bvalue,1}(:,2)), (B{Bvalue,1}(:,1)),'LineWidth',4)  %This plots the
%perimeter.  Note that this part doesn't need the information from
%regionprops.  Regionprops is for the histogram of the data box, and
%bwboundaries is for finding the actual data box. 
%figure
%hist((Ivalues),(histmax-histmin)); %The histogram of the putative data box.
%**********
 

