%This file has the user pick a seismogram image file to open.  It then
%extracts the start date,start time, and station number for the seismogram.
%Using this information, it queries earthquake.usgs.gov and looks for
%earthquakes in the 24 hour window after the start of the seismogram that
%are within 5000 miles of the station (or any other hardwired value you want)
%, and of magnitude greater than 5.0 (or again, whatever you want.)
%If there was an earthquake(s) in that time, it will return a flag (>0 or
%some value).  If not, the flag value will =0.

%NOTE.  The file <station_list.xlsx> needs to be put in the Current Folder of
%Matlab in order for this to run.

%****
% Interactively reading in a file.
[filename, user_canceled] = imgetfile;

Iorig=imread(filename);

 %This gets the parts of the filename for extracting the start time, etc.
 %'name' is all that is used (for now).
[pathstr,name,ext] = fileparts(filename);

 
%***Now getting the start date, time, station.
%On the seismograms, the format is mmddyy.  Note this is different than the
%format that GeoJSON requires.

% Eventually will need an error check
%for when the numbering system is incorrect.  I.e.,at least check for number of
%characters, the presences of "x's" instead of numbers, or additional
%characters that include "x's" and others

% seismostarttime puts the start time in proper hour:minute format
%for the GeoJSON call.
seismostarttimehour=name(8:9);
seismostarttimeminute=name(10:11);
colon=':';
seismostarttime=strcat(seismostarttimehour,colon,seismostarttimeminute);

seismostation=name(13:16);
seismostationnum=str2num(seismostation);%Converts from a char to a num.
 
 %station_list.xlsx is the station data from USGS that
 %has station ID, name, lat/long and other info.   This loop takes the
 %station number from the file name and uses is to extract lat and long
 %coordinates from the .xlsx file and put it into the subsequent GeoJSON
 %call. station_list.xlsx needs to be in your Current Folder.( Nice that it
 %doesn't crash when it hits a NaN.)
 
 list_array=xlsread('station_list.xlsx');
 for sta_count=1:124
     if list_array(sta_count,1)-seismostationnum==0
        latitude=list_array(sta_count,3);
        longitude=list_array(sta_count,4);
         break
     else
          
     end
 end

 
%These next lines break the date into separate strings and recombine them
%as a single string in the format that is needed for GeoJSON.  
%Format is yyyy-mm-dd for GeoJSON.
string1=name(1:2);  %month
string2=name(3:4);  %start day
string3=name(5:6);  %year.  Always in 19xx format. No Y2K here.
string4='-';
string5='19';
 
stringdatestart=strcat(string5,string3,string4,string1,string4,string2);

URL1='http://comcat.cr.usgs.gov/fdsnws/event/1/count?starttime=';%Put the string date in after this.
URL2='%20';
URL3=':00&latitude=';
URL4='&longitude=';
URL5='&maxradiuskm=6300&minmagnitude=5&format=geojson&endtime=';
URL6='%2023:59:59&maxmagnitude=9&orderby=time';
 
%This is the desired URL request sent to comcat.cr.usgs.gov
combinedURL = strcat(URL1,stringdatestart,URL2,seismostarttime,URL3,num2str(latitude),URL4,num2str(longitude),URL5,stringdatestart,URL6)
%Note that the end time right now is fixed at the end of the day.   A logic
%chain needs to be implemented in order to handle a 24 hour period that
%runs into the next day (as it always will).

 %Create a file where the output is kept as an html file
 filenameurl='activity.html'; 
 %Read the web content at the URL and write it to activity.html.  Note that each
 %time I run this it will put the activity.html into my current folder, which isn't
 %the best place but will do for now.
 urlwrite(combinedURL,filenameurl);
 
 event_count=urlread(combinedURL);  %This file is a string and is another way
 %to get the information.
 %The format is always ..."count":<number>... and if number >0 it's active.
 %Use strncmp or something similar.
clear URL1 URL2 URL3 URL4 URL5 URL6 ans colon ext pathstr seismostarttime seismostarttimehour...
   seismostarttimeminute seismostation seismostationnum sta_count string1...
   string2 string3 string4 string5 stringdatestart user_canceled list_array...
   Iorig
 %%Still to do
%-Parse the html or string to find the value of the flag, and store for
%later use.
%-Change the end date so it's a 24 hour window.
%-Error check on the file name to make sure it has usable data.  E.g.
%sometimes it has "x's" instead of numbers, and etc.
%-Review, improve and clean up this .m file
%-Confer with USGS to determine search parameters and validity of this idea.
  
 