{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10046: kpSConst.pas 
{
{   Rev 1.0    10/15/2002 8:15:16 PM  Supervisor
}
{
{   Rev 1.0    9/3/2002 8:16:50 PM  Supervisor
}
{ Secrets of Delphi 2, by Ray Lischner. (1996, Waite Group Press).
  Chapter 2: Components and Properties.
  Copyright © 1996 The Waite Group, Inc. }

{ String table IDs for the Delphi string loader.
  Errors in the string loader must use traditional
  string table resources. If there is a resource ID
  conflict with any of these string resources,
  then change the IDs here and in S_Consts.res. }

unit kpSConst;

interface

{ These values do not conflict with the standard Delphi
  string IDs, but might conflict with a third-party package. }
const
  S_NoSuchResource	= 4290;
  S_CannotLoadResource	= 4288;
  S_CannotLockResource	= 4289;

implementation
{$R kpSConst.res}
end.
