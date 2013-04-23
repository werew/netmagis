------------------------------------------------------------------------------
-- Database upgrade to 2.2 version
--
-- Use:
--	- psql -f upgrade.sql database-name
--
------------------------------------------------------------------------------


------------------------------------------------------------------------------
-- Remove triggers in order to quietly make changes on tables
------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS tr_modifier_cname ON dns.rr_cname	CASCADE ;
DROP TRIGGER IF EXISTS tr_modifier_dhcpprofil ON dns.dhcpprofil	CASCADE ;
DROP TRIGGER IF EXISTS tr_modifier_dhcprange ON dns.dhcprange	CASCADE ;
DROP TRIGGER IF EXISTS tr_modifier_ip ON dns.rr_ip		CASCADE ;
DROP TRIGGER IF EXISTS tr_modifier_mx ON dns.rr_mx		CASCADE ;
DROP TRIGGER IF EXISTS tr_modifier_relais ON dns.relais_dom	CASCADE ;
DROP TRIGGER IF EXISTS tr_modifier_reseau ON dns.reseau		CASCADE ;
DROP TRIGGER IF EXISTS tr_modifier_rr ON dns.rr			CASCADE ;
DROP TRIGGER IF EXISTS tr_modifier_zone ON dns.zone_normale	CASCADE ;
DROP TRIGGER IF EXISTS tr_modifier_zone4 ON dns.zone_reverse4	CASCADE ;
DROP TRIGGER IF EXISTS tr_modifier_zone6 ON dns.zone_reverse6	CASCADE ;
DROP TRIGGER IF EXISTS phnom ON pgauth."user"			CASCADE ;
DROP TRIGGER IF EXISTS tr_mod_eq ON topo.eq			CASCADE ;
DROP TRIGGER IF EXISTS tr_mod_vlan ON topo.vlan			CASCADE ;

DROP FUNCTION IF EXISTS add_soundex ()				CASCADE ;
DROP FUNCTION IF EXISTS pgauth.add_soundex ()			CASCADE ;
DROP FUNCTION IF EXISTS soundex (TEXT)				CASCADE ;
DROP FUNCTION IF EXISTS pgauth.soundex (TEXT)			CASCADE ;
DROP FUNCTION IF EXISTS gen_dhcp (INTEGER, INTEGER)		CASCADE ;
DROP FUNCTION IF EXISTS gen_norm_iddom (INTEGER)		CASCADE ;
DROP FUNCTION IF EXISTS gen_norm_iddom (INTEGER, INTEGER)	CASCADE ;
DROP FUNCTION IF EXISTS gen_norm_idrr (INTEGER)			CASCADE ;
DROP FUNCTION IF EXISTS gen_norm_idrr (INTEGER, INTEGER)	CASCADE ;
DROP FUNCTION IF EXISTS gen_relais (INTEGER)			CASCADE ;
DROP FUNCTION IF EXISTS gen_relais (INTEGER, INTEGER)		CASCADE ;
DROP FUNCTION IF EXISTS gen_rev4 (INET)				CASCADE ;
DROP FUNCTION IF EXISTS gen_rev4 (INET, INTEGER)		CASCADE ;
DROP FUNCTION IF EXISTS gen_rev6 (INET)				CASCADE ;
DROP FUNCTION IF EXISTS gen_rev6 (INET, INTEGER)		CASCADE ;
DROP FUNCTION IF EXISTS generer_dhcp ()				CASCADE ;
DROP FUNCTION IF EXISTS ipranges (CIDR, INTEGER, INTEGER)	CASCADE ;
DROP FUNCTION IF EXISTS markcidr (CIDR, INTEGER, INTEGER)	CASCADE ;
DROP FUNCTION IF EXISTS modif_routerdb ()			CASCADE ;
DROP FUNCTION IF EXISTS modif_vlan ()				CASCADE ;
DROP FUNCTION IF EXISTS modifier_ip ()				CASCADE ;
DROP FUNCTION IF EXISTS modifier_mxcname ()			CASCADE ;
DROP FUNCTION IF EXISTS modifier_relais ()			CASCADE ;
DROP FUNCTION IF EXISTS modifier_rr ()				CASCADE ;
DROP FUNCTION IF EXISTS modifier_zone ()			CASCADE ;
DROP FUNCTION IF EXISTS valide_dhcprange_grp (INTEGER, INET, INET) CASCADE ;
DROP FUNCTION IF EXISTS valide_ip_cor (INET, INTEGER)		CASCADE ;
DROP FUNCTION IF EXISTS valide_ip_grp (INET, INTEGER)		CASCADE ;

------------------------------------------------------------------------------
-- Schema changes
------------------------------------------------------------------------------


DELETE FROM global.config WHERE clef = 'dnsupdateperiod' ;
INSERT INTO global.config (clef, valeur) VALUES ('schemaversion', '22') ;

ALTER TABLE dns.seq_domaine RENAME TO seq_domain ;
ALTER TABLE dns.domaine RENAME TO domain ;
ALTER TABLE dns.domain RENAME COLUMN nom TO name ;

DROP TABLE dns.dhcp ;

-- Add views

CREATE SEQUENCE dns.seq_view START 1 ;
CREATE TABLE dns.view (
    idview	INT		-- view id
	    DEFAULT NEXTVAL ('dns.seq_view'),
    name	TEXT,		-- e.g.: "internal", "external"...
    gendhcp	INT,		-- 1 if dhcp conf must be generated

    UNIQUE (name),
    PRIMARY KEY (idview)
) ;

