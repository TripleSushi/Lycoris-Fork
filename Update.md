# Deepwoken Rewrite
**Module diff vs. previous snapshot: +0/-1/~4 (added/removed/changed)**
```diff
- (removed) RailbladeAerialCrit
+ (changed) RailbladeCrit
+ (changed) WeaponFlourishTest
+ (changed) RisingFlame
+ (changed) SmoulderingHallow (now blocks fully)
```
*Railblade should be fully fixed in this update with 'Greatsword' flourishes.*

**Timing diff vs. previous snapshot: +0/-0/~4 (animation: +0/-0/~4)**
```diff
+ (changed) Animation : RailbladeCritAerial (by Blastbrean)
+ (changed) Animation : FireBlade (by Blastbrean)
+ (changed) Animation : Onslaught (by Blastbrean)
+ (changed) Animation : FlameLeapReversal (by Blastbrean)
```

**New features?**
```diff
+ (changed) Blatant roll now ignores some Auto Parry checks (like swinging) when a move type is dodging
- (bug fix) (re-fix) Ethiron beam + moves that relied on repeat parries should now be fixed and no longer lag (atleast, as bad as before)
```

*Your commit ID should be "7f0899" when the update is pushed to you.*