# BGP - Route-map / Access-list / Prefix-list Examples

## Standard Access Control Lists
Define packets based solely on the source network.  Does not include sequence numbers.  This means it's not possible to
delete specific entries.
```
permit any                                                 ! Permits all networks
permit 0.0.0.0 255.255.255.255                             ! Permits all networks
permit 10.1.0.0 0.0.255.255                                ! Permits all networks in the 10.1.0.0 range
permit host 192.0.2.1                                      ! Permits only the 192.0.2.1 /32 network
!
access-list 102 permit tcp any any eq 179                  ! Permits BGP updates
access-list 102 permit tcp any eq 179 any                  ! Permits BGP updates
!
access-list 10 permit 192.168.0.0 0.0.254.0                ! Permits all even /24 networks in the third octet
!
access-list 11 permit 192.168.1.0 0.0.254.0                ! Permits all odd /24 networks in the third octet
```

## Extended Access Controls Lists
Define the packet based on source, destination, protocol, port, or a combination of other packet attribute. With route 
filtering, ACLs are only concerned with the source, destination, and protocol.
<br/><br/>
Extended ACLs react differently when matching BGP routes.  The source fileds match against the network portion of the
route.  The destination fileds match against the network mask.
```
permit protocol source source-wildcard destination destination-wildcard
```
```
permit ip any any                                           ! Permits all networks
permit ip 0.0.0.0 255.255.255.255 0.0.0.0 255.255.255.255   ! Permits all networks
permit ip 10.0.0.0 0.0.0.0 255.255.0.0 0.0.0.0              ! Permits only the 10.0.0.0 /16 netowrk
permit ip 10.0.0.0 0.0.255.0 255.255.255.0 0.0.0.0          ! Permits any 10.0.x.0 network with a /24 prefix length
permit ip 10.0.0.0 0.0.255.255 255.255.255.0 0.0.0.255      ! Permits any 10.0.0.0 network with a /24 - /32 prefix length
permit ip 10.0.0.0 0.0.255.255 255.255.255.128 0.0.0.127    ! Permits any 10.0.0.0 network with a /24 - /32 prefix length
!
access-list 101 permit ip 192.168.0.0 0.0.0.0 255.255.0.0 0.0.0.0          ! Permits 192.168.0.0 /16, perhaps an aggregate-address
access-list 101 deny ip 192.168.0.0 0.0.255.255 255.255.0.0 0.0.255.255    ! But denies more specific routes
!
access-list 102 permit ip 10.1.0.0 0.0.0.0 255.255.255.0 0.0.0.0           ! Permits 10.1.0.0 /24
access-list 102 deny ip 10.1.0.0 0.0.255.255 255.255.0.0 0.0.255.255       ! But denies 10.1.0.0 /16 and all other subnets of 10.1.0.0
```

## Prefix Lists
```
ip prefix-list RED deny 0.0.0.0/0                           ! Denies the default route 0.0.0.0/0
ip prefix-list BLUE permit 172.16.1.0/24                    ! Permits the 172.16.1.0/24 network
ip prefix-list YELLOW permit 10.0.0.0/8 le 24               ! Permits networks from 10.0.0.0/8 that have a mask length less than or equal to /24
ip prefix-list PINK deny 10.0.0.0/8 ge 25                   ! Permits networks from 10.0.0.0/8 that have a mask length greater than or equal to /25
ip prefix-list GREEN permit 0.0.0.0/0 ge 8 le 24            ! Permits any network that have a mask length from /8 to /24
ip prefix-list ORANGE deny 10.0.0.0/8 le 32                 ! Denies any networks with any mask length from the 10.0.0.0/8 network
```

## BGP Community Manipulation

#### Community Format
- BGP attribute COMMUNITIES with an attribute value of 8.
- 32 bit value that can be displayed in 3 different formats.
- Community decimal number format with a range from 1 to 4,294,967,295.
- Community decimal in AA:NN format.  AA is 16 bits that represent an Autonomous System Number (ASN).  NN is 16 bits that
  represent a locally defined number.
  - To display communities in the AA:NN format, use the global configuration "**ip bgp-community new-format**".
- Community hexadecimal format with a range from 0x00000000 to 0xFFFFFFFFFFFF
<br/><br/><br/>

