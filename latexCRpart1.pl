#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: Report.GeneID.pl
#
#        USAGE: ./Report.GeneID.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2016年10月25日 12时17分51秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
#use utf8;
#use Encode;
use Getopt::Long;
use POSIX;
use Data::Dumper;
use feature qw/say/;
use Data::Dumper;
use List::Util qw/max min sum maxstr minstr shuffle/;
use List::MoreUtils qw(mesh);
use Math::Round;

my ($gresult,$out,$yresult);
GetOptions(
	'in=s'	=> \$gresult,
	'intwo=s'	=> \$yresult,
	'out=s'	=> \$out,
);

############################mainscript#####################
open CRSITE,$ARGV[0] or die $!;
my %site_gene;
while (<CRSITE>){
	chomp;
	next if /^sample|^#/i;
	my @cut=split/\t/;
	$site_gene{join"\t",@cut[4..8,10]}=[@cut[10,76,77]];
}
close CRSITE;

open CRIN,$ARGV[1] or die $!;
my (%alltotalput,%genesiteall,%allsitemass,%totaloutput,$idnumer);
while (<CRIN>){
	chomp;
    next if /^sample|^#/i;
    my @cut=split/\t/;
	my $valu = $site_gene{join"\t",@cut[2..7]} // ["-","-","-"];
	my ($gene,$mutationc,$mutationp)=@$valu;
	$mutationc=~s/_/\\_/g;
	$mutationp=~s/_/\\_/g;
	$cut[119]=~s/_/\\_/g;
	$cut[119]=~s/%/\\%/g;
	$cut[120]=~s/_/\\_/g;
	$cut[120]=~s/%/\\%/g;
	$cut[121]=~s/_/\\_/g;
	$cut[121]=~s/%/\\%/g;
	$cut[122]=~s/(\|)+/  \\par  /g;
	my $flag =
		((join"",@cut[2..5]) eq "----") ? "E" :
		($cut[112] eq '良性') ? "A1" : ($cut[112] eq '可能良性') ? "A2" :
		($cut[112] eq '致病') ? "B1" : ($cut[112] eq '可能致病') ? "B2" :
		($cut[112] eq "临床意义未明")  ? "C"  : "D" ;
	push @{$alltotalput{$cut[0]}{$cut[113]}},[@cut[111..122],$gene,$mutationc,$mutationp,$flag];
	$genesiteall{$cut[0]}{$flag}{$gene."——".$mutationc.": ".$mutationp}=[@cut[119..121]];
}
close CRIN;
####################main section-CRpart1#####################
open OUT, ">$ARGV[2]aa.tex" or die $!;
#yanghuan		say OUT &introductionpackge;
foreach my $idsample (keys %alltotalput){
#	say OUT &introductionpackge;
#		say OUT &mianpart("6-1.pdf","Part 1","检测结果概况","主要检测结果及风险预测");
#		say OUT "\\begin{CRpart1}";
		say OUT &headerfooter($idsample,"主要检测结果及风险提示","7-3.pdf","检测结果概况");
		say OUT &summarytable(&crpart1tablea($idsample));
#say OUT "\\end{CRpart1}";
#say OUT "\\end{document}";
}
#yanghuan		say OUT "\\end{document}";
close OUT;
#########################sub region#########################
sub crpart1tablea{
	my $idnumber=shift;
	my (@flagsall,$tableoutp,$conlusion);
	foreach my $cancera ( keys %{$alltotalput{$idnumber}}){
		@flagsall = map{$_->[15]}@{$alltotalput{$idnumber}{$cancera}};
	}
	my $flagsseq=join"", @flagsall;
	if ($flagsseq=~m/E/i and $flagsseq!~m/A|B|C|D/i){
		($tableoutp,$conlusion)=
		('遗传性肿瘤 & & 未检出突变位点 & & \\tabularnewline',
		 "\\specialrule{0em}{1pt}{1pt}\n\\multicolumn{5}{L{16.8cm}}{此次遗传性肿瘤风险预测，包含17个癌种，106个遗传性肿瘤易感基因。结果显示您在所检测的遗传性肿瘤易感基因未检出突变位点，患癌风险为普通人群风险，请避免环境致癌因素，定期体检、坚持锻炼、保持健康心态。	} \\tabularnewline \\arrayrulecolor{MyGreen} \\hline"
		);
	}elsif ($flagsseq=~m/A|D/i and $flagsseq!~m/B|C|E/i){
		($tableoutp,$conlusion)=
		('遗传性肿瘤 & & 仅检出良性突变位点 & & \\tabularnewline',
		 "\\specialrule{0em}{1pt}{1pt}\n\\multicolumn{5}{L{16.8cm}}{此次遗传性肿瘤风险预测，包含17个癌种，106个遗传性肿瘤易感基因。结果显示您在所检测的遗传性肿瘤易感基因仅检出良性突变位点，患癌风险为普通人群风险，请避免环境致癌因素，定期体检、坚持锻炼、保持健康心态。	} \\tabularnewline \\arrayrulecolor{MyGreen} \\hline"
		);
	}elsif ($flagsseq=~m/B|C/i and $flagsseq!~m/E/i){
		my (@allgens,@unknows,@deathal,%count1,@trislow,@trisris,@trishei,@tableco);
		my @allcanc= keys %{$alltotalput{$idnumber}};
		foreach my $cancer ( keys %{$alltotalput{$idnumber}}){
			my @allterm=@{$alltotalput{$idnumber}{$cancer}};
			my (@agenmut,$yourris,$peopris,$ristype);
			foreach my $term_site (@allterm){
				next if ($term_site ->[15]=~/A|D/i);
				push @agenmut, (join" ", @$term_site[12,13]);
				($yourris,$peopris,$ristype)=@$term_site[3,5,6];
				if (++$count1{$term_site->[12]} <2){
					(push @allgens, $term_site->[12]);
					(push @unknows, (join" ", @$term_site[12,13])) if ($term_site->[15]=~m/C/i);
					(push @deathal, (join" ", @$term_site[12,13])) if ($term_site->[15]=~m/B/i);
				}
				if (++$count1{join"\t",@$term_site[2,6]} <2){
					(push @trislow, $term_site->[2]) if ($term_site->[6]=~m/低风险/i);
					(push @trisris, $term_site->[2]) if ($term_site->[6]=~m/风险升高/i);
					(push @trishei, $term_site->[2]) if ($term_site->[6]=~m/高风险/i);
				}
			}
			if (@agenmut){
				my $yourisk =&percent($yourris); 
				my $peorisk =&percent($peopris);
				my $riskcol =
					($ristype =~m/低风险/i)    ?  "\\color{green}{低风险}"	  :
					($ristype =~m/风险升高/i)  ?  "\\color{orange}{风险升高}" :
					($ristype =~m/高风险/i)    ?  "\\color{red}{高风险}"	  : "?" ;
				my $genemut = join "\\\\", @agenmut;
				my $taluecon="\\specialrule{0em}{1pt}{1pt}\n"."$cancer & \\makecell[l]{$genemut} & \\makecell[l]{\\fontsize{12}{12}{\\sye \\color{MyGreen}{$yourisk}} \\\\ 您的患病概率} & \\makecell[l]{\\fontsize{12}{12}{\\sye $peorisk} \\\\平均概率} & \\sym $riskcol \\tabularnewline";
				push @tableco,$taluecon;
			}
		}
		my $genes=(@allgens) ? &linke(@allgens) : "?";
		my $cancs=(@allcanc) ? &linke(@allcanc) : "?";

		my $unkno=(@unknows) ? &linke(@unknows)."位点为临床意义未明位点" : "?";
		my $death=(@deathal) ? &linke(@deathal)."位点为致病位点"		 : "?";		
		my $lowri=(@trislow) ? "罹患".&linke(@trislow)."肿瘤的发病风险较普通人群风险为低风险"   : "?";
		my $risri=(@trisris) ? "罹患".&linke(@trisris)."肿瘤的发病风险较普通人群风险为风险升高" : "?";
		my $heiri=(@trishei) ? "罹患".&linke(@trishei)."肿瘤的发病风险较普通人群风险为高风险"   : "?";
	
		my @aclin=grep{$_ ne "?"}($unkno,$death); 	
		my @arisk=grep{$_ ne "?"}($lowri,$risri,$heiri);
		my $allcl=join";", @aclin;
		my $allri=join";", @arisk;
	
		$tableoutp= join"\n",@tableco;
		$conlusion="\\specialrule{0em}{1pt}{1pt}\n"."\\multicolumn{5}{L{16.8cm}}{根据基因检测结果，您携带${genes}基因突变，与${cancs}相关。根据目前科学研究，${allcl}。${allri}。本报告制定了健康管理方案，请您定期体检，保持健康生活方式、保持良好心态。} \\tabularnewline \\arrayrulecolor{MyGreen} \\hline";
	}else{
		($tableoutp,$conlusion)=("?","?");
	}
	return ($tableoutp,$conlusion);
}

