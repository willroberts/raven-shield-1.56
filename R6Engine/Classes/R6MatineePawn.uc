//=============================================================================
//  R6MatineePawn.uc : This is a dumb actor class to add new object in a matinee scene
//			    without having to create a new class for each of them.
//  Copyright 2001 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//  2002/03/18	    Cyrille Lauzon: Creation
//=============================================================================
class R6MatineePawn extends R6Pawn
    placeable;
 
function PostBeginPlay()
{
	bPhysicsAnimUpdate = true;
	StopAnimating();
}

function Tick( FLOAT DeltaTime ) 
{}

defaultproperties
{
     DrawType=DT_Sprite
     m_bAllowLOD=False
     bActorShadows=True
     bObsolete=True
     Begin Object Class=KarmaParamsSkel Name=KarmaParamsSkel25
         KConvulseSpacing=(Max=2.200000)
         KSkeleton="terroskel"
         KStartEnabled=True
         bHighDetailOnly=False
         KLinearDamping=0.500000
         KAngularDamping=0.500000
         KBuoyancy=1.000000
         KVelDropBelowThreshold=50.000000
         KFriction=0.600000
         KRestitution=0.300000
         KImpactThreshold=150.000000
         Name="KarmaParamsSkel25"
     End Object
     KParams=KarmaParamsSkel'R6Engine.KarmaParamsSkel25'
}
