%9/19/14. This runs one interactively selected image and writes ROI and
%meanline data to firebase successfully, in Ben's preferred format. Thanks
%to Ben for help.  NOTENOTE  Make sure the folders JSON and URLread2 are on
%the path, otherwise this won't work.


%9/10/14 modified to add temp_mask and then meanline5
%and writing to Firebase (in progress)

%This is like box_all.m, but for one image.  boxareatest.m needs to be
%modified if you want to use it in this script since it relies on the
%variable 'fullfilename.'
boxdetection6b
%keyboard
box_get_perimeter

box_getroi
temp_mask
%keyboard
%meanline5 %USE THIS. meanline6 is just for testing for now. 3/9/15.  I
%think meanline6 is better, but anyway check this.
meanline6
%keyboard
%tracecount1
%counttemp
%fid = fopen('C:\New folder\myfile.txt','a');
%boxareatest



%9/10/14 notes.   Get rid of keyboard when running get perimeter.
%Use 'lines' to get coordinates of lines and extend to edge of image.  What
%happens if the line extends above or below?

%write data to firebase