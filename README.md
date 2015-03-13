# seismo-matlab-scripts

(pasted from [here](https://docs.google.com/document/d/15OJ0cvLZTeJysPPoNEUx0-Hfrh-ozMO2BZyEjHl_w6o/edit))

This describes the routines used to get the ROI of the data box and the meanlines.

boxall2 gets the coordinates of the data box (the ROI), then finds the meanlines of the traces in that ROI.   ROI and meanline data are stored as JSON objects in Firebase.  
- boxall2 runs on interactively selected images.   There is also a version that runs automatically on all files in a selected folder.
- requires URLRead2 and JSONLab scripts since it writes to Firebase.
- The image is not rotated, so image tilt contributes to trace tilt.  

boxall2 consists of: 

boxdetection6b
-Otsu to get BW image.  Hardwired threshold value.
- Morphological opening to remove traces (which otherwise can mess up data box detection).  Hardwired struturing element. 
- bwboundaries to get perimeters of all objects.
- regionprops to then find object with largest area.  Assumed to be the data box.   A test for ROI size reasonableness has been written but not implemented here.

 
box_get_perimeter
- Using perimeter points with hough transform to get longest edge lines.  Hardwired hough peaks/lines values.


box_getroi
- Takes hough lines and creates 4 ROI points.   
- Writes json data  to seismogram.firebaseio.com/metadata/'seismogram name'/corners/topLeft(Right, bottomLeft, Right)/

temp_mask
- 5 lines of code to create a polygonal mask using the ROI points.  
 
meanline6
- Uses mask to extract an image containing only the data box.
-  Uses Otsu to get a binary image.  Hardwired threshold value.
- Morphological opening to remove timing marks (which aren't as good for finding mean lines as the traces themselves).   Hardwired opening parameter of 500.  
- Hough lines/peaks to get meanlines.    Hardwired values in lines/peaks.
-  Saved as JSON in 'seismogram.firebaseio.com/metadata/'seismogram name"/meanlines.json'

NOTES
- A reasonableness test for ROI detection is based on the area of the box being within 3% (or whatever you want. 3% will be at least 2 std. dev. if not more ) of the canonical area value of 65,352,425 pixels which was previously determined from random image testing.  Box area measurements are in the Drive called 'seismo data box size'    This script  needs to be modified to put a fail flag somewhere useful, if this check is useful, which it probably is since it will likely pick up some of the egregiously exposed image files that can't be solved.  Don't get subsequent solving routines stuck on useless images.

- The number of meanlines detected could be a reasonableness check.   If we limit it to long period seismos, this value will be *about* 24 or, before a certain date, 48.   Note that many seismos have <24 traces because they didn't collect a full 24 hour cycle.  However, most if not all won't have more than 25 (the extra line is for partial hours).  Bob Hutt at USGS gave me dates when seismographs were purported switched from 48 lines to 24 lines, but this date isn't exact. This needs to be followed up with USGS.

-  The automatic processing of a complete folder (the folder has to be written in the code for now, which implies additional work to write it to run through a whole list of folders) is done in box_all2.   This latter program needs to be reviewed to ensure proper placement of the data.
