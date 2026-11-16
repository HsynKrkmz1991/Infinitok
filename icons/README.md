# Alternate app icons

Each subfolder here is one selectable icon in Settings → App Icon. The folder name is what's
shown in the picker (underscores become spaces, e.g. `Infinitok_Dark` → "Infinitok Dark").

Each folder must contain exactly:

```
AppIcon60x60@2x.png   (120x120 px)
AppIcon60x60@3x.png   (180x180 px)
```

No code changes are needed on either side to add a new icon — `Tools/apply_alternate_icons.py`
(run automatically by the build workflow) wires up Info.plist for whatever folders exist here,
and `Settings/AppIconViewController.m` reads those same Info.plist keys back out at runtime.
Drop a new folder in, push, and it shows up in the next build.

iPad needs its own icon sizes (152x152, 167x167) — these are generated automatically by
upscaling the @3x file, so you don't need to provide them yourself.

`Infinitok_Dark/` is a plain placeholder (two outlined circles on a dark square) — a working
example for the picker plumbing, not real artwork. Replace it or add more alongside it with your
own designs.

A folder that's missing either required file is skipped (logged in the build output), not
treated as a build failure.
