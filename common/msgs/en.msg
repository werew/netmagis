#
# Netmagis translation messages
#

###############################################################################
# Configuration parameters
::msgcat::mcmset en {
 cfg:general {General parameters}

 cfg:datefmt:desc {Date/hour display format}
 cfg:datefmt:help {Date and time display format, used in data display and data editing. See Tcl clock(n) manual page for format specification.}
 cfg:dayfmt:desc {Date display format}
 cfg:dayfmt:help {Date display format (without hours). See Tcl clock(n) manual page for format specification.}
 cfg:authmethod:desc {Authentication method}
 cfg:authmethod:help {Authentication method. Choices are "internal" for internal user database (PostgreSQL tables), "LDAP" for an external directory or "CAS" for CAS single-sign-on associated with a LDAP directory.}
 cfg:authexpire:desc {Idle timeout}
 cfg:authexpire:help {Authenticated session idle timeout (in seconds). Keep a large value (e.g. a few hours to a few days) in order not to break user actions.}
 cfg:authtoklen:desc {Token length}
 cfg:authtoklen:help {Authentication token length in bytes. Don't change this unless you understand what you are doing.}
 cfg:wtmpexpire:desc {Last login expiration}
 cfg:wtmpexpire:help {Number of days to keep last login information.}
 cfg:failloginthreshold1:desc {Fail login threshold 1}
 cfg:failloginthreshold1:help {Threshold of bad login attempts. When this value is reached, the login is blocked with the delay given in the next parameter (Fail login delay 1)}
 cfg:faillogindelay1:desc {Blocking login delay 1}
 cfg:faillogindelay1:help {Delay (in seconds) to block the failed login when the first threshold of bad login attempts is reached}
 cfg:failloginthreshold2:desc {Fail login threshold 2}
 cfg:failloginthreshold2:help {Threshold of bad login attempts. When this value is reached, the login is blocked with the delay given in the next parameter (Fail login delay 2)}
 cfg:faillogindelay2:desc {Blocking login delay 2}
 cfg:faillogindelay2:help {Delay (in seconds) to block the failed login when the first threshold of bad login attempts is reached}
 cfg:failipthreshold1:desc {Failed attempts threshold 1 for an IP address}
 cfg:failipthreshold1:help {Threshold of bad login attempts for an IP address. When this value is reached, the IP address is blocked with the delay given in the next parameter (Fail ip delay 1)}
 cfg:failipdelay1:desc {Blocking IP delay 1}
 cfg:failipdelay1:help {Delay (in seconds) to block the IP address when the first threshold of bad attempts is reached for this IP address}
 cfg:failipthreshold2:desc {Failed attempts threshold 1 for an IP address}
 cfg:failipthreshold2:help {Threshold of bad login attempts for an IP address. When this value is reached, the IP address is blocked with the delay given in the next parameter (Fail ip delay 1)}
 cfg:failipdelay2:desc {Blocking IP delay 1}
 cfg:failipdelay2:help {Delay (in seconds) to block the IP address when the first threshold of bad attempts is reached for this IP address}
 cfg:pageformat:desc {Paper format}
 cfg:pageformat:help {Paper format for generated printable pages.}
 cfg:schemaversion:desc {Schema version}
 cfg:schemaversion:help {Current version of the database schema, used for consistency checks. This parameter is not writable.}

 cfg:dns {DNS parameters}

 cfg:defuser:desc {Default user}
 cfg:defuser:help {Default user is used in Netmagis command line programs, when the user's login is not found in the Netmagis database.}

 cfg:dhcp {DHCP parameters}

 cfg:dhcpdefdomain:desc {Default domain name}
 cfg:dhcpdefdomain:help {Default domain Name sent to DHCP clients without profile.}
 cfg:dhcpdefdnslist:desc {Default name servers list}
 cfg:dhcpdefdnslist:help {Default list of name servers sent to DHCP clients without profile, separated by spaces.}
 cfg:default_lease_time:desc {default_lease_time}
 cfg:default_lease_time:help {Value in seconds, for DHCP parameter "default_lease_time" used in the dynamic range generation. This value is used if the range specific parameter is null.}
 cfg:max_lease_time:desc {max_lease_time}
 cfg:max_lease_time:help {Value in seconds, for DHCP parameter "max_lease_time" used in the dynamic range generation. This value is used if the range specific parameter is null.}
 cfg:min_lease_time:desc {min_lease_time}
 cfg:min_lease_time:help {Minimum value for DHCP parameters in dynamic ranges. The goal of this value is to avoid that a user specifies a too short lease duration and thus generates an important DHCP traffic.}

 cfg:topo {"Topo" module parameters}

 cfg:topoactive:desc {Topo module activation}
 cfg:topoactive:help {Check this box to activate the "Topo" module.}
 cfg:defdomain:desc {Default domain}
 cfg:defdomain:help {Default domain name, since some equipments do not report FQDNs.}
 cfg:topofrom:desc {Topo mail sender}
 cfg:topofrom:help {"From" header of mails sent by the topod daemon when it detects modifications or abnormalities.}
 cfg:topoto:desc {Topo mail receiver}
 cfg:topoto:help {"To" header of mails sent by the topod daemon when it detects modifications or abnormalities.}
 cfg:topographddelay:desc {Topographd loop delay}
 cfg:topographddelay:help {Time (in seconds) between each main loop iteration in topographd daemon. Example: 5}
 cfg:toposendddelay:desc {Toposendd loop delay}
 cfg:toposendddelay:help {Time (in seconds) between each main loop iteration in toposendd daemon. Example: 5}
 cfg:topomaxstatus:desc {Max status lines}
 cfg:topomaxstatus:help {Maximum number of status lines kept in database. Example: 100}
 cfg:sensorexpire:desc {Sensor expiration time}
 cfg:sensorexpire:help {Delay (in days) before sensor expiration. Example: 30}
 cfg:modeqexpire:desc {Equipment modifications expiration time}
 cfg:modeqexpire:help {Delay (in days) before expiring "detected equipment modifications" in database. Example: 30}
 cfg:ifchangeexpire:desc {Interface changes expiration time}
 cfg:ifchangeexpire:help {Delay (in days) before expiring "interface changes" in database. Example: 30}
 cfg:fullrancidmin:desc {Min fullrancid start hour}
 cfg:fullrancidmin:help {Minimum start hour (0..24) for the daily full-rancid operations. Example: 2}
 cfg:fullrancidmax:desc {Max fullrancid start hour}
 cfg:fullrancidmax:help {Maximum start hour (0..24) for the daily full-rancid operations. Example: 4}

 cfg:mac {"MAC" module parameters}

 cfg:macactive:desc {MAC module activation}
 cfg:macactive:help {Check this box to activate the "MAC" module.}

 cfg:authcas {CAS authentication parameters}

 cfg:casurl:desc {CAS URL}
 cfg:casurl:help {Base URL of CAS service. Used to build the login, casValidate and casLogout URLs.}

 cfg:authldap {LDAP parameters}

 cfg:ldapurl:desc {LDAP server}
 cfg:ldapurl:help {URL to access LDAP server. Example: ldaps://ldap.domain.fr:636/}
 cfg:ldapbinddn:desc {Bind DN}
 cfg:ldapbinddn:help {Bind DN to authenticate against LDAP server. Example : cn=admin,dc=example,dc=com}
 cfg:ldapbindpw:desc {Bind password}
 cfg:ldapbindpw:help {Password to authenticate against LDAP server.}
 cfg:ldapbasedn:desc {Base DN}
 cfg:ldapbasedn:help {Base DN for people searches. Example: ou=people,dc=domain,dc=fr}
 cfg:ldapsearchlogin:desc {User search request}
 cfg:ldapsearchlogin:help {LDAP request to search for an user using the login name. Example: "(&(objectClass=inetOrgPerson)(uid=%s))"}
 cfg:ldapattrlogin:desc {Attribute "login"}
 cfg:ldapattrlogin:help {LDAP attribute to get login name. Example: "uid"}
 cfg:ldapattrname:desc {Attribute "last name"}
 cfg:ldapattrname:help {LDAP attribute to get user's name. Example: "sn"}
 cfg:ldapattrgivenname:desc {Attribute "first name"}
 cfg:ldapattrgivenname:help {LDAP attribute to get user's first name. Attributes may be empty or made from one or more LDAP attributes which will be joined together.}
 cfg:ldapattrmail:desc {Attribute "mail addresse"}
 cfg:ldapattrmail:help {LDAP attribute to get user's mail address. Example: "mail". Attributes may be empty or made from one or more LDAP attributes which will be joined together.}
 cfg:ldapattrphone:desc {Attribute "telephone number"}
 cfg:ldapattrphone:help {LDAP attribute to get user's telephone number. Example: "telephoneNumber". Attributes may be empty or made from one or more LDAP attributes which will be joined together.}
 cfg:ldapattrmobile:desc {Attribute "mobile phone"}
 cfg:ldapattrmobile:help {LDAP attribute to get user's mobile phone number. Example: "". Attributes may be empty or made from one or more LDAP attributes which will be joined together.}
 cfg:ldapattrfax:desc {Attribute "facsimile"}
 cfg:ldapattrfax:help {LDAP attribute to get user's facsimile number. Example: "facsimileTelephoneNumber". Attributes may be empty or made from one or more LDAP attributes which will be joined together.}
 cfg:ldapattraddr:desc {Attribute "address"}
 cfg:ldapattraddr:help {LDAP attribute to get user's postal address. Example: "postalAddress postalCode l". Attributes may be empty or made from one or more LDAP attributes which will be joined together.}

 cfg:authpgsql {Internal authentication parameters}

 cfg:authpgminpwlen:desc {Password minimum length}
 cfg:authpgminpwlen:help {Minimum authorized length for passwords entered with the internal authentication module.}
 cfg:authpgmaxpwlen:desc {Password maximum length}
 cfg:authpgmaxpwlen:help {Maximum authorized length for passwords entered with the internal authentication module.}
 cfg:authpgmailfrom:desc {Mail "From" for password change}
 cfg:authpgmailfrom:help {"From" header of mails sent by the application to an user when a password change occurs.}
 cfg:authpgmailreplyto:desc {Mail "Reply-To" for password change}
 cfg:authpgmailreplyto:help {"Reply-To" header of mails sent by the application to an user when a password change occurs.}
 cfg:authpgmailcc:desc {Mail "Cc" for password change}
 cfg:authpgmailcc:help {"Cc" header of mails sent by the application to an user when a password change occurs. This may be a list of addresses, separated by spaces.}
 cfg:authpgmailbcc:desc {Mail "Bcc" for password change}
 cfg:authpgmailbcc:help {"Bcc" header of mails sent by the application to an user when a password change occurs. This may be a list of addresses, separated by spaces.}
 cfg:authpgmailsubject:desc {Mail "Subject" for password change}
 cfg:authpgmailsubject:help {"Subject" header of mails sent by the application to an user when a password change occurs.}
 cfg:authpgmailbody:desc {Mail body for password change}
 cfg:authpgmailbody:help {Body of mails sent by the application to an user when a password change occurs. Following parameters are substitued: '%1$s'=login, '%2$s'=generated password.}
 cfg:authpggroupes:desc {Authorized Web groups}
 cfg:authpggroupes:help {List of groups (according to Apache daemon authentication) authorized to create an user. If the list is empty, all existing groups are authorized.}
}
