# BGP - Route-map / Access-list / Prefix-list Examples

## BGP Community Manipulation

#### Route-map
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

#### Route-map - Network Statement
- Set community

```
R1(config)# route-map COMMUNITY permit 10
  set community local-as
  !
router bgp 65536
  neighbor 192.0.2.1 send-community
  network 198.51.100.0 mask 255.255.255.0 route-map COMMUNITY
```

#### Route-map - Standard Access-list
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

#### Route-map - Extended Access-list

#### Route-map - Access-list - Additive

#### Route-map - Access-list - Delete

#### Route-map - Prefix-list

#### Route-map - AS-Path

#### Community-list - Standard - Match

#### Community-list - Extended - Match

#### Community-list - Large - Match

#### Community-list - Delete - Match



## BGP Attribute Manipulation


## BGP Aggregation


## BGP Filtering
