Configuring BGP | BGP Default Configuration

https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst9500/software/release/17-18/configuration_guide/rtng/b_1718_rtng_9500_cg/configuring_bgp.html#default-bgp-configuration

Table 2. Default BGP Configuration
| Feature									| Default Setting	|
| ---										| ---				|
| Aggregate address							| Disabled: None defined.	|
| AS path access list						| None defined.	|
| Auto summary								| Disabled.	|
| Best path									| + The router considers as-path in choosing a route and does not compare similar routes from external BGP peers.	+ Compare router ID: Disabled.	|
| BGP community list						| Number: None defined. When you permit a value for the community number, the list defaults to an implicit deny for everything else that has not been permitted.	|
|											| Format: Cisco default format (32-bit number).	
| BGP confederation identifier/peers		| Identifier: None configured.	|
|											| Peers: None identified.	|
| BGP Fast external fallover				| Enabled.	|
| BGP local preference						| 100. The range is 0 to 4294967295 with the higher value preferred.	|
| BGP network								| None specified; no backdoor route advertised.	|
| BGP route dampening						| Disabled by default. When enabled:	|
|											| Half-life is 15 minutes.	|
|											| Re-use is 750 (10-second increments).	|
|											| Suppress is 2000 (10-second increments).	|
| 											| Max-suppress-time is 4 times half-life; 60 minutes.	|
| BGP router ID								| The IP address of a loopback interface if one is configured or the highest IP address configured for a physical interface on the router.	|
| Default information originate (protocol or network redistribution)	| Disabled.	|
| Default metric							| Built-in, automatic metric translations.	|
| Distance									| External route administrative distance: 20 (acceptable values are from 1 to 255).	|
| 											| Internal route administrative distance: 200 (acceptable values are from 1 to 255).	|
|											| Local route administrative distance: 200 (acceptable values are from 1 to 255).	|
| Distribute list							| In (filter networks received in updates): Disabled.	|
|											| Out (suppress networks from being advertised in updates): Disabled.	|
| Internal route redistribution				| Disabled.	|
| IP prefix list							| None defined.	|
| Multi exit discriminator (MED)			| Always compare: Disabled. Does not compare MEDs for paths from neighbors in different autonomous systems.	|
|											| Best path compare: Disabled.	|
|											| MED missing as worst path: Disabled.	|
|											| Deterministic MED comparison is disabled.	|
| Neighbor									| Advertisement interval: 30 seconds for external peers; 5 seconds for internal peers.	|
|											| Change logging: Enabled.	|
|											| Conditional advertisement: Disabled.	|
|											| Default originate: No default route is sent to the neighbor.	|
|											| Description: None.	|
| 											| Distribute list: None defined.	|
|											| External BGP multihop: Only directly connected neighbors are allowed.	|
|											| Filter list: None used.	|
|											| Maximum number of prefixes received: No limit.	|
|											| Next hop (router as next hop for BGP neighbor): Disabled.	|
|											| Password: Disabled.	|
|											| Peer group: None defined; no members assigned.	|
|											| Prefix list: None specified.	|
| 											| Remote AS (add entry to neighbor BGP table): No peers defined.	|
|											| Private AS number removal: Disabled.	|
|											| Route maps: None applied to a peer.	|
|											| Send community attributes: None sent to neighbors.	|
|											| Shutdown or soft reconfiguration: Not enabled.	|
|											| Timers: keepalive: 60 seconds; holdtime: 180 seconds.	|
|											| Update source: Best local address.	|
|											| Version: BGP Version 4.	|
|											| Weight: Routes learned through BGP peer: 0; routes sourced by the local router: 32768.	|
| NSF Awareness								| Disabled. If enabled, allows Layer 3 switches to continue forwarding packets from a neighboring NSF-capable router during hardware or software changes.	|
| Route reflector							| None configured.	|
| Synchronization (BGP and IGP)				| Disabled.	|
| Table map update							| Disabled.	|
| Timers									| Keepalive: 60 seconds; holdtime: 180 seconds.	|
