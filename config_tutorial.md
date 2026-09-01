# Hướng dẫn kết nối iPhone với xtool trên Windows + WSL

> **Mục tiêu:** Cho phép `xtool` chạy trong WSL sử dụng iPhone đang được Windows nhận qua Apple Mobile Device stack.
>
> **Kiến trúc đã dùng thành công:**
>
> ```text
> iPhone
>   │ USB
>   ▼
> Windows / Apple Mobile Device
>   │
>   │ TCP port 27015
>   ▼
> WSL
>   │
>   ▼
> libusbmuxd → libimobiledevice → xtool
> ```
>
> **Quan trọng:** Không để WSL tự claim iPhone bằng `usbipd attach`. Workaround này giữ iPhone ở phía Windows và cho WSL truy cập usbmuxd qua TCP.

---

## 1. Chuẩn bị iPhone trên Windows

Cắm iPhone vào Windows bằng USB.

Đảm bảo Windows/Apple Mobile Device nhận được iPhone và iPhone đã **Trust This Computer** nếu được hỏi.

Không cần attach iPhone vào WSL bằng `usbipd`.

---

## 2. Mở PowerShell với quyền Administrator

Tất cả lệnh Windows trong tài liệu này nên chạy trong **PowerShell Administrator**.

---

## 3. Cho phép TCP từ WSL qua Windows Firewall

Chạy:

```powershell
New-NetFirewallRule `
  -DisplayName "WSL usbmuxd" `
  -Direction Inbound `
  -InterfaceAlias "vEthernet (WSL (Hyper-V firewall))" `
  -Action Allow
```

Kiểm tra:

```powershell
Get-NetFirewallRule -DisplayName "WSL usbmuxd" -ErrorAction SilentlyContinue |
  Format-Table DisplayName,Enabled,Direction,Action
```

Nếu rule đã tồn tại thì không cần tạo lại.

---

## 4. Xác định IP Windows mà WSL sử dụng

Trong WSL:

```bash
ip route list default
```

Ví dụ:

```text
default via 172.20.128.1 dev eth0
```

Trong ví dụ này:

```text
Windows host IP = 172.20.128.1
```

**Không hard-code IP này cho mọi máy.** Mỗi WSL/Windows có thể có IP khác.

---

## 5. Tạo Windows portproxy cho usbmuxd

Trước tiên kiểm tra rule hiện tại:

```powershell
netsh interface portproxy show v4tov4
```

Nếu có rule cũ không đúng, xóa nó.

Ví dụ rule cũ:

```powershell
netsh interface portproxy delete v4tov4 `
  listenaddress=127.0.0.1 `
  listenport=27016
```

Sau đó tạo forwarding:

```powershell
netsh interface portproxy add v4tov4 `
  listenaddress=172.20.128.1 `
  listenport=27015 `
  connectaddress=127.0.0.1 `
  connectport=27015
```

Thay `172.20.128.1` bằng IP Windows thực tế lấy ở bước 4.

Kiểm tra:

```powershell
netsh interface portproxy show v4tov4
```

Kỳ vọng:

```text
Listen on ipv4:             Connect to ipv4:

Address         Port        Address         Port
172.20.128.1    27015       127.0.0.1      27015
```

Ý nghĩa:

```text
WSL
 │
 │ 172.20.128.1:27015
 ▼
Windows
 │
 │ 127.0.0.1:27015
 ▼
Apple usbmuxd
```

---

## 6. Kiểm tra Windows có endpoint usbmuxd

Trên PowerShell:

```powershell
Get-NetTCPConnection -State Listen |
  Where-Object {$_.LocalPort -eq 27015} |
  Format-Table LocalAddress,LocalPort,OwningProcess
```

Cần xác nhận Windows có dịch vụ/process cung cấp endpoint ở port `27015`.

Có thể xem process:

```powershell
Get-Process -Id <PID>
```

Thay `<PID>` bằng `OwningProcess` nhận được ở lệnh trên.

---

## 7. Kiểm tra WSL kết nối được tới Windows port 27015

Trong WSL:

```bash
nc -vz 172.20.128.1 27015
```

Kết quả thành công:

```text
Connection to 172.20.128.1 27015 port [tcp/*] succeeded!
```

Nếu bước này fail, chưa tiếp tục sang xtool. Kiểm tra lại:

- Windows host IP.
- `netsh interface portproxy`.
- Windows Firewall.
- Windows Apple Mobile Device stack.
- Port `27015`.

---

## 8. Cho libusbmuxd trong WSL sử dụng Windows usbmuxd

Trong WSL:

```bash
export USBMUXD_SOCKET_ADDRESS=172.20.128.1:27015
```

Thay IP bằng IP Windows thực tế.

Nếu sử dụng Visual Studio Code:

```bash
WINDOWS_HOST=$(ip route | awk '/default/ {print $3}')
export USBMUXD_SOCKET_ADDRESS="${WINDOWS_HOST}:27015"
```

Kiểm tra thiết bị:

```bash
idevice_id -l
```

