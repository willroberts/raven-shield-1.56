//=============================================================================
// Mutator.
//
// Mutators allow modifications to gameplay while keeping the game rules intact.  
// Mutators are given the opportunity to modify player login parameters with 
// ModifyLogin(), to modify player pawn properties with ModifyPlayer(), to change 
// the default weapon for players with GetDefaultWeapon(), or to modify, remove, 
// or replace all other actors when they are spawned with CheckRelevance(), which 
// is called from the PreBeginPlay() function of all actors except those (Decals, 
// Effects and Projectiles for performance reasons) which have bGameRelevant==true.
//=============================================================================
class Mutator extends Info
	native;

var Mutator NextMutator;
var class<R6EngineWeapon> DefaultWeapon;
var string DefaultWeaponName;

/* Don't call Actor PreBeginPlay() for Mutator 
*/
event PreBeginPlay()
{
}

function ModifyLogin(out string Portal, out string Options)
{
	if ( NextMutator != None )
		NextMutator.ModifyLogin(Portal, Options);
}

/* called by GameInfo.RestartPlayer()
	change the players jumpz, etc. here
*/
function ModifyPlayer(Pawn Other)
{
	if ( NextMutator != None )
		NextMutator.ModifyPlayer(Other);
}

/* return what should replace the default weapon
   mutators further down the list override earlier mutators
*/
function Class<R6EngineWeapon> GetDefaultWeapon()
{
	local Class<R6EngineWeapon> W;

	if ( NextMutator != None )
	{
		W = NextMutator.GetDefaultWeapon();
		if ( W == None )
			W = MyDefaultWeapon();
	}
	else
		W = MyDefaultWeapon();
	return W;
}

/* GetInventoryClass()
return an inventory class - either the class specified by InventoryClassName, or a 
replacement.  Called when spawning initial inventory for player
*/
/*R6CHANGEWEAPONSYSTEM
function Class<Inventory> GetInventoryClass(string InventoryClassName)
{
	InventoryClassName = GetInventoryClassOverride(InventoryClassName);
	return class<Inventory>(DynamicLoadObject(InventoryClassName, class'Class'));
}
*/
/* GetInventoryClassOverride()
return the string passed in, or a replacement class name string.
*/
/*R6CHANGEWEAPONSYSTEM
function string GetInventoryClassOverride(string InventoryClassName)
{
	// here, in mutator subclass, change InventoryClassName if desired.  For example:
	// if ( InventoryClassName == "Weapons.DorkyDefaultWeapon"
	//		InventoryClassName = "ModWeapons.SuperDisintegrator"

	if ( NextMutator != None )
		return NextMutator.GetInventoryClassOverride(InventoryClassName);
	return InventoryClassName;
}
*/
function class<R6EngineWeapon> MyDefaultWeapon()
{
	if ( (DefaultWeapon == None) && (DefaultWeaponName != "") )
		DefaultWeapon = class<R6EngineWeapon>(DynamicLoadObject(DefaultWeaponName, class'Class'));

	return DefaultWeapon;
}

function AddMutator(Mutator M)
{
	if ( NextMutator == None )
		NextMutator = M;
	else
		NextMutator.AddMutator(M);
}

/* ReplaceWith()
Call this function to replace an actor Other with an actor of aClass.
*/
function bool ReplaceWith(actor Other, string aClassName)
{
	local Actor A;
	local class<Actor> aClass;

	if ( Other.IsA('Inventory') && (Other.Location == vect(0,0,0)) )
		return false;
	aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if ( aClass != None )
		A = Spawn(aClass,Other.Owner,Other.tag,Other.Location, Other.Rotation);
/*R6CHANGEWEAPONSYSTEM
	if ( Other.IsA('Pickup') )
	{
		if ( Pickup(Other).MyMarker != None )
		{
			Pickup(Other).MyMarker.markedItem = Pickup(A);
			if ( Pickup(A) != None )
			{
				Pickup(A).MyMarker = Pickup(Other).MyMarker;
				A.SetLocation(A.Location 
					+ (A.CollisionHeight - Other.CollisionHeight) * vect(0,0,1));
			}
			Pickup(Other).MyMarker = None;
		}
		else if ( A.IsA('Pickup') )
			Pickup(A).Respawntime = 0.0;
	}
*/
    if ( A != None )
	{
		A.event = Other.event;
		A.tag = Other.tag;
		return true;
	}
	return false;
}

/* Force game to always keep this actor, even if other mutators want to get rid of it
*/
function bool AlwaysKeep(Actor Other)
{
	if ( NextMutator != None )
		return ( NextMutator.AlwaysKeep(Other) );
	return false;
}

function bool IsRelevant(Actor Other, out byte bSuperRelevant)
{
	local bool bResult;

	bResult = CheckReplacement(Other, bSuperRelevant);
	if ( bResult && (NextMutator != None) )
		bResult = NextMutator.IsRelevant(Other, bSuperRelevant);

	return bResult;
}

function bool CheckRelevance(Actor Other)
{
	local bool bResult;
	local byte bSuperRelevant;

	if ( AlwaysKeep(Other) )
		return true;

	// allow mutators to remove actors

	bResult = IsRelevant(Other, bSuperRelevant);

	return bResult;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	return true;
}

//
// Called when a player sucessfully changes to a new class
//
function PlayerChangedClass(Controller aPlayer)
{
	NextMutator.PlayerChangedClass(aPlayer);
}

defaultproperties
{
}
