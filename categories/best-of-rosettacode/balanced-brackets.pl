use v6;

=begin pod

=TITLE Balanced brackets

=AUTHOR Filip Sergot

Generate a string with N opening brackets (“[”) and N closing brackets
(“]”), in some arbitrary order.

Determine whether the generated string is balanced; that is, whether it
consists entirely of pairs of opening/closing brackets (in that order), none
of which mis-nest.

=head1 More

L<http://rosettacode.org/wiki/Balanced_brackets#Perl_6>

=head1 What's interesting here?

=item idiomatic solutions
=item hyper operators
=item switch statement
=item roll
=item grammar

=head1 Features used

=item C<roll> - L<https://docs.raku.org/routine/roll#(List)_routine_roll>
=item C<given> - L<https://docs.raku.org/syntax/given%20statement>
=item C<prompt> - L<https://docs.raku.org/routine/prompt>
=item C<grammar> - L<https://docs.raku.org/language/grammars>

=head2 Depth counter

=end pod

my $n = prompt "Number of bracket pairs: ";

{
    sub balanced($s) {
        my $l = 0;
        for $s.comb {
            when "]" {
                --$l;
                return False if $l < 0;
            }
            when "[" {
                ++$l;
            }
        }
        return $l == 0;
    }

    my $s = (<[ ]> xx $n).pick(*).join;
    say "Using depth counter method";
    say "$s {balanced($s) ?? "is" !! "is not"} well-balanced";
}

=begin pod

=head2 FP oriented

=end pod

{
    sub balanced($s) {
        .none < 0 and .[*-1] == 0
            given ([\+] '\\' «leg« $s.comb).cache;
    }

    my $s = <[ ]>.roll($n*2).join;
    say "Using an FP oriented method";
    say "$s { balanced($s) ?? "is" !! "is not" } well-balanced";
}

=begin pod

=head2 String munging

=end pod

{
    sub balanced($_ is copy) {
        s:g/'[]'// while m/'[]'/;
        $_ eq '';
    }

    my $s = <[ ]>.roll($n*2).join;
    say "Using a string munging method";
    say "$s is", ' not' xx not balanced($s), " well-balanced";
}

=begin pod

=head2 Parsing with a grammar

=end pod

{

    grammar BalBrack {
        token TOP { ^ <balanced>* $ };
        token balanced { '[]' | '[' ~ ']' <balanced> }
    }

    my $s = <[ ]>.roll($n*2).join;
    say "Parsing brackets with a grammer";
    say "$s { BalBrack.parse($s) ?? "is" !! "is not" } well-balanced";

}

# vim: expandtab shiftwidth=4 ft=perl6
