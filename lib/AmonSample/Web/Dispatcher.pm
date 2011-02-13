package AmonSample::Web::Dispatcher;
use strict;
use warnings;

use Amon2::Web::Dispatcher::RouterSimple;

connect '/'       => 'Root#index';
connect '/form'   => 'Form#index';
connect '/mobile' => 'Mobile#index';
connect '/counter' => 'Counter#index';
connect '/session' => 'Session#index';
connect '/bbs'     => 'BBS#index';
connect '/bbs/post' => 'BBS#post';

1;
