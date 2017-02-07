#!/usr/bin/env perl
##===============================================================================
##
##         FILE: Report.GeneID.pl
##
##        USAGE: ./Report.GeneID.pl
##
##  DESCRIPTION:
##
##      OPTIONS: ---
## REQUIREMENTS: ---
##         BUGS: ---
##        NOTES: ---
##       AUTHOR: YOUR NAME (),
## ORGANIZATION:
##      VERSION: 1.0
##      CREATED: 2016年12月14日 0时0分0秒
##     REVISION: ---
##==============================================================================
use strict;
use warnings;
use utf8;
use Encode;
use Getopt::Long;
use POSIX;
use Data::Dumper;
use feature qw/say/;
use Data::Dumper;
use List::Util qw/max min sum maxstr minstr shuffle/;
use List::MoreUtils qw(mesh);

my ($list,$yemei,$cfg,$result,$out,$date,$tex,$name,$dingdan,$yangpin,$sex,$houzhui);
GetOptions(
			'yemei=s'	=> \$yemei,
			'cfg=s'	=> \$cfg,
			'out=s'	=> \$out,
		);
my ($out1,$out2)=@ARGV;

#################################################
$date=`date +"%Y-%m-%d"`;
$date=~s/\s+//g;
################# sub-head #####################
sub headerfooter{
	    my @input=@_;
	    my $header_footer=
		qq[%%%%%%%%%%%%%%header_and_footer%%%%%%%%%%%%%%%
			\\pagestyle{fancy}
			\\newsavebox{\\mygraphic}
			\\arrayrulecolor{white}
			\\sbox{\\mygraphic}{\\mbox{
		    \\begin{tabular}{L{12.5cm} L{4cm}}
			        \\cellcolor{MyLightGreen}\\color{MyDarkBlue}{\\fontsize{23}{27.6}{\\sym{$input[0]}}} &
			        \\multirow{2}*{\\includegraphics[height=3.75cm,width=4cm]{$input[1]}} \\\\ [1.8cm]\\cmidrule{1-1}
			        \\cellcolor{MyLightGreen}\\color{MyFontGray}{\\fontsize{15}{18}{$input[2]}} & \\\\ [0.77cm]
			\\end{tabular}}}
			\\fancyhead[C]{\\usebox{\\mygraphic}}
			\\fancyfoot[RO,LE]{\\zihao{6} Novo\\_\\thepage}
			%%%%%%%%%%%%%%%%%%end%%%%%%%%%%%%%%%%%%%%%%%%%%];
		return $header_footer;
}
####################### sub2  #######################################
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
\setmainfont{Source Han Sans CN Light} %默认字体
%\defaultfontfeatures{fontsize={9.5}{}}
\setCJKmainfont{Source Han Sans CN Light}
\newfontfamily\sye{Source Han Sans CN Medium}
\newCJKfontfamily[SIYUAN]\sym{Source Han Sans CN Medium}
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
\hfuzz=150pt
%\setlength{\headheight}{4cm}
\makeatletter %双线页眉
%\def\headrule{{\color{MyDarkBlue}\if@fancyplain\let\headrulewidth\plainheadrulewidth\fi
%\hrule\@height 0.0pt \@width\headwidth\vskip1pt%上面线为1pt粗
%\vskip-2\headrulewidth\vskip-3pt} %两条线的距离1pt
%\vspace{3mm}} %双线与下面正文之间的垂直间距
\makeindex
\newenvironment{CRpart}{\noindent}{\par\noindent}
\newenvironment{GXYpart}{\noindent}{\par\noindent}
\newenvironment{YMpart}{\noindent}{\par\noindent}     %panqi
\newenvironment{JKpart}{\noindent}{\par\noindent}     %panqi
\newenvironment{healthpart}{\noindent}{\par\noindent}
\begin{document}
%%%%%%%%%%%%%%%%%%%%%%%%%%%% define headings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% fengmian %%%%%%
\fancypagestyle{plain}{
	\fancyhf{}
	\fancyhead[C]{}
	\fancyfoot[RO,LE]{\zihao{6} Novo\_\thepage}
}
END

