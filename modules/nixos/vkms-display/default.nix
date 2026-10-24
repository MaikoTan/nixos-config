# vkms: a virtual output so KWin always has something to render to.
#
# Why this exists
# ---------------
# KRDP and Sunshine both capture the desktop through KWin's screencast
# implementation (`zkde_screencast_unstable_v1`). That implementation needs
# KWin to have at least one *enabled* output, and KWin only has one when the
# DRM driver reports a connected connector. With the monitor unplugged the
# connector goes to `disconnected`, KWin ends up with zero outputs, and the
# screencast service has nothing to serve -- so both servers start, bind
# their port, and then never produce a stream.
#
# `krdpserver --virtual-monitor` does not help either: it asks KWin for a
# screencast virtual output, but that request is still served by the same
# screencast implementation, so it fails for the same reason.
#
# Why vkms rather than a fake EDID
# --------------------------------
# The alternative is to force the real connector on and feed it a synthetic
# EDID (drm.edid_firmware plus `echo on > .../status`). That works, but it
# needs three moving parts -- a kernel parameter, a sysfs write to bypass the
# DDC probe, and a patched EDID blob with the digital input bit set -- and it
# pins the real connector to a fixed resolution.
#
# vkms is a standalone virtual KMS driver: it registers its own DRM device
# with a `Virtual-1` connector that is always connected and offers the usual
# mode list. KWin picks it up like any other GPU, so from KWin's point of
# view this is simply "a monitor is attached". No kernel parameters, no sysfs
# writes, no EDID patching, and the real connector is left completely alone.
#
# Verified end to end on this machine: with vkms loaded, KWin reports
# `Virtual-1` at 1920x1080, and an RDP session produces the expected
# PipeWire graph -- a `Stream/Output/Video` node named
# `kwin-screencast-Virtual-1` from KWin, linked to krdpserver's
# `Stream/Input/Video` node -- with VAAPI hardware encoding initialised on
# the i915 render node.
#
# Why it is loaded unconditionally rather than on demand
# ------------------------------------------------------
# Unloading is not actually possible while KWin is running: the module's
# refcount stays above zero, so `modprobe -r vkms` fails with "module is in
# use". Toggling therefore has to happen at KWin's level, not the module's,
# and KWin already does the right thing on its own:
#
#   * monitor unplugged -- Virtual-1 is the only output, so it stays enabled
#     and remote desktop works with no intervention at all;
#   * monitor plugged in -- there are now two outputs, and KWin allows (and
#     remembers) disabling Virtual-1 from System Settings -> Displays, or
#     via `kscreen-doctor output.Virtual-1.disable`.
#
# Note that KWin refuses to disable the *last* remaining output
# ("Disabling all outputs through configuration changes is not allowed"), so
# the virtual display can never be switched off by accident while it is the
# only one.
#
# The module is tiny and idle when nothing renders to it, so leaving it
# loaded costs nothing.
{
  config,
  lib,
  ...
}:

let
  cfg = config.maiko.vkms-display;
in
{
  options.maiko.vkms-display = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Load the vkms virtual KMS driver so KWin always has an output, which
        is what makes KRDP and Sunshine usable when no monitor is attached.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Loaded at boot rather than on demand: KWin needs the device to exist
    # before it enumerates outputs, and (as described above) the module
    # cannot be unloaded again while KWin is running anyway.
    boot.kernelModules = [ "vkms" ];
  };
}
