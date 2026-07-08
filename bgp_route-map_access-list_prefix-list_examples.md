# BGP - Route-map / Access-list / Prefix-list Examples

## BGP Community Manipulation

#### Community Format
- 32 bit value that can be displayed in 3 different formats.
- Community decimal number format with a range from 1 to 4,294,967,295.
- Community decimal in AA:NN format.  AA is 16 bits that represent an Autonomous System Number (ASN).  NN is 16 bits that
  represent a locally defined number.
  - To display communities in the AA:NN format, use the global configuration "ip bgp-community new-format".
- Community hexadecimal format with a range from 0x00000000 to 0xFFFFFFFFFFFF


- Well-known communities:
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


- It's common for service providers to allow their customers to set the LOCAL_PREF on the PE routers through the use of BGP
  communities.  For example, a BGP community of 3356:90 would set the LOCAL_PREF to 90.
- whois -r whois.radb.net as3356

#### Expanded Community Format

#### Large Community Format

#### Route-map - Community
- Set community
- Replaces any existing communities

```
R1(config)# route-map COMMUNITY permit 10
  set community no-advertise
!
router bgp 65536
  neighbor 192.0.2.1 send-community
  neighbor 192.0.2.1 route-map COMMUNITY out
```

#### Route-map - Community - Network Statement
- Set community

```
R1(config)# route-map COMMUNITY permit 10
  set community local-as
  !
router bgp 65536
  neighbor 192.0.2.1 send-community
  network 198.51.100.0 mask 255.255.255.0 route-map COMMUNITY
```

#### Route-map - Community - Standard Access-list
- Set community
- Replaces any existing community
- IP address subnet permit match

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

#### Community-list - Expanded

#### Extcommunity-list - Global Configuration Mode

#### Extcommunity-list - Standard IP Expanded Community List Configuration Mode

#### Extcommunity-list - Expanded IP Expanded Community List Configuration Mode

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
