{
  inputs,
  modulesPath,
  config,
  lib,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/proxmox-image.nix"
    inputs.determinate.nixosModules.default
    ../container/network.nix
  ];

  proxmox = {
    cloudInit.enable = false;
    qemuConf = {
      name = config.networking.hostName;
      cores = lib.mkDefault 4;
      memory = lib.mkDefault 8096;
      additionalSpace = lib.mkDefault "8G";
      net0 = lib.mkDefault "virtio,bridge=vmbr0";
    };
    qemuExtraConf = {
      ide2 = lib.mkForce "none,media=cdrom";
    }
    // lib.optionalAttrs config.pilz.networking.tor-relay.enable {
      net1 = "virtio,bridge=vmbr2";
    };
  };

  pilz = {
    shell.enable = true;
    services.ssh.enable = true;
    common.enable = true;
    monitoring.node-exporter.enable = true;
    monitoring.systemd-exporter.enable = true;
  };

  networking = {
    usePredictableInterfaceNames = false;
    useNetworkd = true;
    domain = "ams1.as214958.net";
    nameservers = lib.mkAfter [
      "2606:4700:4700::1111"
      "1.1.1.1"
      "2606:4700:4700::1001"
      "1.0.0.1"
    ];
  };

  boot.kernelParams = [
    "slab_nomerge"
    "page_poison=1"
    "page_alloc.shuffle=1"
    "debugfs=off"
  ];

  security = {
    protectKernelImage = lib.mkDefault true;
    auditd.enable = true;
    audit.enable = true;
    audit.rules = [
      "-a exit,always -F arch=b64 -S execve"
    ];

    sudo = {
      execWheelOnly = true;
      wheelNeedsPassword = false;
    };
  };
  boot.kernel.sysctl."kernel.kptr_restrict" = "2";

  # Disable bpf() JIT (to eliminate spray attacks)
  boot.kernel.sysctl."net.core.bpf_jit_enable" = false;

  # Disable ftrace debugging
  boot.kernel.sysctl."kernel.ftrace_enabled" = false;

  # Disable io_uring, a large source of security vulnerabilities
  # https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.html
  boot.kernel.sysctl."kernel.io_uring_disabled" = 2;

  # Enable strict reverse path filtering (that is, do not attempt to route
  # packets that "obviously" do not belong to the iface's network; dropped
  # packets are logged as martians).
  boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = "1";
  boot.kernel.sysctl."net.ipv4.conf.default.log_martians" = true;
  boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = "1";

  # Ignore broadcast ICMP (mitigate SMURF)
  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = true;

  # Ignore incoming ICMP redirects (note: default is needed to ensure that the
  # setting is applied to interfaces added after the sysctls are set)
  boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" = false;
  boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" = false;

  # Ignore outgoing ICMP redirects (this is ipv4 only)
  boot.kernel.sysctl."net.ipv4.conf.all.send_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.send_redirects" = false;

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];
}
