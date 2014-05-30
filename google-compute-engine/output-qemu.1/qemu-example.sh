set -x
qemu-system-x86_64 -m 1024m -name ubuntu-12.04.4-server-amd64 -netdev user,id=user.0 -device virtio-net,netdev=user.0 -drive file=disk.raw,if=virtio -vnc 0.0.0.0:44 -machine type=pc-1.0,accel=kvm -display none -boot once=d -redir tcp:3224::22
