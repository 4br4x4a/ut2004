// AutoBotMutator: tunes every Bot in the match (aggression, strafing, accuracy,
// weapon pick, item hunting). Offline / local botmatch use.
class AutoBotMutator extends Mutator config(AutoBot);

var config float BotSkill;          // 0..7
var config float Aggression;        // 0..1 (CombatStyle)
var config float StrafeAbility;     // -1..1
var config float AccuracyBonus;     // -1..1
var config bool  bHuntItems;        // hurt in a fight: break off and go for health/armor
var config int   RetreatHealth;     // health below which bHuntItems kicks in
var config float TuneInterval;

function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetTimer(TuneInterval, true);
}

function Timer()
{
    local Controller C;
    local Bot B;

    for (C = Level.ControllerList; C != None; C = C.NextController)
    {
        B = Bot(C);
        if (B == None || B.Pawn == None)
            continue;

        B.Skill          = FClamp(BotSkill, 0, 7);
        B.Accuracy       = AccuracyBonus;
        B.StrafingAbility= StrafeAbility;
        B.CombatStyle    = Aggression;     // >0 charges, <0 holds distance
        B.bJumpy         = true;           // dodge more
        B.bLeadTarget    = true;           // lead projectiles

        if (bHuntItems)
            SeekHealth(B);

        // always prefer the best weapon for current range
        B.Pawn.Controller.SwitchToBestWeapon();
    }
}

// Low health in a fight: retreat to the best pickup. At low health the engine
// rates health packs and shields highest, so this goes for them; it is the same
// path Bot.DoRetreat() takes, and the bot keeps shooting while it moves.
function SeekHealth(Bot B)
{
    if (B.Enemy == None || B.Pawn.Health >= RetreatHealth)
        return;
    if (B.IsInState('Retreating') || B.IsInState('Fallback'))
        return;                     // already heading for a pickup
    if (B.Squad != None && B.Squad.MustKeepEnemy(B.Enemy))
        return;                     // e.g. enemy flag carrier - keep chasing
    if (B.FindInventoryGoal(0))
    {
        B.GoalString = "AutoBot: retreat for health";
        B.GotoState('Retreating');
    }
}

defaultproperties
{
    FriendlyName="AutoBot"
    Description="Makes bots play more aggressively and accurately."
    GroupName="AutoBot"
    BotSkill=6.0
    Aggression=0.6
    StrafeAbility=0.8
    AccuracyBonus=0.5
    bHuntItems=true
    RetreatHealth=40
    TuneInterval=1.0
}
