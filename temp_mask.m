

xmask=[x_roi_ll,x_roi_lr,x_roi_ur,x_roi_ul]; %go around the points in order, i.e. don't go diagonal

ymask=[y_roi_ll,y_roi_lr,y_roi_ur,y_roi_ul];

mask=poly2mask(xmask,ymask,heightVal,widthVal);  

% other test change

maskedimage=I;
maskedimage(~mask)=0;
imshow(maskedimage)
