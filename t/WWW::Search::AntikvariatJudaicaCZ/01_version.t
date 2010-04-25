# Modules.
use WWW::Search::AntikvariatJudaicaCZ;
use Test::More 'tests' => 1;

print "Testing: version.\n";
is($WWW::Search::AntikvariatJudaicaCZ::VERSION, '0.01');
