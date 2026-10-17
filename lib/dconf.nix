{ lib }:

let
  locksForSettings = settings:
    lib.flatten (
      lib.mapAttrsToList
        (path: values:
          map (key: "/${path}/${key}") (builtins.attrNames values))
        settings
    );

  mkLockedDatabase = settings: {
    inherit settings;
    locks = locksForSettings settings;
  };
in
{
  inherit mkLockedDatabase;

  mkLockedDatabases = settings: [
    (mkLockedDatabase settings)
  ];
}
