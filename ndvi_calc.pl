#!/usr/bin/perl

#perform ndvi calculation for each tile;

#open log file;
open(lg,">>/data/Wolfe/MyProject/log.txt");

#append log file;
$timestamp=`date`;
print lg "
$timestamp\n
ndvi calculation script state: start
";

#remove any tmp files from bands; some are created when files are opened;
system("rm ../INPUT/bands/*enp");

#grab file names to import;
@bands=`ls ../INPUT/bands`;

#make file handle arrays;
@hdl_red=();
@hdl_nir=();

#make file name arrays;
@fl_red=();
@fl_nir=();

#for loop to sort bands into file names and handles;
for $x (@bands){
if ($x=~m/red/){
push @fl_red, $x;
$hdl=substr($x,0,10);
$hdll=join('',"red",$hdl);
push @hdl_red,$hdll;
}
if ($x=~m/nir/){
push @fl_nir, $x;
$hdl=substr($x,0,10);
$hdll=join('',"nir",$hdl);
push @hdl_nir,$hdll;
}
}

#for loop to open each file handle
$i=0;
for $x (@hdl_red){
$y=@fl_red[$i];
$z=join('',"/data/Wolfe/MyProject/INPUT/bands/",$y);
open($x,"<$z\n");
$i=$i+1;
}
$i=0;
for $x (@hdl_nir){
$y=@fl_nir[$i];
$z=join('',"/data/Wolfe/MyProject/INPUT/bands/",$y);
open($x,"<$z\n");
$i=$i+1;
}

#for loop to set them all to binary mode;
for $x (@hdl_red){
binmode $x;
}
for $x (@hdl_nir){
binmode $x;
}

#make ndvi input directory;
system("mkdir ../INPUT/ndvi");

#make extract file handles;
@hdl_ndvi=();
@fl_ndvi=();

for $x (@hdl_red){
$y=substr($x,0,7);
$z=join('',$y,"ndvi");

#append file handles;
push @hdl_ndvi, $z;

#make file names;
$w=join('.',$z,"bin");

#append file names;
push @fl_ndvi, $w;

#open file handles;
$s=join('',"/data/Wolfe/MyProject/INPUT/ndvi/",$w);
open($z,">$s\n");
}



#make ndvi bin files;
for $x (@hdl_ndvi){
binmode $x;
}


#designate fill value so not to divide by 0;
$fill_value = -999;

#loop both tiles;
$i=0;
for $x (@hdl_red){

#using hdfview
my $col=1200;
my $row=1200;

my $data;
my $data1;
my $data2;
while($nbytes1=read($x,$data1,2)){
$oneV1=unpack("s*",$data1);
$nbytes2=read(@hdl_nir[$i],$data2,2);
$oneV2=unpack("s*",$data2);

if(($oneV1==$fill_value)||($oneV2==$fill_value)||($oneV2==0)){
$NDVI=$fill_value;
}else{
$num=($oneV2-$oneV1);
$den=($oneV2+$oneV1);

if ($den==0){
$NDVI=$fill_value;
}else{
$NDVI=$num/$den;
}
}
#create out scalar;
$out=join('_',"ndvi",$y);

$output=pack("s*",$NDVI);
$fi=@hdl_ndvi[$i];
print $fi $output;
}
$i=$i+1;
}

#define header path;
@hdr_ndvi=();
@tail_ndvi=();
for $x (@hdl_ndvi){
$tail_ndvi=join('',"/data/Wolfe/MyProject/INPUT/ndvi/",$x,".hdr");
$hdr_ndvi=join('',$x,".hdr");
	#append to hdr path arrays;
	push @hdr_ndvi, $hdr_ndvi;
	push @tail_ndvi, $tail_ndvi;
open($hdr_ndvi,">$tail_ndvi\n");
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



#close file handles
for $x (@hdl_red){
close($x);
}
for $x (@hdl_nir){
close($x);
}
for $x (@hdl_ndvi){
close($x);
}

#append log file;
$timestamp=`date`;
print lg "
$timestamp\n
ndvi calculation script state: ended
";

close(lg);