INSERT INTO dns.view (name) VALUES ('default') ;

-- Disambiguate zone name and attach zones to views

ALTER TABLE dns.zone
    RENAME COLUMN domaine TO name ;

ALTER TABLE dns.zone
    ADD COLUMN idview INT
    ;

ALTER TABLE dns.zone
    DROP CONSTRAINT zone_pkey ;

UPDATE dns.zone
    SET idview = (SELECT idview FROM dns.view WHERE name = 'default') ;

ALTER TABLE dns.zone_normale
    ADD UNIQUE (name),
    ADD FOREIGN KEY (idview) REFERENCES dns.view (idview),
    ADD PRIMARY KEY (idzone)
    ;

ALTER TABLE dns.zone_reverse4
    ADD UNIQUE (name),
    ADD FOREIGN KEY (idview) REFERENCES dns.view (idview),
    ADD PRIMARY KEY (idzone)
    ;

ALTER TABLE dns.zone_reverse6
    ADD UNIQUE (name),
    ADD FOREIGN KEY (idview) REFERENCES dns.view (idview),
    ADD PRIMARY KEY (idzone)
    ;

-- Add a new access right to views

CREATE TABLE dns.dr_view (
    idgrp	INT,		-- group
    idview	INT,		-- the view
    sort	INT,		-- sort class
    selected	INT,		-- selected by default in menus

    FOREIGN KEY (idgrp) REFERENCES global.groupe (idgrp),
    FOREIGN KEY (idview) REFERENCES dns.view (idview),
    PRIMARY KEY (idgrp, idview)
) ;

INSERT INTO dns.dr_view (idgrp, idview, sort, selected)
    SELECT idgrp, idview, 100, 1
	    FROM global.groupe, dns.view
	    WHERE view.name = 'default' ;


-- Attach IP addresses to views

ALTER TABLE dns.rr_ip
    DROP CONSTRAINT rr_ip_pkey ;

ALTER TABLE dns.rr_ip
    ADD COLUMN idview INT ;

UPDATE dns.rr_ip
    SET idview = (SELECT idview FROM dns.view WHERE name = 'default') ;

ALTER TABLE dns.rr_ip
    ADD FOREIGN KEY (idview) REFERENCES dns.view (idview),
    ADD PRIMARY KEY (idrr, adr, idview)
    ;

-- Attach CNAME to views (CNAME and pointed RR must be in the same view)

ALTER TABLE dns.rr_cname
    DROP CONSTRAINT rr_cname_pkey ;

ALTER TABLE dns.rr_cname
    ADD COLUMN idview INT ;

UPDATE dns.rr_cname
    SET idview = (SELECT idview FROM dns.view WHERE name = 'default') ;

ALTER TABLE dns.rr_cname
    ADD FOREIGN KEY (idview) REFERENCES dns.view (idview),
    ADD PRIMARY KEY (idrr, cname, idview)
    ;

-- Attach MX to views (MX and pointed RR must be in the same view)

ALTER TABLE dns.rr_mx
    DROP CONSTRAINT rr_mx_pkey ;

ALTER TABLE dns.rr_mx
    ADD COLUMN idview INT ;

UPDATE dns.rr_mx
    SET idview = (SELECT idview FROM dns.view WHERE name = 'default') ;

ALTER TABLE dns.rr_mx
    ADD FOREIGN KEY (idview) REFERENCES dns.view (idview),
    ADD PRIMARY KEY (idrr, mx, idview)
    ;

-- Attach roles to views

ALTER TABLE dns.role_web
    DROP CONSTRAINT role_web_pkey ;

ALTER TABLE dns.role_web
    ADD COLUMN idview INT ;

UPDATE dns.role_web
    SET idview = (SELECT idview FROM dns.view WHERE name = 'default') ;

ALTER TABLE dns.role_web
    ADD FOREIGN KEY (idview) REFERENCES dns.view (idview),
    ADD PRIMARY KEY (idrr, idview)
    ;


ALTER TABLE dns.role_mail
    DROP CONSTRAINT role_mail_pkey ;

ALTER TABLE dns.role_mail
    ADD COLUMN idviewrr INT,
    ADD COLUMN idviewheb INT ;

UPDATE dns.role_mail
    SET idviewrr = (SELECT idview FROM dns.view WHERE name = 'default'),
	idviewheb = (SELECT idview FROM dns.view WHERE name = 'default')
    ;

ALTER TABLE dns.role_mail
    ADD FOREIGN KEY (idviewrr) REFERENCES dns.view (idview),
    ADD FOREIGN KEY (idviewheb) REFERENCES dns.view (idview),
    ADD PRIMARY KEY (idrr, idviewrr)
    ;

-- Attach mail relays to views

ALTER TABLE dns.relais_dom
    DROP CONSTRAINT relais_dom_pkey ;

ALTER TABLE dns.relais_dom
    ADD COLUMN idview INT ;

UPDATE dns.relais_dom
    SET idview = (SELECT idview FROM dns.view WHERE name = 'default') ;

ALTER TABLE dns.relais_dom
    ADD FOREIGN KEY (idview) REFERENCES dns.view (idview),
    ADD PRIMARY KEY (iddom, mx, idview)
    ;

------------------------------------------------------------------------------
-- Create new functions/triggers for the new version
------------------------------------------------------------------------------

\i %NMLIBDIR%/sql22/functions.sql
\i %NMLIBDIR%/sql22/triggers.sql