//============================================================================//
//  AssaultM14.uc
//  Copyright 2001 Ubi Soft, Inc. All Rights Reserved.
//============================================================================//


Class AssaultM14 extends R6AssaultRifle
    Abstract;

#exec OBJ LOAD FILE="..\StaticMeshes\R63rdWeapons_SM.usx"  Package="R63rdWeapons_SM"

defaultproperties
{
     m_pBulletClass=Class'R6Weapons.ammo762mmNATO'
     m_pEmptyShells=Class'R6SFX.R6Shell762mmNATO'
     m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash762mm'
     m_stWeaponCaps=(bSingle=1,bFullAuto=1,bCMag=1,bSilencer=1,bLight=1,bMiniScope=1)
     m_pFPHandsClass=Class'R61stWeapons.R61stHandsAssaultM14'
     m_pFPWeaponClass=Class'R61stWeapons.R61stAssaultM14'
     m_HUDTexture=Texture'R6HUD.HUDElements'
     m_vPositionOffset=(X=5.500000,Y=-0.500000,Z=-1.000000)
     m_HUDTexturePos=(W=32.000000,Y=32.000000,Z=100.000000)
     m_NameID="AssaultM14"
     StaticMesh=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdM14'
}