sub summarytable{
	my @input=@_;
	my $output=
qq[%%%%%%%%%%%%%%%%table%%%%%%%%%%%%%%%%%%
\\newpage
\\noindent
\\includegraphics[height=0.40cm]{9-3.pdf}
\\fontsize{14}{16.8}{\\sym \\sye \\color{MyDarkBlue}\\ 您\\,的\\,疾\\,病\\,风\\,险}
\\vspace*{-5mm}
\\begin{center}
\\fontsize{9}{10.8}\\selectfont \\color{MyFontGray}
\\renewcommand\\arraystretch{1.3}
\\rowcolors{3}{MyLightGreen}{}
\\begin{tabular}{L{3.0cm} C{4cm} C{3.1cm} C{2.5cm} C{2.5cm}} 
\\rowcolor{MyGreen}
\\fontsize{12}{12}\\sym\\sye \\color{white} 遗传性肿瘤 & &  \\fontsize{12}{12}\\sym\\sye \\color{white} 基因检测结果 & & \\tabularnewline
$input[0] \n
$input[1] \n
\\end{tabular}
\\end{center}
%%%%%%%%%%%%%%%%%%%%endtable%%%%%%%%%%%%%%
];
	return $output;
}

sub linke{
	my @input=@_;
	my $ouput=(@input >1) ? join"和", ((join"、", @input[0..$#input-1]), $input[-1] ) : $input[0];
	return $ouput;
}

sub percent{
	my $input=shift;
	my ($ouput1,$ouput2)=
		($input>0.0001) ? ((sprintf '%.2f',100*$input),'\\%') :
		($input>0.00001) ? ((sprintf '%.4f', 100*$input),'\\%') : ((sprintf '%.4f', 1000*$input),'\\textperthousand');
	return (join"",($ouput1,$ouput2));
}
sub mianpart{
    my @input=@_;
    my $cover=
    qq[%%%%%%%%%%%%%%%%%%%cover%%%%%%%%%%%%%%%%%%
%yanghuan\\newpage
%yanghuan\\thispagestyle{empty}
%yanghuan\\ThisTileWallPaper{\\paperwidth}{\\paperheight}{$input[0]}
%yanghuan\\color{white}
%yanghuan\\begin{picture}(3,30)
%yanghuan\\begin{overpic}
%yanghuan	\\put(63,-90){\\fontsize{72}{86.4} \\sym \\sye $input[1]}
%yanghuan	\\put(63,-160){\\fontsize{40}{48} \\sym \\sye $input[2]}
%yanghuan	\\put(63,-200){\\fontsize{20}{24} $input[3]}
%yanghuan\\end{overpic}
%yanghuan\\end{picture}
%%%%%%%%%%%%%%%%%%%end%%%%%%%%%%%%%%%%%%%%];
    return $cover;
}

sub headerfooter{
    my @input=@_;
	   $input[0]=~tr/[0-9]/[A-J]/;
    my $header_footer=
qq[%%%%%%%%%%%%%%header_and_footer%%%%%%%%%%%%%%%
\\newsavebox{\\$input[0]}
\\arrayrulecolor{white}
\\sbox{\\$input[0]}{\\mbox{
	\\begin{tabular}{L{12.5cm} L{4cm}}
	    \\cellcolor{MyLightGreen}\\color{MyDarkBlue}{\\fontsize{23}{27.6}{\\sym{$input[1]}}} &
		\\multirow{2}*{\\includegraphics[height=3.75cm,width=4cm]{$input[2]}} \\\\ [1.8cm]\\cmidrule{1-1}
		\\cellcolor{MyLightGreen}\\color{MyFontGray}{\\fontsize{15}{18}{$input[3]}} & \\\\ [0.77cm]
	\\end{tabular}}}

\\fancyhead[C]{\\usebox{\\$input[0]}}
\\fancyfoot[RO,LE]{\\zihao{6} Novo\\_\\thepage}
%%%%%%%%%%%%%%%%%%end%%%%%%%%%%%%%%%%%%%%%%%%%%];
    return $header_footer;
}

sub introductionpackge{
	my $introduction=<<'END';
%-*- coding: UTF-8 -*-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%导言，加载宏包
\documentclass[UTF8,noindent,twoside]{ctexrep}
\usepackage{blkarray,fancyvrb,ltxtable,multirow,colortbl,array,makecell,fancyhdr,graphicx,multicol,balance,amssymb,setspace,dcolumn,booktabs,tabularx,longtable,wallpaper,tabu,makeidx,algorithm,algorithmic,changepage,indentfirst,fontspec,wrapfig,picinpar,enumerate,pdfpages,textcomp}
\usepackage[abs]{overpic}
\usepackage[a4paper,left=2cm,right=2cm,top=8.5cm,bottom=1.75cm,headheight=4cm,headsep=2.5cm]{geometry}
\usepackage[table]{xcolor}
\usepackage[center]{titlesec}
\graphicspath{{/ifs/TJPROJ3/HEALTH/zhouwei/latex/figpdf/}}
\definecolor{green}{HTML}{539B34}
\definecolor{yellow}{HTML}{FABE00}
\definecolor{orange}{HTML}{ED6D2A}
\definecolor{red}{HTML}{E60012}
\definecolor{MyDarkBlue}{HTML}{539B35}
\definecolor{MyLightGreen}{HTML}{F4F7EF}
\definecolor{MyGreen}{HTML}{539B35}
\definecolor{tabcolor}{HTML}{539B35}
\definecolor{MyFontGray}{HTML}{4C4949}
%Font setting
\setmainfont{SourceHanSansCN-Light.ttf} %默认字体
\setCJKmainfont{SourceHanSansCN-Light.ttf}
\newfontfamily\sye{SourceHanSansCN-Medium.ttf}
\newCJKfontfamily\sym{SourceHanSansCN-Medium.ttf}
%table format command
\newcolumntype{C}[1]{>{\centering\arraybackslash}m{#1}}
\newcolumntype{L}[1]{>{\raggedright\arraybackslash}m{#1}}
\newcolumntype{R}[1]{>{\raggedleft\arraybackslash}m{#1}}
\newcolumntype{Y}{>{\centering\arraybackslash}X}
\newcommand{\tabincell}[2]{\begin{tabular}{@{}#1@{}}#2\end{tabular}}
\titleformat{\section}{\centering\zihao{-2}}{}{2em}{}
%pageHeader setting
\pagestyle{fancy}
%\pagestyle{myheadings}
\fancyhf{}
\renewcommand{\headrulewidth}{0.0pt}
\renewcommand{\footrulewidth}{0.0pt}
\newcolumntype{S}{@{}m{0pt}@{}}
\parindent=0pt
\parskip=1.5ex
\hfuzz=\maxdimen
\tolerance=10000
\hbadness=10000
\hfuzz=150pt
%\setlength{\headheight}{4cm}
\makeatletter %双线页眉
%\def\headrule{{\color{MyDarkBlue}\if@fancyplain\let\headrulewidth\plainheadrulewidth\fi
%\hrule\@height 0.0pt \@width\headwidth\vskip1pt%上面线为1pt粗
%\vskip-2\headrulewidth\vskip-3pt} %两条线的距离1pt
%\vspace{3mm}} %双线与下面正文之间的垂直间距
\makeindex
\newenvironment{CRpart}{\noindent}{\noindent}
\newenvironment{CRpart1}{\noindent}{\noindent}
\newenvironment{CRpart2}{\noindent}{\noindent}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%begin document %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{document}
END
	return $introduction;
}
