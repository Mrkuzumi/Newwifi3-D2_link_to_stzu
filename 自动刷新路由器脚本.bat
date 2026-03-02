@echo off
chcp 65001 > nul
echo ==============================================
echo 正在连接路由器 192.168.1.1...
echo ==============================================

:: 使用plink执行SSH命令，-batch参数避免交互确认
plink.exe -ssh root@192.168.1.1 -pw password -batch ^
"echo 1 > /proc/sys/net/ipv4/ip_forward && ^
iptables -t nat -A POSTROUTING -o eth0.2 -j MASQUERADE && ^
iptables -t mangle -A POSTROUTING -o eth0.2 -j TTL --ttl-set 128 && ^
cat >> /etc/firewall.user << 'EOF' && ^
echo 1 > /proc/sys/net/ipv4/ip_forward && ^
iptables -t nat -A POSTROUTING -o eth0.2 -j MASQUERADE && ^
iptables -t mangle -A POSTROUTING -o eth0.2 -j TTL --ttl-set 128 && ^
EOF && ^
chmod +x /etc/firewall.user && ^
/etc/init.d/firewall restart"

:: 检查命令执行结果
if %errorlevel% equ 0 (
    echo.
    echo ==============================================
    echo 路由器配置执行成功！
    echo ==============================================
) else (
    echo.
    echo ==============================================
    echo 错误：路由器配置执行失败！
    echo 请检查：
    echo 1. 路由器IP是否为192.168.1.1
    echo 2. 用户名密码是否正确
    echo 3. 路由器是否开启SSH服务
    echo ==============================================
)

pause