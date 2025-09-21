#!/usr/bin/env python3
import argparse
import subprocess
import os
import sys

def run_cmd(cmd, check=True, background=False):
    print(f"[RUN] {cmd}")
    if background:
        # use Popen for background tasks
        subprocess.Popen(cmd, shell=True)
    else:
        subprocess.run(cmd, shell=True, check=check)

def run_host(vm_user, chrome=False):
    # ssh socks5 转发，连接到本机的 vm 用户（通常是 vm 侧的用户帐号）
    run_cmd(f'ssh -X -p 3222 -D 1080 -o "ServerAliveInterval 60" -f -N {vm_user}@localhost')

    os.environ["http_proxy"] = "socks5://127.0.0.1:1080"
    os.environ["https_proxy"] = "socks5://127.0.0.1:1080"

    run_cmd('curl --socks5 127.0.0.1:1080 http://ifconfig.me', check=False)

    if chrome:
        run_cmd("pkill -9 chrome || true", check=False)
        run_cmd("cat ~/.ssh/config", check=False)
        run_cmd('google-chrome --proxy-server="socks5://127.0.0.1:1080"', background=True)

def run_vm(host_user, host_ip_p, host_ip_post, vm_ip, remote_ip, net_interface):
    run_cmd(f"sudo ip route add {host_ip_p}.0/24 via {vm_ip} dev {net_interface}",check=False)

    run_cmd(
        f"ssh -NT "
        f"-R 3222:localhost:22 "
        f"-R 1446:{remote_ip}:445 "
        f"-R 2222:{remote_ip}:22 "
        f"-o ServerAliveInterval=6 -o ServerAliveCountMax=3 "
        f"{host_user}@{host_ip_p}.{host_ip_post}"
    )

def main():
    parser = argparse.ArgumentParser(description="Network forward script in Python")
    subparsers = parser.add_subparsers(dest="mode", required=True)

    host_parser = subparsers.add_parser("host", help="Run host side logic")
    host_parser.add_argument("--vm_user_name", required=True,
                             help="VM-side username to connect as from host (originally zhlvm)")
    host_parser.add_argument("--chrome", action="store_true",
                             help="If present, kill chrome and start google-chrome with socks5 proxy")

    vm_parser = subparsers.add_parser("vm", help="Run VM side logic")
    vm_parser.add_argument("--host_user_name", required=True,
                           help="Host-side username to connect to (originally zhl)")
    vm_parser.add_argument("--HOST_IP_P", required=True, help="Host IP prefix (e.g. 192.168.0)")
    vm_parser.add_argument("--HOST_IP_POST", required=True, help="Host IP suffix (e.g. 27)")
    vm_parser.add_argument("--VM_IP", required=True, help="VM IP (e.g. 10.0.2.2)")
    vm_parser.add_argument("--REMOTE_IP", required=True, help="Remote IP to forward ssh and smb")
    vm_parser.add_argument("--NET_INTERFACE", required=True, help="VM network interface (e.g. enp1s0)")

    args = parser.parse_args()

    if args.mode == "host":
        run_host(vm_user=args.vm_user_name, chrome=args.chrome)
    elif args.mode == "vm":
        run_vm(
            host_user=args.host_user_name,
            host_ip_p=args.HOST_IP_P,
            host_ip_post=args.HOST_IP_POST,
            vm_ip=args.VM_IP,
            remote_ip=args.REMOTE_IP,
            net_interface=args.NET_INTERFACE,
        )

if __name__ == "__main__":
    main()