###################### fengmianye #########################################
my $fengmianye=<<'END';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Report Face %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%封面页
\newpage
\begin{titlepage}
\thispagestyle{empty}
%\ThisTileWallPaper{\paperwidth}{\paperheight}{1.pdf}
\hspace*{3cm} \\
\end{titlepage}
%封面2页
\newpage
\begin{titlepage}
\thispagestyle{empty}
%\ThisTileWallPaper{\paperwidth}{\paperheight}{2.pdf}
\hspace*{3cm} \\
\end{titlepage}
%封面3页
\newpage
\begin{titlepage}
\thispagestyle{plain}
%\ThisTileWallPaper{\paperwidth}{\paperheight}{3.pdf}
\hspace*{3cm} \\
\end{titlepage}
%封面4页
\newpage
%\begin{titlepage}
\thispagestyle{plain}
%\ThisTileWallPaper{\paperwidth}{\paperheight}{4.pdf}
\hspace*{3cm} \\
%\end{titlepage}
%封面5页
\newpage
\newgeometry{left=2cm,right=2cm,top=2.5cm,bottom=2.3cm,headheight=2cm,footskip=1.75cm}
\thispagestyle{plain}
\noindent
{\fontsize{23}{} {\color{MyDarkBlue} \sym{一封信}}} \\
END


open CFG,"<:encoding(utf-8)","$cfg" || die "can't open the $cfg!";
while (<CFG>){
	    chomp;
		/ref/ && next;
		my @arr=split/\t/,$_;
		$sex=$arr[5];
#		if ($sex=~/男/){$houzhui="先生";}else{$houzhui="女士";}
			$name=$arr[4];
			$yangpin=$arr[7];
			$dingdan=$arr[0];
}

    my $ini=qq[\\hspace*{12cm} \\zihao{-5} \\color{MyDarkBlue} 订单编号:\\ \\ $dingdan \\\\
			\\hspace*{12cm} \\zihao{-5} \\color{MyDarkBlue} 样品编号:\\ \\ $yangpin \\\\
			\\hspace*{12cm} \\zihao{-5} \\color{MyDarkBlue} 报告日期:\\ \\ $date \\\\
			\\vspace*{0.3cm} \\\\ \\begin{spacing}{1.5} \\noindent
{\\fontsize{12}{}{\\color{MyFontGray} \\sym\\sye{尊敬的$name 先生／女士:}}}\\\\];
close CFG;

