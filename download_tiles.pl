#!/usr/bin/perl

#fetching 92 MODIS hdf files via http download. H10V04 covers most of South Dakota, that is the tile I will get. This focuses on 4 dates in April and May;

#open log file;
open(lg,">/data/Wolfe/MyProject/log.txt");

#append log file;
$timestamp=`date`;
print lg "
$timestamp\n
download_tiles script state: start
";

#make day of month, julian day, month, leap year, and regular year arrays. 2000 and every four years after are leap years (ly). leap years have different day of month values;
@lydapr=(6,22);
@lydmay=(8,24);
@dapr=(7,23);
@dmay=(9,25);
@japr=(97,113);
@jmay=(129,145);
@m=(4,5);
@ly=(2000,2004,2008,2012,2016,2020);
@y=(2001,2002,2003,2005,2006,2007,2009,2010,2011,2013,2014,2015,2017,2018,2019,2021,2022);

#make array of leap year directories I want to index;
@lydirtails=();

#make array of regular year directories I want to index;
@ydirtails=();

#for loop to get leap year day directory tails;
for $ly (@ly){

	#leap year month for loop;
	for $m (@m){

	#add 0 to month variable;
	if($m<10){
	$mm="0";
	$mm.=$m;
	}else{
	$mm=$m;
	}

	#process april;
	if ($m==04){
		#leap year april day for loop;
		for $lydapr (@lydapr){

		#add 0 to day variable;
		if($lydapr<10){
		$lydaprr="0";
		$lydaprr.=$lydapr;
		}else{
		$lydaprr=$lydapr;
		}

		#set index directory tail;
		$tail=join('.',$ly,$mm,$lydaprr);
		$taill=join('',$tail,"/");

		#append to directory tails array
		push @lydirtails, $taill;
		}
		}
	#process may;	
	if ($m==05){
		#leap year may day for loop;
		for $lydmay (@lydmay){

		#add 0 to day variable;
		if($lydmay<10){
		$lydmayy="0";
		$lydmayy.=$lydmay;
		}else{
		$lydmayy=$lydmay;
		}

		#set index directory tail;
		$tail=join('.',$ly,$mm,$lydmayy);
		$taill=join('',$tail,"/");

		#append to directory tails array
		push @lydirtails, $taill;
		}
		}
	}
}

#for loop to get regular year day directory tails;
for $y (@y){

	#leap year month for loop;
	for $m (@m){

	#add 0 to month variable;
	if($m<10){
	$mm="0";
	$mm.=$m;
	}else{
	$mm=$m;
	}

	#process april;
	if ($m==04){
		#regular year april day for loop;
		for $dapr (@dapr){

		#add 0 to day variable;
		if($dapr<10){
		$daprr="0";
		$daprr.=$dapr;
		}else{
		$daprr=$dapr;
		}

		#set index directory tail;
		$tail=join('.',$y,$mm,$daprr);
		$taill=join('',$tail,"/");

		#append to directory tails array;
		push @ydirtails, $taill;
		}
		}
	#process may;	
	if ($m==05){
		#regular year may day for loop;
		for $dmay (@dmay){

		#add 0 to day variable;
		if($dmay<10){
		$dmayy="0";
		$dmayy.=$dmay;
		}else{
		$dmayy=$dmay;
		}

		#set index directory tail;
		$tail=join('.',$y,$mm,$dmayy);
		$taill=join('',$tail,"/");

		#append to directory tails array;
		push @ydirtails, $taill;
		}
		}
	}
}


#make array of all the files I want to fetch;
@hdffiles=();

