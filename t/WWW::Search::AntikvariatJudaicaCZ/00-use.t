# Modules.
use Test::More 'tests' => 2;

BEGIN {
	print "Usage tests.\n";
	use_ok('WWW::Search::AntikvariatJudaicaCZ');
}
require_ok('WWW::Search::AntikvariatJudaicaCZ');