my $letter=<<'END';
\\
\noindent
{\fontsize{12}{}{\color{MyFontGray} \sym{您好！}}} \\
\setlength{\columnsep}{3pc}
\begin{multicols}{2}
\noindent \color{MyFontGray}\zihao{-5}衷心感谢您对我们的信任，选择诺禾医学检验所的个人基因组检测服务！\\ \\
\color{MyFontGray}\zihao{-5}您知道吗？我们每个人由几十万亿细胞构成，每个细胞含有 23 对染色体，在这些染色体上分布有几万个基因。基因序列的不同决定了形形色色的我们，它决定了我们是单眼皮还是双眼皮，决定了我们是像妈妈还是像爸爸，甚至决定了您是否容易患癌症，您的宝宝是否会患先天性疾病。基因检测就是破解基因的密码，将它翻译成我们能看懂的检测报告，从中找出它蕴含的关于我们健康的信息。\\ \\
\color{MyFontGray}\zihao{-5}基因与健康息息相关，基因检测报告是对您的健康本质最精准、最可靠的解读，我们为您评估了七种不同类型的潜在健康风险并提供应对方案，帮助您更主动地掌握您和家人的健康。\\ \\
\color{MyFontGray}\zihao{-5}1. 为您预防癌症的发生，筛查 17 种遗传性肿瘤的易感基因；\\ \\
\color{MyFontGray}\zihao{-5}2. 帮您避免因剧烈运动或高负荷工作引起的猝死风险，筛查 21 种导致猝死的心血管疾病；\\ \\
\color{MyFontGray}\zihao{-5}3. 如果您是高血压患者，为您找到真正致病原因，从而针对性诊断和用药；\\ \\
\color{MyFontGray}\zihao{-5}4. 帮您提高用药效率，避免副作用，筛查使用时需注意的 45 种药物，其中还包括筛查 14 种单基因高血压的致病基因，
五大类降压药敏感基因；\\ \\
\color{MyFontGray}\zihao{-5}5. 如果您是孕妇，帮您选择服用多少剂量的叶酸，保障宝宝健康；\\ \\
\color{MyFontGray}\zihao{-5}6. 帮您用基因来解释您的个人体质，比如为什么喝酒脸红？\\ \\
\color{MyFontGray}\zihao{-5}7. 对 133 种遗传病进行基因检测，筛查突变位点携带情况，为您提示生育风险，有效避免严重遗传病的发生。\\ \\	
\color{MyFontGray}\zihao{-5}诺禾致源致力于应用基因组技术，探索人类基因与健康的秘密，已和国内科学家合作为 2 万中国人进行基因测序和疾病关
联分析，相应研究成果发表在国际顶级杂志（可通过微信公众号了解更多）。诺禾致源基于亚太规模最大的基因测序平台和大数据积累，为中国人带来最专业的基因健康管理产品。\\ \\
\color{MyFontGray}\zihao{-5}了解我们自己，才能更好地管理我们的健康。\\ \\
\color{MyFontGray}\zihao{-5}测序一次，改变一生！\\
\vspace*{0.5cm}
\begin{flushright}
\includegraphics[height=4cm]{5-2.pdf} \\
\color{MyFontGray}\zihao{-5}{诺禾致源总裁 \ \ 蒋智} \\
\end{flushright}
\end{multicols}
\end{spacing}
%封面6页
\newpage
\restoregeometry
%\begin{titlepage}
\thispagestyle{plain}
%\ThisTileWallPaper{\paperwidth}{\paperheight}{6.pdf}
\hspace*{3cm} \\
%\end{titlepage}
%%%%%%%%%%%%%%%%%%%%%%% Result %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%索引页
\newpage
%%%%%%%% 索引 %%%%%%%%%
END

