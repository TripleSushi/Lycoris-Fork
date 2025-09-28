# Deepwoken Rewrite
**Module diff vs. previous snapshot: +8/-1/~24 (added/removed/changed)**
```diff
+ (added) DreadBreath
+ (added) GunUppercut
+ (added) WeaponAerialAttackTest
+ (added) WeaponFlourishTest
+ (added) WeaponRunningAttackTest
+ (added) WeaponTest
+ (added) WeaponUppercutTest
+ (added) WindForge
- (removed) LightningChargeUp
+ (changed) ArcBeam
+ (changed) TwisterKicks
+ (changed) RisingThunder
+ (changed) DaggerSwing
+ (changed) CroccoSwipes
+ (changed) CroccoTripleBite
+ (changed) RapidPunches
+ (changed) DualCurvedBladeCrit
+ (changed) TelegraphMinor
+ (changed) HeavenlyWind
+ (changed) FistRunningAttack
+ (changed) ChaserSlam
+ (changed) LightningSlash
+ (changed) SilentheartHeavyRisingStar
+ (changed) CroccoTailWhip
+ (changed) JusKaritaUppercut
+ (changed) FlareVolley
+ (changed) SilentheartHeavyRelentless
+ (changed) DaggerAerial
+ (changed) IceForgeCast
+ (changed) RapierSwing
+ (changed) Revenge
+ (changed) ShadowGun
+ (changed) GunShot
```

**Timing diff vs. previous snapshot: +18/-5/~42 (animation: +10/-3/~39, part: +8/-2/~2, sound: +0/-0/~1)**
```diff
+ (changed) Animation : HeavyAerial
+ (added) Animation : ScoundrelCrit
+ (changed) Animation : FlashdrawStrike
+ (added) Animation : ScalesplitterCrit
- (removed) Animation : dsdasdasda
+ (changed) Animation : WindForge
+ (changed) Animation : BounderLeap
+ (changed) Animation : LightningStream
+ (changed) Animation : ElectroCarve
+ (changed) Animation : FistRunningAttack
+ (changed) Animation : SilentheartHeavyRelentless
+ (changed) Animation : BoneBoyRushGo
+ (changed) Animation : ContractorGrab
+ (changed) Animation : SwordAerialStab
- (removed) Animation : MetalGatling
+ (changed) Animation : Spear3RunningAttack
+ (changed) Animation : RunningAttackKatana
+ (changed) Animation : FlamingScourgeReversal
+ (changed) Animation : Lumberaxe
+ (changed) Animation : ShoulderBashGo
+ (changed) Animation : ArcWave
+ (changed) Animation : RedDeathRunningCrit
+ (changed) Animation : FlameRepulsion
+ (changed) Animation : HeavenlyWind
+ (changed) Animation : TwisterKicks
+ (changed) Animation : RunningAttackSword1
+ (changed) Animation : FrostGrabWindup
+ (changed) Animation : ShadowEruptionCast
+ (changed) Animation : ShadowGun
+ (changed) Animation : FlameGrab
+ (changed) Animation : MudskipperBlast
+ (changed) Animation : ShardBow
+ (changed) Animation : JetstrikerFakeStrike
+ (changed) Animation : IceForgeCast
+ (changed) Animation : ContractorPull
+ (changed) Animation : WardensBladeCrit
- (removed) Animation : WindPassage
+ (changed) Animation : ExhaustionStrike
+ (changed) Animation : RisingThunder
+ (changed) Animation : CurvedBladeCrit
+ (changed) Animation : EnforcerPullHuman
+ (changed) Animation : SkyshatterRound
+ (changed) Animation : BruteHeavyPunch
+ (changed) Animation : LightningChoke
+ (added) Animation : PermaFrostPrison
+ (added) Animation : StormseyeCrit
+ (added) Animation : ArcBeaaaaaamAir
+ (added) Animation : WardensBladeCrit2
+ (added) Animation : Greatcannon1
+ (added) Animation : Greatcannon2
+ (added) Animation : WhirlingBlade
+ (added) Animation : CryptCrit
+ (changed) Part : Shard
- (removed) Part : EruptionCylinder
- (removed) Part : LightningStrike
+ (added) Part : PermaFrostSparks
+ (added) Part : GrandSpark
+ (added) Part : LightningStreamPart
+ (added) Part : windyp
+ (added) Part : ShadowMetero
+ (added) Part : MetalGatling
+ (added) Part : Cannonball
+ (added) Part : FlameSentinelAzure
+ (changed) Sound : Glare
```

**New features?**
```diff
- (bug fix) Fixed a bug where Builder Highlighter would fail on "Will O' Wisp" and "Shadow Meteors"
- (bug fix) Fixed a bug where Auto Flow State would fail on any right-click move
- (bug fix) Fixed a bug where your cursor would no longer force show and be hidden
- (bug fix) Fixed a bug where "Disable AP If Holding Block" would unblock
- (bug fix) Fixed a bug where the entire "Effect AP" was missing in the buyer version which will now reflect in future difference message(s)
+ (added) Tags on every single timing are now added. You *should* be able to use the filtering for M1s, criticals, and etc.
```
*1. Auto flow state is inconsistent still.*
*2. Generic combat fixes for every weapon type tommorow.*
*3. Golem dodges are now fixed.*

*Your commit ID should == "4fa282" when the update is fully pushed to you.*