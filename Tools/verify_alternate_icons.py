#!/usr/bin/env python3
"""
Verifies that every alternate-icon file declared in Info.plist's CFBundleAlternateIcons actually
exists in the app bundle. Run twice in the build workflow: once right after
apply_alternate_icons.py, and again after ipapatch's sideload-signing pass — if the second run
ever fails while the first passes, that proves ipapatch's own repackaging is what's dropping the
files, which is the concrete lead to chase next (see the workflow file for the full reasoning).

This exists because "Info.plist declares a file, but the file isn't actually in the bundle" is
exactly the failure a real device hit: setAlternateIconName failed with
NSCocoaErrorDomain code=4 ("The file doesn't exist"). Catching the mismatch here means a clear CI
failure instead of a cryptic runtime failure discovered days later.

Usage: verify_alternate_icons.py <path-to-app-bundle>
"""
import plistlib
import sys
from pathlib import Path


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <path-to-app-bundle>", file=sys.stderr)
        sys.exit(1)

    app_dir = Path(sys.argv[1])
    info_plist_path = app_dir / "Info.plist"
    if not info_plist_path.is_file():
        print(f"::error::Info.plist not found at {info_plist_path}", file=sys.stderr)
        sys.exit(1)

    with open(info_plist_path, "rb") as f:
        info = plistlib.load(f)

    missing = []
    checked = 0
    # iPad's max scale factor is 2x (no @3x devices exist), so its icon files only ever have an
    # @2x variant — requiring @3x for those would falsely flag correctly-generated iPad icons as
    # missing. iPhone icons need both.
    required_suffixes = {
        "CFBundleIcons": ("@2x.png", "@3x.png"),
        "CFBundleIcons~ipad": ("@2x.png",),
    }
    for key, suffixes in required_suffixes.items():
        alternates = (info.get(key) or {}).get("CFBundleAlternateIcons") or {}
        for icon_name, icon_info in alternates.items():
            for base_name in icon_info.get("CFBundleIconFiles", []):
                # Check the specific scale-suffixed files apply_alternate_icons.py actually wrote,
                # not just "does *a* scale variant exist" — a loose glob match here would silently
                # accept a bundle missing one variant as long as another survived, which is
                # exactly the kind of partial file loss this script exists to catch.
                for suffix in suffixes:
                    checked += 1
                    if not (app_dir / f"{base_name}{suffix}").is_file():
                        missing.append(f"{key}/{icon_name}: {base_name}{suffix} not found")

    if missing:
        print("::error::Icon files declared in Info.plist are missing from the app bundle:", file=sys.stderr)
        for m in missing:
            print(f"::error::  {m}", file=sys.stderr)
        sys.exit(1)

    print(f"Verified {checked} declared alternate icon file(s) are present in the app bundle.")


if __name__ == "__main__":
    main()
