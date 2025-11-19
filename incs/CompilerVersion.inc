{$IFDEF VER200}
  // Delphi 2009's ErrorInsight parser uses the CompilerVersion's memory address instead of 20.0, failing all the
  // IF CompilerVersion compiler directives
  {$DEFINE CPUX86}
{$ELSE}
  {$IF CompilerVersion >= 24.0} // XE3 and newer
    {$LEGACYIFEND ON}
  {$IFEND}
  {$IF CompilerVersion >= 23.0}
    {$DEFINE HAS_UNIT_SCOPE}
    {$DEFINE HAS_RETURN_ADDRESS}
  {$IFEND}
  {$IF CompilerVersion <= 22.0} // XE and older
    {$DEFINE CPUX86}
  {$IFEND}
{$ENDIF VER200}