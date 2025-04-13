#!/usr/bin/env perl
# 
# usage: % ./d4eV4.pl episode_num(125-...) MOOCDicteeJapaneseV01V01.tex
# 
# yamagen cupid:~/Dropbox/j-class [17815]% for n in `seq 1 100`       
# do
# a=$(printf "d4e%03d.json" $n);
# ./d4eV2.pl $n MOOCDicteeJapanese-db.tex > d4eJson/$a;
# done
#
my $generate = 0;
my $begun = 0;
my $begunId = 0;
my $start = shift; # 第1引数にて番号を得る。その他は標準入力。

print "[\n";
while (<>) {
    chomp;
    next if !/\%D4E\%/; # %D4E% の行にはデータがある。
    
    s/\%D4E\%//g; # %D4E% を取り除く。
    
    if (/day:(\d\d\d)/) {
      if ($start == $1) {
        #        print "START\n";
        $generate = 1;
      }
    }

    if (/day:(\d\d\d)/) {
      if ($start != $1) {
        $generate = 0;
      }
    }

    next if !$generate;
    if (/day:(\d\d\d)/) {
      $begunId = 0;
      print "]},\n" if $begun;
      $begun = 1;
      print "{\"day\":\"$1\",";
    }

    print "\"title\":\"$1\",\"quiz\":[\n" if /title:(.+)/;

    if (/ID:(.+)/) {
      print ",\n" if $begunId; # 前のデータの続きなので,を打って改行。    
      $begunId = 1; # そしてIDは始まりました。
      print "\t{\"ID\":\"$1\",";
    }

#    print "\"sentence\":\"".$1."\"," if (/sentence:(.+)/);
    if (/sentence:(.+)/) {
      my $str = $1;
      $str =~ s/ B: /\<\/li\>\<li\>B: /g;
      $str =~ s/\(([^:]+):([^)]+)\)/<ruby><rb>$1<\/rb><rp>(<\/rp><rt>$2<\/rt><rp>)<\/rp><\/ruby>/g;
      print "\"sentence\":\"".$str."\",";
    }
#    print "\"english\":\"$1\"," if /english:(.+)/;
    if (/english:(.+)/) {
      my $str = $1;
      $str =~ s/ B: /\<\/li\>\<li class=\\"english\\"\>B: /g;
      print "\"english\":\"".$str."\",";
    }
    print "\"answer\":\"$1\"," if /answer:(.+)/;
    print "\"model\":\"$1\"," if /model:(.+)/;
    print "\"roman\":\"$1\"}" if /roman:(.+)/;

#%D4E%ID:1
#%D4E%sentence:これ、どうですか？ B: <BLANK>。
#%D4E%english:A: How do you think about this? B: It is nice.
#%D4E%answer:いいですねえ
#%D4E%model:いいですね
#%D4E%roman:iidesune
#%D4E%note:
}
print "]}]\n";
