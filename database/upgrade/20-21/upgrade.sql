------------------------------------------------------------------------------
-- Database upgrade to 2.1 version
--
-- Use:
--	- psql -f upgrade.sql database-name
--
------------------------------------------------------------------------------

DROP TABLE dns.dr_mbox ;

COPY global.config (clef, valeur) FROM stdin;
pageformat	a4
\.

DROP TABLE topo.cache ;

CREATE SEQUENCE topo.seq_confcmd START 1;

CREATE TABLE topo.confcmd (
    idccmd		INTEGER		-- entry id
	    DEFAULT NEXTVAL ('topo.seq_confcmd'),
    idtype		INTEGER,	-- equipment type
    action		TEXT,		-- action selector : prologue, ifreset
    rank		INTEGER,	-- sort order
    model		TEXT,		-- regexp matching equipment model
    command		TEXT,		-- command to send

    FOREIGN KEY (idtype) REFERENCES topo.eqtype (idtype),
    PRIMARY KEY (idccmd)
) ;

CREATE TEMPORARY TABLE tmpconfcmd (
    type		TEXT,		-- equipment type
    action		TEXT,		-- action selector : prologue, ifreset
    rank		INTEGER,	-- sort order
    model		TEXT,		-- regexp matching equipment model
    command		TEXT		-- command to send
) ;

COPY tmpconfcmd (type, action, rank, model, command) FROM stdin ;
cisco	prologue	100	.*	configure terminal
cisco	ifreset	90	.*29.0.*	interface %1$s\ndefault switchport nonegotiate\ndefault switchport trunk allowed vlan\ndefault switchport trunk native vlan\ndefault switchport access vlan\ndefault switchport mode
cisco	ifreset	100	.*	interface %1$s\nno switchport\nswitchport voice vlan none\nswitchport
cisco	ifdisable	100	.*	interface %1$s\nshutdown
cisco	ifenable	100	.*	interface %1$s\nno shutdown
cisco	ifaccess	100	.*	interface %1$s\nswitchport mode access\nswitchport access vlan %2$s\nspanning-tree portfast 
cisco	ifvoice	100	.*	interface %1$s\nswitchport voice vlan %2$s
cisco	ifdesc	100	.*	interface %1$s\ndescription %2$s
cisco	epilogue	100	.*	line con 0\nexit\nexit\nwrite memory 
juniper	prologue	100	.*	configure
juniper	ifreset	100	.*	delete interfaces %1$s unit 0 family ethernet-switching\ndelete ethernet-switching-options voip interface %1$s
juniper	ifdisable	100	.*	set interfaces %1$s disable
juniper	ifenable	100	.*	delete interfaces %1$s disable
juniper	ifaccess	100	.*	set interfaces %1$s unit 0 family ethernet-switching port-mode access\nset interfaces %1$s unit 0 family ethernet-switching vlan members %2$s
juniper	ifdesc	100	.*	set interfaces %1$s description "%2$s"
juniper	ifvoice	100	.*	set interfaces %1$s unit 0 family ethernet-switching\nset ethernet-switching-options voip interface %1$s vlan %2$s
juniper	epilogue	100	.*	commit\nexit configuration
hp	prologue	100	.*	configure terminal
hp	resetvlan	100	.*	vlan %2$s\nno tagged %1$s\nno untagged %1$s
hp	ifenable	100	.*	interface %1$s\nenable
hp	ifdisable	100	.*	interface %1$s\ndisable
hp	ifaccess	100	.*	vlan %2$s\nuntagged %1$s
hp	ifvoice	100	.*	vlan %2$s\ntagged %1$s
hp	ifdesc	100	.*	interface %1$s\nname "%2$s"
hp	epilogue	100	.*	vlan 1\nexit\nexit\nwrite memory
\.

INSERT INTO topo.confcmd (idtype, action, rank, model, command)
	SELECT e.idtype, c.action, c.rank, c.model, c.command
	FROM topo.eqtype e, tmpconfcmd c
	WHERE e.type=c.type ;

CREATE TABLE topo.dotattr (
    rank	INTEGER,	-- sort order
    type	INTEGER,	-- 2: l2, 3: l3 graph
    regexp	TEXT,		-- regexp
    gvattr	TEXT,		-- graphviz node attributes
    png		BYTEA,		-- PNG generated by graphviz

    PRIMARY KEY (rank)
) ;


COPY topo.dotattr (rank, type, regexp, gvattr) FROM stdin;
10100	2	juniper/M.*	shape=circle\nstyle=filled fillcolor=lightgrey\nfixedsize height=1
10200	2	cisco/12000.*	shape=doublecircle\nstyle=filled fillcolor=lightgrey\nfixedsize height=1
10300	2	juniper/EX8.*	shape=box style=filled fillcolor=lightblue
10400	2	juniper/Chassis.*	shape=box style=filled fillcolor=lightblue
10500	2	cisco/WS-C45.*	shape=box style=filled fillcolor=lightblue
10600	2	cisco/WS-C37.*	shape=box style=filled fillcolor=lightblue height=.25
10700	2	cisco/WS-C29.*	shape=box style=filled fillcolor=lightblue height=.25
10800	2	cisco/WS-.*PS	shape=box style=filled fillcolor=yellow height=.25
10900	2	cisco/37.*	shape=octagon style=filled fillcolor=orange1 height=.25
11000	2	cisco/38.*	shape=octagon style=filled fillcolor=orange1
11100	2	cisco/.*routeur	shape=circle\nstyle=filled fillcolor=lightgrey\nfixedsize height=1
11200	2	cisco/1605.*	shape=circle\nstyle=filled fillcolor=lightgrey\nfixedsize height=1
11300	2	cisco/1721.*	shape=circle\nstyle=filled fillcolor=lightgrey\nfixedsize height=1
11400	2	cisco/7206.*	shape=circle\nstyle=filled fillcolor=lightgrey\nfixedsize height=1
11500	2	juniper/EX2.*	shape=box style=filled fillcolor=SteelBlue height=.25
11600	2	juniper/EX4.*	shape=box style=filled fillcolor=SteelBlue height=.25
11900	2	fwroutebridge.*	shape=Mcircle\nstyle=filled fillcolor=tomato\nheight=1
13000	2	fwroute.*	shape=circle\nstyle=filled fillcolor=tomato\nheight=1
13100	2	fw.*	shape=box style=filled fillcolor=tomato height=.25
13200	2	switch.*	shape=box style=filled fillcolor=lightgrey height=.25
13300	2	hp.*	shape=box style=filled fillcolor=pink height=.25
13400	2	.*	shape=triangle
20100	3	router	shape=circle\nstyle=filled fillcolor=lightgrey\nfixedsize height=1.5
20200	3	host	shape=box\nstyle=filled fillcolor=lightblue\nheight=.25
20300	3	cloud	shape=ellipse\nstyle=filled fillcolor=palegreen\nwidth=1.5
\.

------------------------------------------------------------------------------
-- link number generation
------------------------------------------------------------------------------

CREATE SEQUENCE topo.seq_link START 1 ;

ALTER TABLE global.groupe
    ADD COLUMN droitgenl INT DEFAULT 0
    ;

UPDATE global.groupe SET droitgenl = 0 ;
