#!/usr/bin/env perl

use autodie;
use Term::ANSIColor;
#use threads;
#use threads("exit"=>"threads_only"):
#use threads::shared:

$SIG{INT}       = sub {&printBR("\n### You has enter the Ctrl+C keys,now exit $$ ...\n");kill(9,-$$);exit 0;};
$XHOME          = "~/.perl";
$Xlogfilepath   = "~/.log";

chomp($XUSER    = `whoami`);
chomp($XHOST    = `hostname -A`);
chomp($XDATE    = `date +%Y_%m_%d_%H_%M-%a`);
chomp($XPWD     = `pwd`);
chomp($XSYS     = `cat /etc/centos-release`);
chomp($XGRP     = `id -g -n`);
chomp($XIPD     = `hostname -I`);

$Xengine="$XHOME/X_engine"

sub printB      {print color('blue');           print "@_";print color('reset');}
sub printR      {print color('red');            print "@_";print color('reset');}
sub printG      {print color('green');          print "@_";print color('reset');}
sub printY      {print color('yellow');         print "@_";print color('reset');}
sub printM      {print color('magenta');        print "@_";print color('reset');}
sub printC      {print color('cyan');           print "@_";print color('reset');}
sub printBB     {print color('bold blue');      print "@_";print color('reset');}
sub printBR     {print color('bold red');       print "@_";print color('reset');}
sub printBG     {print color('bold green');     print "@_";print color('reset');}
sub printBY     {print color('bold yellow');    print "@_";print color('reset');}
sub printBM     {print color('bold magenta');   print "@_";print color('reset');}
sub printBC     {print color('bold cyan');      print "@_";print color('reset');}

sub xengine     {system "$Xengine @_[0] @_[1]";}
sub uniq        {my %seen;return grep {!$seen{$_}++} @_;}
sub mktmpdir    {$xtmp=@_[0];$tmpdir = "/tmp/$XUSER/.$xtmp";if (! -e $tmpdir ) {system "mkdir -p $tmpdir";};}

sub xavierstudio {
        &printBM("#########################################################\n");
        &printBM("#> Copyright 2019+, Xavier-Studio, All Rights Reserve. <#\n");
        &printBM("#########################################################\n");
}

sub x_module {
        my $module = shift;
        no strict 'refs';
        return grep {defined & {"$module\::$_"}} keys %{"$module\::"}
}

sub x_kill_A {
        $pstemp = `pstree -p $$ | sed -e 's+*+\\n+g' -e 's+\(\\\|\)+\\n+g'`;
        @pstemp = split(/s+/,$pstemp);
        $SIG{INT} = sub {
                #@pstemp = split(/s+/,$pstemp);
                foreach $pstmp(@pstemp) {push @pstree,$pstmp if ($pstmp =~ /\d+/);};
                &printBR("\n### You has enter the Ctrl+C keys, now exit @pstree");
                kill(9,@pstree);exit;
        };
}
sub x_kill_B {
        $pstemp = `pstree -p \$\$ | sed -e 's+*+\\n+g' -e 's+\(\\\|\)+\\n+g'`;
        @pstemp = split(/s+/,$pstemp);
        $SIG{INT} = sub {
                #@pstemp = split(/s+/,$pstemp);
                foreach $pstmp(@pstemp) {        
                        push @pstree,$pstmp if ($pstmp =~ /\d+/);
                        &printBR("\n### You has enter the Ctrl+C keys, now exit @pstree");
                }
                kill(9,@pstree);exit;
        };
}

#&splitline(100,"#");
sub splitline {
        print "\n";
        for($i=0;$i<=@_[0];$i++) {print "@_[1]";}
        print "\n\n";
}
sub splitlineO {
        print OUTPUT "\n";
        for($i=0;$i<=@_[0];$i++) {print OUTPUT "@_[1]";}
        print OUTPUT "\n\n";
}

#&get_log("cmd",@ARGV);
sub get_log {
        @XXXXXXXLOG[0] = $XDATE;
        @XXXXXXXLOG[1] = $XUSER;
        @XXXXXXXLOG[2] = $XGRP;
        @XXXXXXXLOG[3] = $XHOST;
        @XXXXXXXLOG[4] = $XIPD;
        @XXXXXXXLOG[5] = $XSYS;
        @XXXXXXXLOG[6] = $XPWD;
        open(LOG,">>$Xlogfilepath/.@_[0].log");
        print LOG "# ";
        foreach $XXXXXXXTMP(@XXXXXXXLOG) {print LOG "$XXXXXXXTMP ";}
        print LOG "# Values : @_ \n";
        close(LOG);
}

sub kill_x11_all {
        &xavierstudio;
        chomp(@x11list=`grep -ri "WINDOW" /home/$XUSER/.dbus/session-bus/|sed "s+.*=++g"`);
        @x11list = sort(&uniq(@x11list));
        &printBR("Killing all X11 ID now\t\!\!\!\n");
        foreach $x11id(@x11list) {&printBR("Killing : $x11id\t\!\!\!\n");&cmd("xkill -id $x11id");}
        &printBR("Please logout and login again \!\!\!\n");
}

sub print_multi_cols {
        chomp(my $maxcols=`tput cols`);my @arr;my $color;
        if ((@_[1] !~ /cmd/i) && @_[1] !~ /list/i)) {&printBR("### ERROR : print_multi_cols only support types 'list' or 'cmd'\!\!\!\n");exit;}
        chomp(@arr=`@_[0]`)             if (@_[1] =~ /cmd/i);
        chomp(@arr=split(" ",@_[0]))    if (@_[1] =~ /list/i);
        $color=@_[2]    if (@_[2] !~ /^\s*$/);
        $color="blue"   if (@_[2] !~ /^\s*$/);
        my $c=0;my $i=1;my $TTT;
        foreach my $ttt(@arr) {@ttt=split("",$ttt);my $ttt=@ttt;$TTT=$ttt if ($TTT < $ttt);undef(@ttt);};
        $TTT=int($TTT/10);my $limit; if ($TTT < 5) {$limit=3+$TTT*10;} else {$limit=43;};
        foreach my $tmp(@arr) {
                my @tmp=split("",$tmp);my $A=@tmp;undef(@tmp);$A=$A+7;
                if ($c > $maxcols) {print "\n";$c=0};
                if ($A <= ($limit+7)) {
                        if (($c+$limit+7) >$maxcols) {print "\n";$c=0}
                        $c=$c+$limit+7;my $p=$limit;
                        print color($color);
                        printf "%-6s%-${p}s ","[$i]",$tmp;
                        print color('reset');
                } else {
                        if ($A <= (($limit+7)*2)) {
                                if (($c+($limit+7)*2) >$maxcols) {print "\n";$c=0}
                                $c=$c+($limit+7)*2;my $p=$limit+($limit+7);
                                print color($color);
                                printf "%-6s%-${p}s ","[$i]",$tmp;
                                print color('reset');
                        } else {
                                if (($c+($limit+7)*3) >$maxcols) {print "\n";$c=0}
                                $c=$c+($limit+7)*3;my $p=$limit+($limit+7)*2;
                                print color($color);
                                printf "%-6s%-${p}s ","[$i]",$tmp;
                                print color('reset');
                        }
                }
        }
}

1;
