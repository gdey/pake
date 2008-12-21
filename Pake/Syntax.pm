package Pake::Syntax;

our $VERSION = '0.2';

use Pake::Application;
use Exporter 'import';

@EXPORT = qw(pake_dependency task file rule directory multi_task desc default);  

#--------------------------------------------------
# Syntax avalaible in Pakefile
#--------------------------------------------------

sub pake_dependency($){
    my $file = shift;
    unless (my $return = do $file) {

	if($@){
	    #die "Couldn't parse $file: ";
	    exit;
	}

	unless(defined $return){
	    print "Couldn't do $file: No such a file or diectory\n";
	    exit 0;
	}
  
	die "couldn't run $file"       unless $return;
    }
}
#--------------------------------------------------

sub task(&@) {
    my $code = shift;
    my %dependencies = @_;

    for my $task_name (keys(%dependencies)){
	my $task = Pake::Task->new($code,$task_name,$dependencies{$task_name});
    }
}
#--------------------------------------------------

sub file(&@) {
    my $code = shift;
    my %dependencies = @_;

    for my $task_name (keys(%dependencies)){
	my $task = Pake::FileTask->new($code,$task_name,$dependencies{$task_name});
    }
}
#--------------------------------------------------

sub rule(&@) {
    my $code = shift;
    my %rules = @_;

    for my $outname (keys(%rules)){
	my $rule = Pake::Rule->new($outname, $rules{$outname}, $code);
    }
}
#--------------------------------------------------

sub directory(&@){
    my $code = shift;
    my %dependencies = @_;

    for my $directory (keys(%dependencies)){
	my $task = Pake::Directory->new($code,$directory,$dependencies{$directory});
    }
}

#--------------------------------------------------

sub multi_task(&@) {
    my $code = shift;
    my %dependencies = @_;

    for my $task_name (keys(%dependencies)){
	my $task = Pake::MultiTask->new($code,$task_name,$dependencies{$task_name});
    }
}

#--------------------------------------------------

sub desc{
    Pake::Application::Env()->{"desc"} = shift;
}

#--------------------------------------------------

sub default{
    Pake::Application::Env()->{"default"} = shift;
}

#--------------------------------------------------

1;

__END__

=head1 Name
Syntax


=head1 Description

Pake::Syntax module exports functions which are use to define task and dependencies between them. Module directly exports to the callers namespace all functions in the module

=head2 Methods

Overview of all methods avalailable in the Syntax.pm

=over 12

=item C<task>

task method registers new task in the PakeApplication
First parameter is block of code, executed when the task is invocked.
Second parameter is name of the task (you specify it during pake usage, pake task1) pointing to the table with dependendant tasks (task {} "name" => ["dep1","dep2"];

=item C<file>

file requires same parameters as task method. The difference is that the name of the file task should be a name of physical file. Pake will find out which files changed and what file task should be executed

=item C<directory>

directory task executes only when the directory with the name of the task does not exist

=item C<rule>

rule registers a pattern of a file extension. When you invoke pake with the name of the task that was not specified in the Pakefile or invoke task that depends on a non existing task, pake tries to match the rule to the name of the task. If the match is found it executes the rule.

=item C<multi_task>

Executes prerequistes in parallel

=item C<desc>

Specifies task description
Use it before you specify task

=item C<pake_dependency>

If there is a need, you can load another Pakefile or perl script

=item C<default>

default registers task which will be executed if no tasks will be given in args to pake

=back

=cut
