#!/usr/bin/perl

#execute all workflow scripts;
system("./download_tiles.pl");
system("./extract_bands.pl");
system("./ndvi_calc.pl");
system("./analysis.pl");


