#!/usr/bin/perl
use lib './lib';
use IntelliHomeNodeMaster;
use Mongoose;
use Cwd;

#use KiokuDB::Backend::Files;
#my $DB=IH::DB->connect("./config/kiokudb.yml");

my $IHOutput = new IH::Interfaces::Terminal;

$IHOutput->info("IntelliHome : Node master started");
$IHOutput->info(
    "Bringing up sockets (not secured, i assume you have vpn on your network)"
);

my $Config
    = new IH::Config( Dirs => ['./config'] );    #specify where yaml file are
$Config->read();    # Read and load yaml configuration

Mongoose->db(
    host    => $Config->DBConfiguration->{'db_dsn'},
    db_name => $Config->DBConfiguration->{'db_name'}
);

my $remote = IH::Workers::RemoteSynth->new( Config => $Config );
my $me = IH::Node->new( Config => $Config )->selectFromType("master");
my $Connector = new IH::Connector( Config => $Config, Node => $me )
    ; #Config parameter is optional, only needed if you wanna send broadcast messages
$Connector->Worker($remote);
$Connector->blocking(1);
$Connector->listen();

#blocking so down can't be esecuted (was used just for test)
my $NodeToDeploy
    = IH::Node->new( Config => $Config )->selectFromDescription("ih0");
$NodeToDeploy->deploy();

#$Connector->broadcastMessage("node","test");
