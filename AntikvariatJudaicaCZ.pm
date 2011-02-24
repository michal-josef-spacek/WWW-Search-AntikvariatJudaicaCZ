#------------------------------------------------------------------------------
package WWW::Search::AntikvariatJudaicaCZ;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(WWW::Search);
use strict;
use warnings;

# Modules.
#use Encode qw(decode_utf8 encode_utf8);
use LWP::UserAgent;
use Readonly;
#use Text::Iconv;
use Web::Scraper;
use WWW::Search qw(generic_option);

# Constants.
Readonly::Scalar our $MAINTAINER => 'Michal Spacek <skim@cpan.org>';
Readonly::Scalar my $BASE_URL => 'http://antikvariat-judaica.cz/';
Readonly::Scalar my $ACTION1 => 'search/node/';

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub native_setup_search {
#------------------------------------------------------------------------------
# Setup.

	my ($self, $query) = @_;
	$self->{'_def'} = scraper {
#		process '//meta[@http-equiv="Content-Type"]', 'encoding' => [
#			'@content',
#			\&_get_encoding,
#		];
#		process '//table[@width="100"]/tr/td[5]/a',
#			'next_url' => '@href';
#		process '//td[@height="330"]/node()[3]', 'records' => 'RAW';
#		process '//td[@height="330"]/table[@width="560"]', 'books[]'
#			=> scraper {
#
#			process '//tr/td/font/a', 'title' => 'RAW',
#				'url' => '@href';
#			process '//tr/td[@width="136"]/font[2]',
#				'price' => 'RAW';
#			process '//tr[2]/td/font/strong', 'author' => 'RAW';
#			process '//tr[3]/td/font/div', 'info' => 'RAW';
#			process '//tr[4]/td/div/a', 'cover_url' => '@href';
#			process '//tr[5]/td[1]/font[2]', 'publisher' => 'RAW';
#			process '//tr[5]/td[2]/font[2]', 'year' => 'RAW';
#			return;
#		};
		return;
	};
	$self->{'_offset'} = 0;
	$self->{'_query'} = $query;
	return 1;
}

#------------------------------------------------------------------------------
sub native_retrieve_some {
#------------------------------------------------------------------------------
# Get data.

	my $self = shift;

	# Get content.
	my $ua = LWP::UserAgent->new(
		'agent' => "WWW::Search::AntikvariatJudaicaCZ/$VERSION",
	);
	my $response = $ua->get($BASE_URL.$ACTION1
#		'Content' => {
#			'hltex' => $query,
#			'hledani' => 'Hledat',
#		},
	);

	# Process.
	if ($response->is_success) {
		my $content = $response->content;

		# Get books structure.
		my $books_hr = $self->{'_def'}->scrape($content);

		# Process each book.
		foreach my $book_hr (@{$books_hr->{'books'}}) {
#			_fix_url($book_hr, 'cover_url');
#			_fix_url($book_hr, 'url');
#			push @{$self->{'cache'}}, $self->_process($book_hr);
		}

		# Next url.
#		_fix_url($books_hr, 'next_url');
#		$self->next_url($books_hr->{'next_url'});
	}

	return;
}

1;
