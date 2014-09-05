package WWW::Search::AntikvariatJudaicaCZ;

# Pragmas.
use base qw(WWW::Search);
use strict;
use warnings;

# Modules.
use LWP::UserAgent;
use Readonly;
use Web::Scraper;
use WWW::Search qw(generic_option);

# Constants.
Readonly::Scalar our $MAINTAINER => 'Michal Spacek <skim@cpan.org>';
Readonly::Scalar my $BASE_URL => 'http://antikvariat-judaica.cz/';
Readonly::Scalar my $ACTION1 => 'search/node/';

# Version.
our $VERSION = 0.01;

# Setup.
sub native_setup_search {
	my ($self, $query) = @_;
	$self->{'_def'} = scraper {
		process '//div[@class="content"]/dl/div', 'books[]' => scraper {
			process '//h2/a', 'title' => 'TEXT';
			process '//h2/a', 'url' => '@href';
			process '//img[@class="imagecache '.
				'imagecache-product_list"]',
				'cover_url' => '@src';
			process '//div[@class="field sell-price"]',
				'price' => 'TEXT';
			process '//div[@class="field '.
				'field-type-content-taxonomy '.
				'field-field-author"]',
				'author' => 'TEXT';
			return;
		};
		return;
	};
	$self->{'_query'} = $query;
	return 1;
}

# Get data.
sub native_retrieve_some {
	my $self = shift;

	# Get content.
	my $ua = LWP::UserAgent->new(
		'agent' => "WWW::Search::AntikvariatJudaicaCZ/$VERSION",
	);
	my $response = $ua->get($BASE_URL.$ACTION1.$self->{'_query'});

	# Process.
	if ($response->is_success) {
		my $content = $response->content;

		# Get books structure.
		my $books_hr = $self->{'_def'}->scrape($content);

		# Process each book.
		foreach my $book_hr (@{$books_hr->{'books'}}) {
			_fix_url($book_hr, 'url');
			$book_hr->{'price'} =~ s/\N{U+00A0}/ /ms;
			$book_hr->{'price'} =~ s/^\s*Cena:\s*//ms;
			$book_hr->{'author'} =~ s/^\s*Autor:\s*//ms;
			push @{$self->{'cache'}}, $book_hr;
		}
	}

	return;
}

# Fix URL to absolute path.
sub _fix_url {
	my ($book_hr, $url) = @_;
	if (exists $book_hr->{$url}) {
		$book_hr->{$url} = $BASE_URL.$book_hr->{$url};
	}
	return;
}

1;
