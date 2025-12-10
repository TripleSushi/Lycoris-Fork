# Deepwoken Rewrite
**Module diff vs. previous snapshot: +3/-1/~6 (added/removed/changed)**
```diff
+ (added) ElectroCarve
+ (added) FireForgeCast
+ (added) FlameGrab
- (removed) WindForge
+ (changed) WeaponFlourishTest
+ (changed) IceForgeCast
+ (changed) DreadBreath
+ (changed) WeaponTest
+ (changed) WeaponAerialAttackTest
+ (changed) RapidPunches
```

**Timing diff vs. previous snapshot: +2/-1/~19 (animation: +1/-0/~18, part: +0/-1/~0, sound: +1/-0/~0, effect: +0/-0/~1)**
```diff
+ (changed) Animation : ReverieCrit (by Juanito)
+ (changed) Animation : AstralWind (by Juanito)
+ (changed) Animation : TwisterKicks (by Blastbrean)
+ (changed) Animation : SwordCritical (by Blastbrean)
+ (changed) Animation : WindForge (by Blastbrean)
+ (added) Animation : FireForgeCast (by Blastbrean)
+ (changed) Animation : PyreKeeperCritRunningWindup (by Blastbrean)
+ (changed) Animation : PurpleCloudCrit (by Blastbrean)
+ (changed) Animation : SquidwardSlash3 (by Juanito)
+ (changed) Animation : SquidwardSlash2 (by Juanito)
+ (changed) Animation : SquidwardSlash1 (by Juanito)
+ (changed) Animation : OwlPrimeSwipe (by Juanito)
+ (changed) Animation : DeepOwlSwipe1 (by Juanito)
+ (changed) Animation : DeepOwlSwipe2 (by Juanito)
+ (changed) Animation : RadiantDawn (by Blastbrean)
+ (changed) Animation : ScalesplitterCrit (by Blastbrean)
+ (changed) Animation : NightAxeCrit (by Blastbrean)
+ (changed) Animation : Heartwing (by Blastbrean)
+ (changed) Animation : BoltcrusherCrit (by Blastbrean)
- (removed) Part : GaleTrap (by Blastbrean)
+ (added) Sound : SpecialistStormStrike (by Juanito)
+ (changed) Effect : OwlDisperse (by Juanito)
```
*If you now see the base combat, you will see something a little different on M1s and Flourishes.*
*I made them more precise by using spheres (replicating a crescent shape) - report any issues.*
*Comparing size wise to the old hitboxes, they should be roughly bigger than they were before.*

**Any new features?**
```diff
- (bug fix) Manually managed notifications now use the scaled notification size
- (bug fix) Info spoofing has now perfect removal with no gaps (this would always activate on injection)
- (bug fix) Info spoofing now does not set some manual text settings when it is turned off (preventing it from showing on injection)
- (bug fix) When disabled per-timing player prediction was on, it would force itself on for other-prediction-based stuff.
- (bug fix) Made the dynamic bounding box search for body parts more strictly
- (bug fix) Dynamic bounding box now invalidates the cache when the detected size has increased by a large amount
+ (changed) Timing probabilities list is now alphabetically sorted
+ (changed) Auto parry now respects AP frames (please report any issues with this, I remember some on Legacy; it should say it detected AP frames in notifications)
+ (added) Auto mantra followup
+ (added) Visual option to see whether or not someone is above, equal, or below to you relative in HP
```

*If you're wondering on what to use or where to buy from...*
**Buy an executor like Wave @ https://robloxcheatz.com/product?id=6d1f91b5-4599-467a-b9ba-eadef98c63fe&ref=lycoris**

*Your commit ID should == "367501" when the update is fully pushed to you.*