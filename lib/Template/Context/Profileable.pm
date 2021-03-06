package Template::Context::Profileable;

use warnings;
use strict;

=head1 NAME

Template::Context::Profileable - make Template::Context profileable:
measure subtemplates processing time.

=head1 VERSION

Version 0.01

=cut

use base qw(Template::Context);
use Data::Dumper;

our $VERSION = '0.02';

my @stack;
my %totals;

sub process {
    my $self = shift;

    my $template = $_[0];
    if (UNIVERSAL::isa($template, "Template::Document")) {
        $template = $template->name || $template;
    }

    push @stack, [time, times];

    my @result = wantarray ?
        $self->SUPER::process(@_) :
        scalar $self->SUPER::process(@_);

    my @delta_times = @{pop @stack};
    @delta_times = map { $_ - shift @delta_times } time, times;
    for (0..$#delta_times) {
        $totals{$template}[$_] += $delta_times[$_];
        for my $parent (@stack) {
            $parent->[$_] += $delta_times[$_] if @stack; # parent adjust
        }
    }
    $totals{$template}[5] ++; # count of calls
    
    unless (@stack) {
        ## top level again, time to display results
        print STDERR "-- $template at ". localtime, ":\n";
        printf STDERR "%3s %3s %6s %6s %6s %6s %s\n",
            qw(cnt clk user sys cuser csys template);
        for my $template (sort keys %totals) {
            my @values = @{$totals{$template}};
            printf STDERR "%3d %3d %6.2f %6.2f %6.2f %6.2f %s\n",
                $values[5], @values[0..4], $template;
        }
        print STDERR "-- end\n";
        %totals = (); # clear out results
    }

    # return value from process:
    wantarray ? @result : $result[0];
}

$Template::Config::CONTEXT = __PACKAGE__;

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Template::Context::Profileable;

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 AUTHOR

Randal L. Schwartz, C<< <merlyn at stonehenge.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-template-context-profileable at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Template-Context-Profileable>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Template::Context::Profileable

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Template-Context-Profileable>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Template-Context-Profileable>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Template-Context-Profileable>

=item * Search CPAN

L<http://search.cpan.org/dist/Template-Context-Profileable/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Randal L. Schwartz, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