- Well-known communities:
```
  - gshut
    - Hex 0xFFFF0000 or Decimal AA:NN 65535:00 or Decimal 4294901760
    - Officially named GRACEFUL_SHUTDOWN.
  - no-export
    - Hex 0xFFFFFF01 or Decimal AA:NN 65535:65281 or Decimal 4294967041
  - no-advertise
    - Hex 0xFFFFFF02 or Decimal AA:NN 65535:65282 or Decimal 4294677042
  - local-as
    - Hex 0xFFFFFF03 or Decimal AA:NN 65535:65283 or Decimal 4294967043
    - Offically named NO_EXPORT_SUBCONFED.
```
  - Cisco documentation claims "Internet" is a well-known community is several places that is applied to all prefixes by default.
  - RFC 1997 says, "By default, all destinations belong to the general Internet community."
  - "Internet" is not listed as a well-known community by IANA.
  - https://www.iana.org/assignments/bgp-well-known-communities/bgp-well-known-communities.xhtml
<br/><br/><br/>

- It's common for service providers to allow their customers to set the LOCAL_PREF on the PE routers through the use of BGP
  communities.  For example, a BGP community of 3356:90 would set the LOCAL_PREF to 90.
- whois -r whois.radb.net as3356

#### Extended Community Format
- BGP attribute EXTENDED COMMUNITY with an attribute value of 16.
- RFC 4360 - BGP Extended Communities Attribute
- RFC 7153 - IANA Registries for BGP Extended Communities
- 64 bit value.
- Extended communities are defined by a Type field.  1 octet is used to define the extended community type.  The Value field
  contains 7 octets.
  - Examples:
    - 0x04 - QoS Marking
    - 0x05 - CoS Capability
  - The Type field has values defined for "Transitive Extended Community Types" and "Non-transitive Extended Community Types".
- Most extended communities are further defined by a Sub-Type field.  1 octet for the Type, 1 octet for the for the Sub-Type,
  and 6 octets for the Value.
- https://www.iana.org/assignments/bgp-extended-communities/bgp-extended-communities.xhtml

#### Large Community Format
- BGP attribute LARGE_COMMUNITY with an attribute value of 32.
- RFC 8092 - BGP Large Communities Attribute
- RFC 8195 - Use of BGP Large Communities
- Designed for the adoption of 4 octet ASNs defince in RFC 6793 - BGP Support for Four-Octet Autonomous System (AS) Number Space.
  - The four octet ASNs do not fit into the existing registered BGP Extended Communities.
- 12 byte value.
- The BGP Large Community has 3 sections:
  - Global Administrator:  A four-octet namespace identifier.
    - This field should be an ASN.
  - Local Data Part 1:  A four-octect operator-defined value.
  - Local Data Part 1:  A four-octect operator-defince value.
- IANA does not manage a registry of BGP Large Communities.  RFC 8195 provides informational examples and uses of BGP Large
  Communities based on an ASN:Function:Parameter format.

#### Expanded Community List
Expanded community lists are used to filter communities using a regular expression. Regular expressions are used to configure patterns to match community attributes. The order for matching using the * or + character is longest construct first. Nested constructs are matched from the outside in. Concatenated constructs are matched beginning at the left side. If a regular expression can match two different parts of an input string, it will match the earliest part first.  Regular expressions can be used only with expanded community lists.
<br/><br/>
- Standard Community List:  1 - 99
- Expanded Community List:  100 - 500
- Standard Extended Community List:  1 - 99
- Expanded Extended Community List:  100 - 500

```
R1(config)# ip community-list expanded BLUE deny 50000:[0-9][0-9]_
!
R1(config)# ip extcommunity-list 500 deny _65412_ 
!
R1(config)# ip extcommunity-list RED 
R1(config-extcom-list)# 10 permit 65412:[0-9][0-9][0-9][0-9][0-9]_ 
```

#### Route-map - Community
- Set a community for prefixes being advertised to a neighbor.
- Replaces any existing communities.

```
R1(config)# route-map COMMUNITY permit 10
  set community no-advertise
!
router bgp 65536
  neighbor 192.0.2.1 send-community
  neighbor 192.0.2.1 route-map COMMUNITY out
```

#### Route-map - Community - Network Statement
- Set a community for a prefix.
- Replaces any existing communities.

