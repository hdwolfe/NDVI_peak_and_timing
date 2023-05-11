#!/usr/bin/perl

#extract red and nir bands;

#open log file;
open(lg,">>/data/Wolfe/MyProject/log.txt");

#append log file;
$timestamp=`date`;
print lg "
$timestamp\n
extract bands script state: start
";

#make hdr array for bands file handles;
@hdl_red=();
@hdl_nir=();

#make hdr array for bands path;
@hdr_red=();
@hdr_nir=();

#grab file names to import;
@hdf=`ls ../INPUT`;

#make temporary directory to store bin files;
system("mkdir ../INPUT/bands");

#make file handle arrays for red and nir;
@file_hndl_red=();
@file_hndl_nir=();


#for loop to import hdf rasters;
for $x (@hdf){
if ($x=~m/MOD13A2/){

#define input names for file handles and binary files, both red and nir bands;
$in_hdl=substr($x,9,7);
$in_hdl_red=join('',$in_hdl,"red");
$in_hdl_nir=join('',$in_hdl,"nir");

	#append to hdr file handle;
	push @hdl_red, $in_hdl_red;
	push @hdl_nir, $in_hdl_nir;

#define source file tail;
$src_tail=join('',"/data/Wolfe/MyProject/INPUT/",$x);
$bin_red=join('',"/data/Wolfe/MyProject/INPUT/bands/",$in_hdl_red,".bin");
$bin_nir=join('',"/data/Wolfe/MyProject/INPUT/bands/",$in_hdl_nir,".bin");

#define header path;
$hdr_red=join('',"/data/Wolfe/MyProject/INPUT/bands/",$in_hdl_red,".hdr");
$hdr_nir=join('',"/data/Wolfe/MyProject/INPUT/bands/",$in_hdl_nir,".hdr");

	#append to hdr path arrays;
	push @hdr_red, $hdr_red;
	push @hdr_nir, $hdr_nir;

$red_tail=join(' ',$bin_red,"-b",$src_tail);
$nir_tail=join(' ',$bin_nir,"-b",$src_tail);

#grabbed band names from hdfview;
#grab red and nir bands;
system("hdp dumpsds -n '1 km 16 days red reflectance' -d -o $red_tail\n");
system("hdp dumpsds -n '1 km 16 days NIR reflectance' -d -o $nir_tail\n");
	}
}




#making export red and nir header files;
for $x (@hdl_red){

print $x "ENVI
description = {
  File Imported into ENVI.}
samples = 1200
lines   = 1200
bands   = 1
header offset = 0
file type = ENVI Standard
data type = 2
interleave = bip
sensor type = Unknown
byte order = 0
wavelength units = Unknown";

close($x);
}

for $x (@hdl_nir){

print $x "ENVI
description = {
  File Imported into ENVI.}
samples = 1200
lines   = 1200
bands   = 1
header offset = 0
file type = ENVI Standard
data type = 2
interleave = bip
sensor type = Unknown
byte order = 0
wavelength units = Unknown";

close($x);
}



#close input file handles;
for $x (@hdl_red){
close($x);
}

for $x (@hdl_nir){
close($x);
}

print "
@file_hndl_red
";

#append log file;
$timestamp=`date`;
print lg "
$timestamp\n
extract bands script state: ended
";

#close log file hanldes;
close(lg);

