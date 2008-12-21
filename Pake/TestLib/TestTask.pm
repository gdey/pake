package Pake::TestLib::TestTask;

use strict;
use warnings;

our @ISA = qw(Pake::Task);

sub new(&){
   my $proto = shift;
   my $class = ref($proto) || $proto;

   my $test_dir = shift;

   my $code = sub {
       opendir(DIR, $test_dir);
       my @test_files= readdir(DIR); 

       @test_files = splice(@test_files,2);
       @test_files = map { $test_dir . "/" . $_} @test_files;

       print "Running test_files: @test_files\n";

       use Test::Harness;
       runtests(@test_files);

   };

   my $self  = {};

   $self->{"name"} = "Test";
   $self->{"code"} = $code;
   $self->{"pre"} = [];

   if(exists Pake::Application::Env()->{"desc"}){
       $self->{"description"} = Pake::Application::Env()->{"desc"};
       delete Pake::Application::Env()->{"desc"};
   } else {
       $self->{"description"} = "-";
   }

   bless ($self, $class);
   Pake::Application::add_task($self);

   return $self;   

}

default "Test";

1;

__END__

=head1 NAME

    Pake::TestLib::TestTask 

=head1 SYNOPSIS
String tests is a directory where TestTask will search for test script.
It will execute any files in that dir

    Pake::TestLib::TestTask->new("tests");

If you want to execute test run:

    pake Test

Other way is to make default task Test:

    default "Test";


=head1 Description

TestTask executes tests in a specified directory.