my $zhengwen=<<'END';
\noindent
\index{S1}
\noindent
\begin{spacing}{1.5}
\color{MyFontGray}
\fontsize{10}{12}\selectfont
\begin{longtable}{L{6cm} L{2.8cm} L{6cm} R{0.6cm}}
\arrayrulecolor{tabcolor}
\specialrule{0.04em}{0pt}{8pt}
{\fontsize{23}{}{\color{MyDarkBlue}\sye{Part 1}} & &{\fontsize{23}{}{\color{MyDarkBlue}\sye{Part 2}} & \\
\specialrule{0em}{4pt}{2pt}
{\fontsize{15}{}{\color{MyDarkBlue}\sym{检测结果概况}} & &{\fontsize{15}{}{\color{MyDarkBlue}\sym{您的疾病风险}}} & \\
\specialrule{0em}{5pt}{2pt}
主要检测结果和风险提示 & 07 & 遗传性肿瘤风险预测 & 12 \\
& & 心源性猝死基因检测 & 21 \\
& & 高血压基因检测 & 28 \\ \\ \\
\specialrule{0.04em}{0pt}{8pt}
{\fontsize{23}{}{\color{MyDarkBlue}\sye{Part 3}}} & &{\fontsize{23}{}{\color{MyDarkBlue}\sye{Part 4}}} & \\
\specialrule{0em}{4pt}{2pt}
{\fontsize{15}{}{\color{MyDarkBlue} \sym{您的药物敏感性分析}}} & &{\fontsize{15}{}{\color{MyDarkBlue}\sym{您的个人特质基因检测}}} & \\\specialrule{0em}{5pt}{2pt}
检测内容与结果 & 33 & 叶酸代谢基因检测 & 63 \\
检测报告 & 37 & 酒精代谢基因检测 & 68 \\
& & 乳糖代谢基因检测 & 73 \\ \\ \\
\specialrule{0.04em}{1pt}{8pt}
\Arial{\fontsize{23}{}{\color{MyDarkBlue}\sye{Part 5}} & &\Arial{\fontsize{23}{}{\color{MyDarkBlue}\sye{Part 6}}} & \\\specialrule{0em}{4pt}{2pt}
{\fontsize{15}{}{\color{MyDarkBlue}\sym{后代遗传疾病风险}} & &{\fontsize{15}{}{\color{MyDarkBlue}\sym{附录}}} \\\specialrule{0em}{5pt}{2pt}
遗传病携带者筛查 & 78 & 个人基因组服务流程 & 90 \\
& & 报告声明 & 92 \\
& & 关于诺禾致源 & 93 \\
\end{longtable}
\end{spacing}
%%%%%%%%%%%%%%%%%%%% new page %%%%%%%%%%%%%%%%%%
%封面7页
\newpage
\thispagestyle{empty}
\ThisTileWallPaper{\paperwidth}{\paperheight}{11-1.pdf}
\color{white}
    \put(61,-150){\fontsize{72}{86.4}\selectfont \sye Part 1}
    \put(56,-240){\fontsize{40}{48} \selectfont  \sym 检测结果概况}
    \put(52,-280){\fontsize{20}{24} \selectfont 主要检测结果及风险}
END

my $part6=<<'END';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part6 %%%%%%%%%%%%%%%%%
\newpage
\thispagestyle{empty}
\ThisTileWallPaper{\paperwidth}{\paperheight}{11-1.pdf}
\begin{overpic}
     \put(61,-100){\fontsize{72}{5}{\color{white}\sye{Part 6}}}
     \put(56,-200){\fontsize{40}{}{\color{white}\sym{附录}}}
     \put(52,-240){\fontsize{20}{}{\color{white}个人基因组服务流程}}
     \put(52,-270){\fontsize{20}{}{\color{white}个人基因组检测方法介绍}}
	 \put(52,-300){\fontsize{20}{}{\color{white}报告声明}}
	 \put(52,-330){\fontsize{20}{}{\color{white}关于诺禾致源}}
\end{overpic}
END

my $bottom1=<<'END';
\noindent
\color{MyFontGray}
\fontsize{9.5}{}{诺禾致源个人基因组检测有着严格的技术服务流程，详见下图。从样品收集、高通量测序，再到后期生物信息分析和报告解读等整个过程中都有严格的数据质控和预警反馈机制，有效地追踪到每一步的流程状态，从而保证结果的准确性和可靠性。} \\
\ThisTileWallPaper{\paperwidth}{\paperheight}{90-1.pdf} \\
\newpage
END
my $bottom2=<<'END';
\noindent
\color{MyFontGray}
\fontsize{9.5}{}{基因检测是通过提取血液、唾液、其他体液、细胞或身体成分中的遗传物质 DNA，利用特定设备进行 DNA 序列检测的技术，分析它所含有的各种序列差异或基因突变情况，从而使人们能了解自己的基因信息。通过对这些基因信息的挖掘和解读，可以预测受检者某种疾病的风险，可以预测受检者对某些药物的敏感性和毒副作用，使得个体化的医疗和健康管理得以实现。} \\ \\
\fontsize{9.5}{}{本次针对您样本的基因检测基于国际公认的最先进的全外显子测序技术来完成的，配合严谨的信息分析流程和数据解读方法，确保您宝贵的基因信息得到最科学地管理。} \\ \\ 
%\newcolumntype{I}{!{\vrule width 8pt}}
%\newcolumntype{I}{\color{white}\vrule width 16 pt}
%\newlength\savedwidth
%\arrayrulecolor{white}
\begin{longtable}{L{7.8cm} L{15pt} L{7.7cm}}
%\specialrule{0.04em}{0pt}{8pt}
\arrayrulecolor{tabcolor}\cline{1-1}
\arrayrulecolor{tabcolor}\cline{3-3}
 & & \\
%\specialrule{0.04em}{0pt}{3pt}
{\fontsize{12}{}{\color{MyDarkBlue}\sym{高通量测序技术}}} &  & {\fontsize{12}{}{\color{MyDarkBlue}\sym{数据分析}} \\
 & & \\
\gape[t]{\makecell[l{p{7.6cm}}]{ 检测基于标准化的全外显子组建库及高通量测序平台。本次检测质量控制指标为：平均覆盖度 99.5\%，平均有效测序深度不低于 100X。\\ 本次检测使用的高通量测序平台为 Illumina 公司HiSeq 系列测序仪，产出数据的质量及准确性皆为业内最高标准。}} &  & \gape[t]{\makecell[l{p{7.6cm}}]{高通量测序数据经过 QC，得到高质量数据，比对到人类参考基因组，并检测出变异；然后使用群体数据库和疾病数据库解读已知变异，并根据蛋白结构、功能等方面改变预测新变异功能；最后结合上面的注释预测患病风险。\\ \\ }} \\
 &  & \\ 
%\specialrule{0.04em}{0pt}{8pt}
\arrayrulecolor{tabcolor}\toprule[0.8pt]
	& & \\
\multicolumn{3}{l}{\fontsize{12}{}{\color{MyDarkBlue}\sym{数据解读}}} \\
   & & \\
\multicolumn{3}{l}{\makecell[l{p{16cm}}]{数据解读规则参考美国医学遗传学和基因组学学院（American College of Medical Genetics and Genomics, ACMG）相关指南[1] 。除非已有相关致病性报道，否则数据分析将不针对同义突变，内含子区域的非剪接和常见良性多态性突变进行解读。数据的报告主要针对目前明确的与疾病相关或可能与疾病有关系的突变点。所有数据的解读基于我们目前对疾病与致病基因的了解认识。建议临床医生或相关医疗专业人员根据检测结果对受检者进行临床表型关联。}} \\
\end{longtable}
\vspace*{0.8cm}
\noindent
\fontsize{7.5}{}{\color{MyDarkBlue}\sym{参考文献}} \\
\noindent
\fontsize{6.5}{}{1. Richards S, Aziz N, Bale S, et al. Standards and guidelines for the interpretation of sequence variants: a joint consensus recommendation of the American College of Medical Genetics and Genomics and the Association for Molecular Pathology [J]. Genetics in Medicine, 2015, 17(5): 405-423.} \\
\newpage
END
my $bottom3=<<'END';
\noindent
\begin{longtable}{L{7.8cm} L{15pt} L{7.6cm}}
%\specialrule{0.04em}{0pt}{8pt}
\arrayrulecolor{tabcolor}\cline{1-1}
\arrayrulecolor{tabcolor}\cline{3-3}
& & \\
%\specialrule{0.04em}{0pt}{3pt}
{\fontsize{12}{}{\color{MyDarkBlue}\sym{关于送检样本}} &  & {\fontsize{12}{}{\color{MyDarkBlue}\sym{关于疾病风险}} \\
& & \\
\gape[t]{\makecell[l{p{7.6cm}}]{\fontsize{9.5}{}{本报告结果只对本次送检样品负责，限受检者本人拆阅。本机构只对受检样本和检测结果的一致性负责，而不能对受检者和受检样本的一致性承担责任，提供样本者应对样本与受检者的一致性负责。\\ \\ }}} & & \gape[t]{\makecell[l{p{7.6cm}}]{\fontsize{9.5}{}{当检测结果为低风险时并不代表受检者必定不会患有该种疾病，同样当检测结果为高风险时并不代表必定会患此病。本次基因检测的目的是基因变异筛查，其结果可供临床参考，但不作为诊断依据，您需要和遗传咨询师或医生沟通以获得风险管理和医疗建议。}}} \\
&  & \\
\arrayrulecolor{tabcolor}\cline{1-1}
\arrayrulecolor{tabcolor}\cline{3-3}
& & \\
{\fontsize{12}{}{\color{MyDarkBlue}\sym{关于药物}} &  & {\fontsize{12}{}{\color{MyDarkBlue}\sym{关于准确性}} \\
& & \\
\gape[t]{\makecell[l{p{7.6cm}}]{\fontsize{9.5}{}{本报告的中药建议严格遵守最新的药物基因组学知识库以及临床药物基因组学实施联盟(CPIC)等权威机构提供的国际指南。用药建议仅供参考，具体措施请以临床情况和医生意见为准。由于儿童的肝脏未发育完全，对药物的代谢能力与成人完全不同，故不能直接沿用成人标准，请在儿童用药时结合医生意见谨慎参考。在附录中我们提供了余下全部药物的检测和解读结果，供您参阅。 }}} & & \gape[t]{\makecell[l{p{7.6cm}}]{\fontsize{9.5}{}{本次检测只针对检测范围内的疾病和基因位点进行解读，在当前的科学技术条件下本公司承诺所有检测结果是真实有效的，解读基于当前权威数据库和专业文献。但需要提醒您，该风险结果不能反映您的全部风险，不排除在这些基因位点范围以外存在其他未知风险基因变异的可能。将来随着研究的深入和相关报道的增加，我们会对您这部分的结果报告进行更新并及时告知您对您有价值的结果。}}} \\
&  & \\
\arrayrulecolor{tabcolor}\toprule[0.8pt]
& & \\
\multicolumn{3}{l}{\fontsize{12}{}{\color{MyDarkBlue}\sym{关于隐私保护}}} \\
& & \\
\multicolumn{3}{l}{\makecell[l{p{16cm}}]{\fontsize{9.5}{}{在您的基因检测报告中包含了您本人的基因检测数据资料，这些资料属于个人隐私，请您务必妥善保管，以免资料的泄露有可能对您个人及家庭造成不利影响。我们郑重承诺妥善保管您的相关数据，未经本人授权不得用于其他用途。若因您个人原因发生信息外泄，其后果将由您本人承担。}}} \\
\end{longtable}
\newpage
END
my $bottom4=<<'END';
\noindent
\begin{wrapfigure}[9]{l}{8cm}
\includegraphics[width=7.7cm,clip]{93-1.pdf}
\end{wrapfigure}
\mbox{}
\noindent

\\ \\ \\ \\
\arrayrulecolor{tabcolor}\toprule[0.8pt]
\noindent
%\includegraphics[height=4.6cm,width=\textwidth]{93-2.pdf}
\includegraphics[height=4.4cm,width=\textwidth]{93-2.pdf}
%\newpage
%\thispagestyle{empty}
%\ThisTileWallPaper{\paperwidth}{\paperheight}{94.pdf}
%\hspace*{3cm} \\
\end{document}
END

###############main section################
#say $introduction;
#say $fengmianye;
#say $ini;
#say $letter;
###########suoyin##############
#say &headerfooter("索引","7-3.pdf","");
#say $zhengwen;
############内容##############
############封底页############
#say $part6;
#say &headerfooter("个人基因组服务流程","7-3.pdf","");
#say $bottom1;
#say &headerfooter("个人基因组检测方法介绍","7-3.pdf","");
#say $bottom2;
#say &headerfooter("报告声明","7-3.pdf","");
#say $bottom3;
#say &headerfooter("关于","7-3.pdf","");
#say $bottom4;

open FM,">:encoding(utf-8)","$out1" || die "can't open the $out1!";
say FM $introduction;
say FM $fengmianye;
say FM $ini;
say FM $letter;
###########suoyin##############
say FM	&headerfooter("索引","7-3.pdf","");
say FM	$zhengwen;
close FM;

open FD,">:encoding(utf-8)","$out2" || die "can't open the $out2!";
say FD $part6;
say FD &headerfooter("个人基因组服务流程","7-3.pdf","");
say FD $bottom1;
say FD &headerfooter("个人基因组检测方法介绍","7-3.pdf","");
say FD $bottom2;
say FD &headerfooter("报告声明","7-3.pdf","");
say FD $bottom3;
say FD &headerfooter("关于","7-3.pdf","");
say FD $bottom4;
close FD;
