# AI slopping box VM
{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.services.ai-slop-vm;
  image = pkgs.fetchurl {
    url = "https://cloud.debian.org/images/cloud/bookworm/20261018-2635/debian-12-generic-arm64-20261018-2635.qcow2";
    hash = "sha256-lKoZWk5kd9oErZwCUJB0HYD3ti4Dh1+2rwOhk/p1kY8=";
  };
  tap = "slop0";
  disk = "/var/lib/ai-slop-vm/disk.qcow2";
  monitor = "/run/ai-slop-vm/monitor.sock";

  userData = pkgs.writeText "user-data" ''
        #cloud-config
        hostname: ${cfg.hostname}
        fqdn: ${cfg.hostname}.local
        manage_etc_hosts: true

        users:
          - name: debian
            gecos: AI Slopper
            sudo: ALL=(ALL) NOPASSWD:ALL
            shell: /bin/bash
            lock_passwd: true
            ssh_authorized_keys:
    ${lib.concatMapStringsSep "\n" (k: "          - " + k) cfg.sshKeys}
          - name: marie
            gecos: Marie
            sudo: ALL=(ALL) NOPASSWD:ALL
            shell: /bin/bash
            lock_passwd: true
            ssh_authorized_keys:
    ${lib.concatMapStringsSep "\n" (k: "          - " + k) cfg.sshKeys}
          - name: root
            lock_passwd: true
            ssh_authorized_keys:
    ${lib.concatMapStringsSep "\n" (k: "          - " + k) cfg.sshKeys}

        package_update: true
        packages:
          - curl
          - wget
          - git
          - tmux
          - build-essential
          - ca-certificates
          - gnupg
          - jq
          - python3
          - python3-pip
          - python3-venv
          - ripgrep
          - htop
          - socat

        write_files:
          - path: /etc/profile.d/00-slop-aliases.sh
            permissions: '0644'
            content: |
              # AI Slopping aliases with dangerously skip permissions
              alias claude="claude --dangerously-skip-permissions"
              alias agy="agy --dangerously-skip-permissions"
              alias antigravity="agy --dangerously-skip-permissions"
              alias codex="codex --dangerously-bypass-approvals-and-sandbox"
              alias slop="tmux attach -t slop"
              export PATH="/usr/local/bin:$PATH"

          - path: /etc/bash.bashrc
            append: true
            content: |
              alias claude="claude --dangerously-skip-permissions"
              alias agy="agy --dangerously-skip-permissions"
              alias antigravity="agy --dangerously-skip-permissions"
              alias codex="codex --dangerously-bypass-approvals-and-sandbox"
              alias slop="tmux attach -t slop"

          - path: /etc/skel/.codex/config.toml
            permissions: '0644'
            content: |
              approval_policy = "never"
              sandbox_mode = "danger-full-access"

          - path: /home/debian/.codex/config.toml
            owner: debian:debian
            permissions: '0644'
            content: |
              approval_policy = "never"
              sandbox_mode = "danger-full-access"

          - path: /root/.codex/config.toml
            owner: root:root
            permissions: '0644'
            content: |
              approval_policy = "never"
              sandbox_mode = "danger-full-access"

          - path: /usr/local/bin/slop
            permissions: '0755'
            content: |
              #!/usr/bin/env bash
              exec tmux attach-session -t slop "$@"

          - path: /usr/local/bin/start-ai-slop
            permissions: '0755'
            content: |
              #!/usr/bin/env bash
              set -e

              # Wait until AI binaries are available
              for bin in claude agy codex; do
                while ! command -v "$bin" >/dev/null 2>&1; do
                  echo "Waiting for $bin..."
                  sleep 2
                done
              done

              mkdir -p /home/debian/workspace
              if [ ! -d /home/debian/workspace/.git ]; then
                git -C /home/debian/workspace init -b main
                git -C /home/debian/workspace config user.name "AI Slopper"
                git -C /home/debian/workspace config user.email "slop@local"
              fi
              chown -R debian:debian /home/debian/workspace

              if tmux has-session -t slop 2>/dev/null; then
                exit 0
              fi

              cd /home/debian/workspace
              tmux new-session -d -s slop -n claude "claude --dangerously-skip-permissions; exec bash"
              tmux new-window -t slop:1 -n antigravity "agy --dangerously-skip-permissions; exec bash"
              tmux new-window -t slop:2 -n codex "codex --dangerously-bypass-approvals-and-sandbox; exec bash"
              tmux select-window -t slop:0

          - path: /etc/systemd/system/ai-slopping.service
            permissions: '0644'
            content: |
              [Unit]
              Description=AI Slopping Autostart Session
              After=network-online.target
              Wants=network-online.target

              [Service]
              Type=forking
              User=debian
              WorkingDirectory=/home/debian/workspace
              Environment=HOME=/home/debian
              Environment=PATH=/usr/local/bin:/usr/bin:/bin:/home/debian/.local/bin
              ExecStart=/usr/local/bin/start-ai-slop
              ExecStop=/usr/bin/tmux kill-session -t slop
              Restart=always
              RestartSec=5

              [Install]
              WantedBy=multi-user.target

          - path: /etc/motd
            content: |
              =====================================================
              🚀 Welcome to AI Slopping Box (Debian 12 arm64)
              =====================================================
              Autostarted tmux session 'slop' is running with:
                • Window 0: claude      (--dangerously-skip-permissions)
                • Window 1: antigravity (--dangerously-skip-permissions)
                • Window 2: codex       (--dangerously-bypass-approvals-and-sandbox)

              Attach to session:
                tmux attach -t slop  (or just type: slop)

              Interactive commands with skip-permissions pre-applied:
                claude, antigravity, agy, codex
              =====================================================

        runcmd:
          - echo "Setting up Node.js 22 LTS repository..."
          - curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
          - apt-get install -y nodejs
          - echo "Installing Claude Code CLI..."
          - npm install -g @anthropic-ai/claude-code
          - echo "Installing OpenAI Codex CLI..."
          - npm install -g @openai/codex
          - echo "Installing Antigravity CLI..."
          - curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir /usr/local/bin
          - ln -sf /usr/local/bin/agy /usr/local/bin/antigravity
          - chmod +x /usr/local/bin/agy /usr/local/bin/antigravity
          - mkdir -p /home/debian/workspace
          - chown -R debian:debian /home/debian
          - systemctl daemon-reload
          - systemctl enable --now ai-slopping.service
          - echo "AI Slopping setup complete!" > /var/lib/ai-slop-ready
  '';

  metaData = pkgs.writeText "meta-data" ''
    instance-id: ${cfg.hostname}-01
    local-hostname: ${cfg.hostname}
  '';

  cidata =
    pkgs.runCommand "cidata.iso"
      {
        nativeBuildInputs = [ pkgs.cloud-utils ];
      }
      ''
        cloud-localds -f iso9660 $out ${userData} ${metaData}
      '';
in
{
  options.pilz.services.ai-slop-vm = {
    enable = lib.mkEnableOption "Debian AI Slopping VM with Antigravity, Claude, and Codex";
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "slopbox";
    };
    cores = lib.mkOption {
      type = lib.types.ints.positive;
      default = 4;
    };
    memory = lib.mkOption {
      type = lib.types.ints.positive;
      default = 8192;
      description = "RAM in MiB";
    };
    diskSize = lib.mkOption {
      type = lib.types.str;
      default = "32G";
      description = "only applied when the disk is first created";
    };
    interface = lib.mkOption {
      type = lib.types.str;
      default = "end0";
      description = "host interface the macvtap is attached to";
    };
    macAddress = lib.mkOption {
      type = lib.types.str;
      default = "52:54:00:a1:51:01";
    };
    sshKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBTGgUYUsIAtcbZBqk5Mq0LH2T5KGFjdjAgNIwUf+/LBAAAABHNzaDo= pilz@framewok"
        "ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBAGgIgZKjLpJFdYK1+Ovd1IHQZhdCy2ZIz1Sf8qVGErkNVPkYOU3iJRoK2pJKrotZTo/2oTaSTzxewXKKJQ98toAAAAEc3NoOg== pilz@token2"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1mECV9Etr/nLIgg1E2mpFvAW1RexhhsRKrF7XcDEZI marie@framwok"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExU28oRh+stgLtfgqUejL601PPV8OKqoVni9W6dna9a"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/+iN407+HsfHbbC3tfdA8Yf4TZ08qXQMb4tb/SDAs+"
      ];
    };
    extraQemuArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "macvtap" ];

    # the host must not grab a lease on the VM's interface
    networking.dhcpcd.denyInterfaces = [ tap ];

    systemd.services.ai-slop-vm = {
      description = "Debian AI Slopping Box VM";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = with pkgs; [
        qemu_kvm
        iproute2
        socat
        coreutils
      ];
      preStart = ''
        if [ ! -e ${disk} ]; then
          cp --sparse=always ${image} ${disk}.tmp
          chmod 0600 ${disk}.tmp
          qemu-img resize ${disk}.tmp ${cfg.diskSize}
          mv ${disk}.tmp ${disk}
        fi

        ip link del ${tap} 2>/dev/null || true
        ip link add link ${cfg.interface} name ${tap} address ${cfg.macAddress} type macvtap mode bridge
        echo 1 > /proc/sys/net/ipv6/conf/${tap}/disable_ipv6
        ip link set ${tap} up
      '';
      script = ''
        tapdev=/dev/tap$(< /sys/class/net/${tap}/ifindex)
        # udev creates the device node asynchronously
        for _ in $(seq 50); do [ -e "$tapdev" ] && break; sleep 0.1; done

        # the Xavier only has a GICv2, the kernel has no VHOST_NET
        exec qemu-system-aarch64 \
          -name ${cfg.hostname} \
          -machine virt,gic-version=host \
          -enable-kvm -cpu host \
          -smp ${toString cfg.cores} -m ${toString cfg.memory} \
          -bios ${pkgs.qemu_kvm}/share/qemu/edk2-aarch64-code.fd \
          -drive if=none,id=hd0,file=${disk},format=qcow2,discard=unmap \
          -device virtio-blk-pci,drive=hd0 \
          -drive if=none,id=cidata,file=${cidata},format=raw,readonly=on \
          -device virtio-blk-pci,drive=cidata \
          -netdev tap,id=net0,fd=3,vhost=off \
          -device virtio-net-pci,netdev=net0,mac=${cfg.macAddress} \
          -device virtio-rng-pci \
          -display none \
          -serial unix:/run/ai-slop-vm/console.sock,server=on,wait=off \
          -monitor unix:${monitor},server=on,wait=off \
          ${lib.escapeShellArgs cfg.extraQemuArgs} \
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
        StateDirectory = "ai-slop-vm";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "ai-slop-vm";
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
