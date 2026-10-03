# schlop schlop schlop
{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.services.haos-vm;
  version = "18.3";
  image = pkgs.fetchurl {
    url = "https://github.com/home-assistant/operating-system/releases/download/${version}/haos_generic-aarch64-${version}.qcow2.xz";
    hash = "sha256-9UtlnxLGZQOBNL351CNZAwSAViVzaPgjadwjATH1pnU=";
  };
  tap = "haos0";
  disk = "/var/lib/haos-vm/haos.qcow2";
  monitor = "/run/haos-vm/monitor.sock";
in
{
  options.pilz.services.haos-vm = {
    enable = lib.mkEnableOption "Home Assistant OS in a QEMU/KVM VM";
    cores = lib.mkOption {
      type = lib.types.ints.positive;
      default = 2;
    };
    memory = lib.mkOption {
      type = lib.types.ints.positive;
      default = 4096;
      description = "RAM in MiB";
    };
    diskSize = lib.mkOption {
      type = lib.types.str;
      default = "64G";
      description = "only applied when the disk is first created";
    };
    interface = lib.mkOption {
      type = lib.types.str;
      default = "end0";
      description = "host interface the macvtap is attached to";
    };
    macAddress = lib.mkOption {
      type = lib.types.str;
      default = "52:54:00:48:41:01";
    };
  };
  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "macvtap" ];

    # the host must not grab a lease on the VM's interface
    networking.dhcpcd.denyInterfaces = [ tap ];

    systemd.services.haos-vm = {
      description = "Home Assistant OS VM";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = with pkgs; [
        qemu_kvm
        iproute2
        xz
        socat
        coreutils
      ];
      preStart = ''
        # the image is only seeded once, HAOS updates itself afterwards
        if [ ! -e ${disk} ]; then
          xz -dc ${image} > ${disk}.tmp
          qemu-img resize ${disk}.tmp ${cfg.diskSize}
          mv ${disk}.tmp ${disk}
        fi

        ip link del ${tap} 2>/dev/null || true
        ip link add link ${cfg.interface} name ${tap} address ${cfg.macAddress} type macvtap mode bridge
        # the host shares the MAC with the guest, so it must not autoconfigure v6 on it
        echo 1 > /proc/sys/net/ipv6/conf/${tap}/disable_ipv6
        ip link set ${tap} up
      '';
      script = ''
        tapdev=/dev/tap$(< /sys/class/net/${tap}/ifindex)
        # udev creates the device node asynchronously
        for _ in $(seq 50); do [ -e "$tapdev" ] && break; sleep 0.1; done

        # the Xavier only has a GICv2, the kernel has no VHOST_NET
        exec qemu-system-aarch64 \
          -name haos \
          -machine virt,gic-version=host \
          -enable-kvm -cpu host \
          -smp ${toString cfg.cores} -m ${toString cfg.memory} \
          -bios ${pkgs.qemu_kvm}/share/qemu/edk2-aarch64-code.fd \
          -drive if=none,id=hd0,file=${disk},format=qcow2,discard=unmap \
          -device virtio-blk-pci,drive=hd0 \
          -netdev tap,id=net0,fd=3,vhost=off \
          -device virtio-net-pci,netdev=net0,mac=${cfg.macAddress} \
          -device virtio-rng-pci \
          -display none \
          -serial unix:/run/haos-vm/console.sock,server=on,wait=off \
          -monitor unix:${monitor},server=on,wait=off \
          3<>"$tapdev"
      '';
      # ask the guest to power off and wait for qemu to exit before systemd kills it
      preStop = ''
        echo system_powerdown | socat - UNIX-CONNECT:${monitor} || true
        timeout 110 tail --pid="$MAINPID" -f /dev/null || true
      '';
      postStop = ''
        ip link del ${tap} 2>/dev/null || true
      '';
      serviceConfig = {
        StateDirectory = "haos-vm";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "haos-vm";
        RuntimeDirectoryMode = "0700";
        TimeoutStartSec = 600;
        TimeoutStopSec = 120;
        Restart = "on-failure";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };
  };
}
