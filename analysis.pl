#!/usr/bin/perl

#extact maximum NDVI value for spring of each focal year & determine time of spring peak green up.

#open log file;
open(lg,">>/data/Wolfe/MyProject/log.txt");

#append log file;
$timestamp=`date`;
print lg "
$timestamp\n
analysis script state: start
";

#make hdr array for bands file handles and file directories;
@hdl_ndvi=();
@fl_ndvi=();

#make tmp directory;
`mkdir ../INPUT/ndvitmp`;

#remove any tmp files from bands; some are created when files are opened;
system("rm ../INPUT/*enp");

#grab file names to import;
@hdf=`ls ../INPUT`;

#extract ndvi bands;
for $x (@hdf){
if ($x=~m/MOD13A2/){

#define input names for file handles and binary files;
$in_hdl=substr($x,9,7);
$hdl_ndvi=join('',"ndvi",$in_hdl);

#append to ndvi handle array;
push @hdl_ndvi, $hdl_ndvi;

#define source file tail;
$src_tail=join('',"/data/Wolfe/MyProject/INPUT/",$x);
$bin_ndvi=join('',"/data/Wolfe/MyProject/INPUT/ndvitmp/",$hdl_ndvi,".bin");
$open_tail=join('',"<",$bin_ndvi);

#append to array;
push @fl_ndvi, $bin_ndvi;

#make full tail;
$ndvi_tail=join(' ',$bin_ndvi,"-b",$src_tail);

#grab ndvi band;
system("hdp dumpsds -n '1 km 16 days NDVI' -d -o $ndvi_tail\n");
}
}

#open ndvi binary files;
$i=0;
for $x (@hdl_ndvi){
$y=@fl_ndvi[$i];
open($x,"<$y\n");
binmode $x;
$i=$i+1;
}

#make year array;
@y=(2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022);

#make max ndvi export files;
@max_hdl=();
for $y (@y){
$max_hdl=join('',"ndvi",$y);
push(@max_hdl, $max_hdl);




#make file name
$max_file=join('',"/data/Wolfe/MyProject/OUTPUT/",$max_hdl,".bin");
open($max_hdl,">$max_file\n");
}

#for loop to determine maximum NDVI value for each year;
for $y (@y){
	
#peak green up time;
@peak=();
$j1=0;
$j2=0;
$j3=0;
$j4=0;

#create array to be renewed each year handle;
@y_hdl=();

	#pull out file handles whose year match with regex;
	for $flhdl (@hdl_ndvi){
	if($flhdl=~m/\Q$y/){
	
	#match julian day to variable;
	if($flhdl=~m/097/){
	$hdl097=$flhdl;
	}
	#match julian day to variable;
	if($flhdl=~m/113/){
	$hdl113=$flhdl;
	}
	#match julian day to variable;
	if($flhdl=~m/129/){
	$hdl129=$flhdl;
	}
	#match julian day to variable;
	if($flhdl=~m/145/){
	$hdl145=$flhdl;
	}
	
	#append to year handle array;
	push @y_hdl, $hdl097;
	push @y_hdl, $hdl113;
	push @y_hdl, $hdl129;
	push @y_hdl, $hdl145;
	}

#make data files
my $data1;
my $data2;
my $data3;
my $data4;

while($nbytes1=read($hdl097,$data1,2)){
$oneV1=unpack("s*",$data1);
$nbytes2=read($hdl113,$data2,2);
$oneV2=unpack("s*",$data2);
$nbytes3=read($hdl129,$data3,2);
$oneV3=unpack("s*",$data3);
$nbytes4=read($hdl145,$data4,2);
$oneV4=unpack("s*",$data4);

#find max ndvi value;
if($oneV1>=$oneV2){
$ndvi=$oneV1;
}else{
$ndvi=$oneV2;
}
if($oneV3>$ndvi){
$ndvi=$oneV3;
}else{
$ndvi=$ndvi;
}
if($oneV4>$ndvi){
$ndvi=$oneV4;
}else{
$ndvi=$ndvi;
}

#calc peak green up time;
if($oneV1==$ndvi){
$j1=$j1+1;
}
if($oneV2==$ndvi){
$j2=$j2+1;
}
if($oneV3==$ndvi){
$j3=$j3+1;
}
if($oneV4==$ndvi){
$j4=$j4+1;
}



#create out scalar;
$out=join('',"ndvi",$y);

$output=pack("s*",$ndvi);
$fi=$output;
print $out $fi;
}
}
push @peak, $j1;
push @peak, $j2;
push @peak, $j3;
push @peak, $j4;

#open file to export text of day with peak green up;
$time=join("ndvipeak",$y);
$timetail=join('',"/data/Wolfe/MyProject/OUTPUT/",$time,".txt");
open($time,">$timetail\n");
print $time "$y\n peak counts
097 @peak[0]\n
113 @peak[1]\n
129 @peak[2]\n
145 @peak[3]\n
";
}



#open header files;
@hdr_ndvi=();
for $y (@y){
$hdr=join('',"/data/Wolfe/MyProject/OUTPUT/","ndvi",$y,".hdr");
$hdrhdl=join('',"ndvi",$y,"hdr");
push @hdr_ndvi, $hdrhdl;
open($hdrhdl,">$hdr\n");
}


for $x (@hdr_ndvi){
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

#close all file handles;
for $max (@max_hdl){
close($max);
}

for $y (@y){
$time=join("ndvipeak",$y);
close($time);
}



#append log file;
$timestamp=`date`;
print lg "
$timestamp\n
analysis script state: ended
";

close(lg);





