# BGP - Route-map / Access-list / Prefix-list Examples

## BGP Community Manipulation

#### Community Format

#### Extended Community Format

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

#### Community-list - Extended

#### Extcommunity-list - Global Configuration Mode

#### Extcommunity-list - Standard IP Extended Community List Configuration Mode

#### Extcommunity-list - Expanded IP Extended Community List Configuration Mode

#### Large-Community-list - Standard Large Community

#### Large-Community-list - Extended Large Community

#### Community-list - Delete - Match

#### Route-map - Community-list - Match Standard Community

#### Route-map - Community-list - Match Standard Community - Exact

#### Route-map - Community-list - Match Extended Community

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