Sau đó:

```bash
ideviceinfo -s
```

Có thể kiểm tra pairing:

```bash
idevicepair list
```

Ví dụ UDID:

```text
00008110-000919A62661401E
```

### Lưu ý

`idevice_id -l` mới là kiểm tra quan trọng cho việc device discovery.

Nếu:

```bash
idevicepair list
```

thấy UDID nhưng:

```bash
idevice_id -l
```

không thấy device, thì pairing information có tồn tại nhưng luồng usbmuxd/device discovery chưa hoạt động đúng.

---

## 9. Chạy xtool

Sau khi `idevice_id -l` nhìn thấy iPhone:

```bash
xtool devices --usb
```

Kỳ vọng:

```text
Bon [usb]: 00008110-000919A62661401E
```

Sau đó:

```bash
cd ~/projects/HelloWorld
xtool dev run --usb
```

Quá trình bình thường sẽ đi qua:

```text
Planning...
Building for debugging...
Build complete!

Waiting for device to be connected...
Installing to device: Bon
```

và tiếp tục qua:

```text
[Unpacking app] 100%
[Preparing device] 100%
[Provisioning] 100%
[Signing] 100%
[Packaging] 100%
[Connecting] 100%
[Installing] 100%
[Verifying] 100%
```

---

# Các lệnh kiểm tra nhanh

## Windows

```powershell
netsh interface portproxy show v4tov4
```

```powershell
Get-NetTCPConnection -State Listen |
  Where-Object {$_.LocalPort -eq 27015} |
  Format-Table LocalAddress,LocalPort,OwningProcess
```

```powershell
Get-NetFirewallRule -DisplayName "WSL usbmuxd" -ErrorAction SilentlyContinue |
  Format-Table DisplayName,Enabled,Direction,Action
```

## WSL

```bash
ip route list default
```

```bash
nc -vz 172.20.128.1 27015
```

```bash
export USBMUXD_SOCKET_ADDRESS=172.20.128.1:27015
```

```bash
idevice_id -l
```

```bash
idevicepair list
```

```bash
xtool devices --usb
```

---

# Những thứ KHÔNG làm trong workaround này

### Không attach iPhone vào WSL bằng:

```powershell
usbipd attach --wsl --busid <BUSID>
```

Đặc biệt không dùng:

```powershell
usbipd attach --wsl --busid <BUSID> --force
```

nếu mục tiêu là giữ Apple Mobile Device stack của Windows làm USB endpoint.

### Không chạy thêm một usbmuxd Linux để claim iPhone

Không cần:

```bash
sudo usbmuxd -f -v
```

với mục đích trực tiếp nhận USB iPhone trong WSL.

Trong mô hình này, WSL đóng vai trò **client của usbmuxd qua TCP**.

---

# Troubleshooting

## `nc` thành công nhưng `idevice_id -l` không có device

Kiểm tra:

```bash
echo "$USBMUXD_SOCKET_ADDRESS"
```

Phải là:

```text
172.20.128.1:27015
```

Sau đó:

```bash
ldd $(which idevice_id) | grep -E 'usbmux|imobile|plist|glue'
```

Đảm bảo đang sử dụng các thư viện tương thích với bản `libusbmuxd`/`libimobiledevice` đã build.

Có thể kiểm tra:

```bash
ldconfig -p | grep 'libusbmuxd-2.0'
```

và:

```bash
ldd /usr/local/lib/libimobiledevice-1.0.so.6 | grep usbmux
```

---

## `usbmuxd` Linux báo `0 devices detected`

Ví dụ:

```text
Initializing USB
Using libusb ...
0 devices detected
```

Điều này **không phải mục tiêu cần đạt** trong workaround này nếu iPhone vẫn nằm phía Windows.

Không chuyển sang `usbipd attach` chỉ vì dòng này xuất hiện.

---

## `usbipd list` báo Apple device `Shared`

Điều này không đồng nghĩa phải attach vào WSL.

Nếu đang theo workaround Windows + TCP:

```text
Windows giữ iPhone
        ↓
Windows Apple Mobile Device
        ↓
TCP 27015
        ↓
WSL libusbmuxd
```

hãy giữ kiến trúc này.

---

# Tóm tắt

Toàn bộ flow:

```text
1. iPhone cắm Windows
          ↓
2. Windows nhận iPhone
          ↓
3. Windows Firewall cho phép WSL
          ↓
4. Xác định Windows IP từ:
   ip route list default
          ↓
5. Windows portproxy:
   <Windows-IP>:27015
          ↓
   127.0.0.1:27015
          ↓
6. WSL:
   nc -vz <Windows-IP> 27015
          ↓
7. WSL:
   export USBMUXD_SOCKET_ADDRESS=<Windows-IP>:27015
          ↓
8. idevice_id -l
          ↓
9. xtool devices --usb
          ↓
10. xtool dev run --usb
```

**Nguyên tắc:** Windows giữ quyền truy cập USB iPhone; WSL chỉ truy cập usbmuxd qua TCP.
