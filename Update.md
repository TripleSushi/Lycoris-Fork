# Deepwoken Rewrite
**Module diff vs. previous snapshot: no changes detected.**

**Timing diff vs. previous snapshot: +2/-0/~12 (animation: +2/-0/~12)**
```diff
+ (changed) Animation : RedDeathCrit
+ (added) Animation : UmbralSlashMed
+ (added) Animation : RedDeathRunningCrit
+ (changed) Animation : RunningAttackSword1
+ (changed) Animation : FireEruption
+ (changed) Animation : ENMITYEXECUTE
+ (changed) Animation : ENMITYSTOMPSLICE
+ (changed) Animation : ENMITYAXETHROW
+ (changed) Animation : Spear3RunningAttack
+ (changed) Animation : ShadowGun
+ (changed) Animation : CrabboRexBeam
+ (changed) Animation : HeavyAerial
+ (changed) Animation : ENMITYRIGHLEFT
+ (changed) Animation : ENMITYHOMERUN
```

**New features?**
```diff
- (bug fix) Fixed a bug where modules that created a PartTiming would be corrupted due to no encryption
- (bug fix) Fixed a bug where projectiles would not be detected by specifically buyers
- (bug fix) Fixed a bug where broken projectile detection would cause the script not to load in specific places
- (bug fix) Added a forced 150ms cooldown to Auto Wisp after shifting to prevent failure
+ (added) Optimized "Rainbow Toggle" when you right click a toggle :))))
```
*1. Fixed Enmity AP with this update. It should be completely ready for use.*
*2. Fixed Ethirion AP with this update. It should parry the beam and the blinding move now.*
*3. Fixed all projectiles with this update.*

*Your commit ID should == "XXXXX" when the update is fully pushed to you.*