#for loop to get names of all leap year hdf files I want to fetch;
for $tail (@lydirtails){

	#make index file;
	system("wget https://e4ftl01.cr.usgs.gov/MOLT/MOD13A2.006/$tail\n");
	open(dex,"</data/Wolfe/MyProject/SOURCE/index.html");

	#break index into an array of each record;
	@fileindex=<dex>;

	#for loop to parse file names;
	for $line (@fileindex){

		#for loop to make a leap year file name for each;
		for $ly (@ly){
			
			#for loop to process each april julian day;
			#set iteration for tail appending;
			$i=0;
			for $j (@japr){

				#add 0 to julian day variable;
				if($j<100){
				$jj="0";
				$jj.=$j;
				}else{
				$jj=$j;
				}

				#define file name;
				$match=join('',"$ly","$jj");

				#regular expression to match for tile h10v04;
				if($line=~m/hdf">MOD13A2/){
				if($line=~m/h10v04/){
				if($line=~m/\Q$match/){

				#split to extract file name from HTML;
				$file=(split('>',$line))[2];
				$file=(split('<',$file))[0];

				#add 0 to day variable;
				if(@lydapr[$i]<10){
				$lydaprr="0";
				$lydaprr.=@lydapr[$i];
				}else{
				$lydaprr=@lydapr[$i];
				}

				#make full tail for hdf;
				$taill=join('.',$ly,"04",$lydaprr);
				$tailll=join('/',$taill,$file);

				#append to hdf file array;
				push @hdffiles, $tailll;
				}
				}
				}
				
				#move iteration forward 1;
				$i=$i+1;
			}

			#for loop to process each may julian day;
			#set iteration for tail appending;
			$i=0;
			for $j (@jmay){

				#add 0 to julian day variable;
				if($j<100){
				$jj="0";
				$jj.=$j;
				}else{
				$jj=$j;
				}

				#define file name;
				$match=join('',"$ly","$jj");

				#regular expression to match for tile h10v04;
				if($line=~m/hdf">MOD13A2/){
				if($line=~m/h10v04/){
				if($line=~m/\Q$match/){

				#split to extract file name from HTML;
				$file=(split('>',$line))[2];
				$file=(split('<',$file))[0];

				#add 0 to day variable;
				if(@lydmay[$i]<10){
				$lydmayy="0";
				$lydmayy.=@lydmay[$i];
				}else{
				$lydmayy=@lydmay[$i];
				}

				#make full tail for hdf;
				$taill=join('.',$ly,"05",$lydmayy);
				$tailll=join('/',$taill,$file);

				#append to hdf file array;
				push @hdffiles, $tailll;
				}
				}
				}
				
				#move iteration forward 1;
				$i=$i+1;
			}
		}
	}
close(dex);
system("rm index.html");
}

#for loop to get names of all regular year hdf files I want to fetch;
for $tail (@ydirtails){

	#make index file;
	system("wget https://e4ftl01.cr.usgs.gov/MOLT/MOD13A2.006/$tail\n");
	open(dex,"</data/Wolfe/MyProject/SOURCE/index.html");

	#break index into an array of each record;
	@fileindex=<dex>;

	#for loop to parse file names;
	for $line (@fileindex){

		#for loop to make a regular year file name for each;
		for $y (@y){
			
			#for loop to process each april julian day;
			#set iteration for tail appending;
			$i=0;
			for $j (@japr){

				#add 0 to julian day variable;
				if($j<100){
				$jj="0";
				$jj.=$j;
				}else{
				$jj=$j;
				}

				#define file name;
				$match=join('',"$y","$jj");

				#regular expression to match for tile h10v04;
				if($line=~m/hdf">MOD13A2/){
				if($line=~m/h10v04/){
				if($line=~m/\Q$match/){

				#split to extract file name from HTML;
				$file=(split('>',$line))[2];
				$file=(split('<',$file))[0];

				#add 0 to day variable;
				if(@dapr[$i]<10){
				$daprr="0";
				$daprr.=@dapr[$i];
				}else{
				$daprr=@dapr[$i];
				}

				#make full tail for hdf;
				$taill=join('.',$y,"04",$daprr);
				$tailll=join('/',$taill,$file);

				#append to hdf file array;
				push @hdffiles, $tailll;
				}
				}
				}
				
				#move iteration forward 1;
				$i=$i+1;
			}

			#for loop to process each may julian day;
			#set iteration for tail appending;
			$i=0;
			for $j (@jmay){

				#add 0 to julian day variable;
				if($j<100){
				$jj="0";
				$jj.=$j;
				}else{
				$jj=$j;
				}

				#define file name;
				$match=join('',"$y","$jj");

				#regular expression to match for tile h10v04;
				if($line=~m/hdf">MOD13A2/){
				if($line=~m/h10v04/){
				if($line=~m/\Q$match/){

				#split to extract file name from HTML;
				$file=(split('>',$line))[2];
				$file=(split('<',$file))[0];

				#add 0 to day variable;
				if(@dmay[$i]<10){
				$dmayy="0";
				$dmayy.=@dmay[$i];
				}else{
				$dmayy=@dmay[$i];
				}

				#make full tail for hdf;
				$taill=join('.',$y,"05",$dmayy);
				$tailll=join('/',$taill,$file);

				#append to hdf file array;
				push @hdffiles, $tailll;
				}
				}
				}
				
				#move iteration forward 1;
				$i=$i+1;
			}
		}
	}
close(dex);
system("rm index.html");
}

#for loop to fetch all hdf files;
for $hdf (@hdffiles){

#log timestamp begin download;
$timestamp=`date`;
print lg "
$timestamp\n 
$hdf\n download began
";

#get final hdf raster;
system("wget --user='hdwolfe' --password='H1d15w95!' https://e4ftl01.cr.usgs.gov/MOLT/MOD13A2.006/$hdf\n");

#log timestamp ended download;
$timestamp=`date`;
print lg "
$timestamp\n 
$hdf\n download ended
";
}

#move all hdf files to 
system("mv *hdf ../INPUT");

#append log file;
$timestamp=`date`;
print lg "
$timestamp\n
analysis script state: ended
";

close(lg);
