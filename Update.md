# Deepwoken Rewrite
**Module diff vs. previous snapshot: +1/-0/~1 (added/removed/changed)**
```diff
+ (added) SquibboAxeKick
+ (changed) StrongLeft
```

**Timing diff vs. previous snapshot: +31/-0/~64 (animation: +27/-0/~11, part: +0/-0/~52, sound: +1/-0/~0, effect: +3/-0/~1)**
```diff
+ (added) Animation : ShogunDoubleSwing (by Juanito)
+ (added) Animation : ShogunDazeSwing (by Blastbrean)
+ (added) Animation : ShogunAerialDoubleSwing (by Blastbrean)
+ (added) Animation : ShogunUpsweep (by Blastbrean)
+ (added) Animation : ShogunTripleFang (by Juanito)
+ (added) Animation : ShogunGreatCleave (by Juanito)
+ (changed) Animation : HailbreakerCritHit (by Blastbrean)
+ (changed) Animation : SquidwardSlash1 (by Juanito)
+ (changed) Animation : KanaboCrit (by Juanito)
+ (changed) Animation : SquidwardSlash2 (by Juanito)
+ (changed) Animation : SquidwardSlash3 (by Juanito)
+ (changed) Animation : IceHeroCrit (by Blastbrean)
+ (changed) Animation : SwordCritical (by Blastbrean)
+ (changed) Animation : DarksteelSwordCrit (by Juanito)
+ (changed) Animation : HullwreckerCrit (by Juanito)
+ (added) Animation : ShogunShadowFold (by Juanito)
+ (changed) Animation : UntrainedFistCrit (by Blastbrean)
+ (added) Animation : ShogunEightHeavens (by Juanito)
+ (changed) Animation : HailbreakerCrit (by Blastbrean)
+ (added) Animation : RatKingGoldenSlamCombo (by Juanito)
+ (added) Animation : RatKingGiantSlash (by Juanito)
+ (added) Animation : RatKingLeapSlash (by Juanito)
+ (added) Animation : RatKingTPSlash (by Juanito)
+ (added) Animation : RatKingDoubleSlashDash (by Juanito)
+ (added) Animation : RatKingDashCombo (by Juanito)
+ (added) Animation : RatKingGoldenSlam (by Juanito)
+ (added) Animation : RatKingTPCombo (by Juanito)
+ (added) Animation : RatKingStabSlash (by Juanito)
+ (added) Animation : RatKingTripleFeint (by Juanito)
+ (added) Animation : RatKingSpinStart (by Juanito)
+ (added) Animation : RatKingSpinMove (by Juanito)
+ (added) Animation : RatKingTurnDash (by Juanito)
+ (added) Animation : SquidwardTriple (by Juanito)
+ (added) Animation : ENMITYFLYINGSLAM (by Juanito)
+ (added) Animation : ENMITYFLYSMASH (by Juanito)
+ (added) Animation : ENMITYLEAP (by Juanito)
+ (added) Animation : ENMITYSLASHLEAP (by Juanito)
+ (added) Animation : RegentGrapplePull (by Juanito)
+ (added) Sound : GoldenSnapFire (by Juanito)
+ (changed) Effect : OwlDisperse (by Blastbrean)
+ (added) Effect : StringClusterIndicator (by Blastbrean)
+ (added) Effect : JumpClusterIndicator (by Juanito)
+ (added) Effect : DodgePlsIndicator (by Juanito)
```
**True Enmity AP is not done yet. We made those animations in a panic. Currently, you can void him.**
**Only the first phase of Lord Regent is done. But, this will get you to a humanoid fight which is more managable.**
**You must keep swinging and swinging your way forwards to fight him.**
**Shogun is pretty consistent apart from one of his stomps.**
**Rat King puts a ton of pressure on you. Swing carefully.**

**Any new features?**
```diff
+ (added) Added 'Mark User Holding Sack' to Player ESP
+ (added) Bag ESP now works on VOI Sacks
+ (added) Chest ESP now works on VOI Chests
+ (added) Aggressive pathfind breaker
- (bug fix) Attempted to prevent abnormal ESP sizes with new cache invalidation
- (bug fix) Script now uses 1:1 InputClient jump code which gives you actual jump frames for the AP
```

*If you're wondering on what to use or where to buy from...*
**Buy an executor like Wave @ https://robloxcheatz.com/product?id=6d1f91b5-4599-467a-b9ba-eadef98c63fe&ref=lycoris**

*Your commit ID should == "0518e6" when the update is fully pushed to you.*