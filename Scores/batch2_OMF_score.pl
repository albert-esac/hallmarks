#!usr/bin/perl -w
use strict;
use warnings;

my %cancer=();
open(FIN, "<./cancer_type.txt") or die "Can't open FIN: $!";
while(<FIN>) {
	chomp;
	my $c = $_;
	$cancer{$c}=1;
	#system("mkdir ./batch1_score/$c");
	#system("mkdir ./batch1_log/$c");
}
close(FIN);
print "cancer type done\n";

my $tmpdir = "./batch1_tmp";
opendir ( DIR, $tmpdir ) || die "Error in opening dir $tmpdir\n";
while( (my $fn = readdir(DIR))) {
	if($fn =~ /(GSE\d+)\.tpm\.tsv\.tmp/){
		my $gse = $1;
		my $tmp = "$tmpdir/$fn";
		print "$gse start Score Calculation\n";
		
		foreach my $ct (keys %cancer){
			my $score = "./batch1_score/$ct/$gse.$ct.score";
			my $log = "./batch1_log/$ct/$gse.$ct.log";
			system("Rscript run_sigs.R $ct $tmp $score > $log");
		}
		print "$gse done\n";
	}
}
closedir(DIR);
