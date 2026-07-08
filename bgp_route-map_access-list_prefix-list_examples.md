# BGP - Route-map / Access-list / Prefix-list Examples

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
  - gshut
    - Hex: 0xFFFF0000 or Decimal:  65535:00
    - Officially named GRACEFUL_SHUTDOWN.
  - no-export
    - Hex: 0xFFFFFF01 or Decimal: 65535:65281
  - no-advertise
    - Hex: 0xFFFFFF02 or Decimal: 65535:65282
  - local-as
    - Hex: 0xFFFFFF03 or Decimal: 65535:65283
    - Offically named NO_EXPORT_SUBCONFED.
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

#### Route-map - Community - Standard Access-list
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


## BGP Aggregation


## BGP Filtering
