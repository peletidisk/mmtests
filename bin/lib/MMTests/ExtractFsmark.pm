# ExtractFsmark.pm
package MMTests::ExtractFsmark;
use MMTests::SummariseMultiops;
our @ISA = qw(MMTests::SummariseMultiops);

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "ExtractFsmark",
		_DataType    => MMTests::Extract::DATA_OPS_PER_SECOND,
		_ResultData  => []
	};
	bless $self, $class;
	return $self;
}

sub printDataType() {
	print "Operations/sec,TestName,Latency,candlesticks";
}

sub extractReport($$$) {
	my ($self, $reportDir, $reportName) = @_;
	my ($user, $system, $elapsed, $cpu);
	my $file = "$reportDir/noprofile/fsmark.log";
	my $preamble = 1;
	my $iteration = 1;

        $self->{_CompareLookup} = {
                "files/sec" => "pdiff",
                "overhead"  => "pndiff"
        };

	open(INPUT, $file) || die("Failed to open $file\n");
	while (<INPUT>) {
		my $line = $_;
		if ($preamble && $line !~ /^FSUse/) {
			next;
		}
		$preamble = 0;
		if ($line =~ /[a-zA-Z]/) {
			next;
		}

		my @elements = split(/\s+/, $_);
		push @{$self->{_ResultData}}, [ "files/sec", ++$iteration, $elements[4] ];
	}
	close INPUT;

	$self->{_Operations} = [ "files/sec" ];
}

1;