```
R1(config)# route-map COMMUNITY permit 10
  set community local-as
  !
router bgp 65536
  neighbor 192.0.2.1 send-community
  network 198.51.100.0 mask 255.255.255.0 route-map COMMUNITY
```

#### Route-map - Community - Access-list
- Set a community for prefixes matching an ACL advertised to a neighbor.
- Replaces any existing community.
- IP address subnet permit match.

```
R1(config)# access-list 1 permit 198.51.100.0 0.255.255.255
!
route-map COMMUNITY permit 10
  match ip address 1
  set community no-advertise
!
route-map COMMUNITY permit 90
!
router bgp 65536
  neighbor 192.0.2.1 send-community
  neighbor 192.0.2.1 route-map COMMUNITY out
```

#### Route-map - Community - Extended Access-list

#### Route-map - Community - Access-list - Additive

#### Route-map - Community - Access-list - Delete

#### Route-map - Community - Prefix-list

#### Route-map - Community - AS-Path

#### Community-list - Standard Number

#### Community-list - Standard Name

#### Community-list - Extended

#### Extcommunity-list - Global Configuration Mode

#### Extcommunity-list - Standard IP Extended Community List Configuration Mode

#### Extcommunity-list - Expanded IP Extended Community List Configuration Mode

#### Large-Community-list - Standard Large Community

#### Large-Community-list - Extended Large Community

#### Community-list - Delete - Match

#### Route-map - Community-list - Match Standard Community

#### Route-map - Community-list - Match Standard Community - Exact

#### Route-map - Community-list - Match Expanded Community

#### Route-map - Comm-list - Delete

#### Route-map - Extcomm-list - Delete

#### Route-map - Extcommunity - Cost

#### Route-map - Extcommunity - RT

#### Route-map - Extcommunity - soo

#### Route-map - Extcommunity - vpn-distinguisher

#### Route-map - Large-Community-list - Match Large Community

#### Route-map - Large-Community-List - Match Large Community - Exact-match



## BGP Attribute Manipulation

#### Extended Community Cost - Pre-Bestpath

#### Weight - Filter-list - AS-Path

#### Weight - Route-map

#### Weight - Route-map - Access-list

#### Weight - Route-map - Prefix-list

#### Weight - Route-map - AS-Path

#### Weight - Route-map - Community-list

#### Local-preference - Route-map

#### Local-preference - Route-map - Access-list

#### Local-preference - Route-map - Prefix-list

#### Local-preference - Route-map - AS-Path

#### Local-preference - Route-map - Community-list

#### Local-preference - Default

#### Local-preference - Route-map - Match

#### Locally Originated Path - Network Statement

#### Locally Originated Path - Redistribution

#### Locally Originated Path - Aggregate-address

#### AS-Path Prepend

#### AS-Path - Access-list

#### AS-Path - Route-map

#### AS-Path - Route-map - Community-list

#### AS-Path - Bestpath Ignore

#### Multi-Exit Discriminator (MED) - Route-map

#### MED - Route-map - Access-list

#### MED - Route-map - Prefix-list

#### MED - Route-map - Community-list

#### MED - Always-compare-med

#### MED - Confed

#### MED - Bestpath Confed Missing-is-worst

#### MED - Missing-is-worst

#### IGP Metric Ignore

#### Extended Community Cost - Route-map - Access-list

#### Extended Community Cost - Route-map - Prefix-list

#### Community-cost Ignore

#### Router-id - Compare


## BGP Aggregation

#### Aggregate-address

#### Aggregate-address - Summary-only

#### Aggregate-address - AS-Set

#### Aggregate-address - Attribute-map

#### Aggregate-address - Advertise-map

#### Aggregate-address - Suppress-map

#### Aggregate-address - Unsuppress-map


## BGP Filtering

#### Filter-list - AS-Path

#### Route Filtering - Prefix-list

#### Route Filtering - Destribute-list - Router Configuration

#### Route Filtering - Distribute-list - Neighbor

#### Route Filtering - Distribute-list - Standard Access-list

#### Route Filtering - Distribute-list - Extended Access-list

#### Route Filtering - Route-map

#### Route Filtering - AS-Path - String

#### Route Filtering - AS-Path - Regular Expression

#### Route Filtering - Communities

#### Default Route - Route-map

#### Dampening - Route-map

#### Administrative Distance - Access-list

#### Redistribution - AS-Path Tag

#### Table-map - Automatice-tag
