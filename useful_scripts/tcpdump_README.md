`tcpdump` 是一個強大的網路封包分析工具，它允許您捕獲和分析通過網路介面的流量。以下是一些 `tcpdump` 的常見用法：

**1. 基本用法：**

* **捕獲所有流量：**
    * `tcpdump`
    * 這個命令會捕獲所有通過預設網路介面的流量，並在終端機上顯示。
* **指定網路介面：**
    * `tcpdump -i <介面名稱>`
    * 例如：`tcpdump -i eth0`（捕獲 eth0 介面的流量）
    * `tcpdump -i any` (捕獲所有介面的流量)
* **將捕獲的流量儲存到檔案：**
    * `tcpdump -w <檔案名稱>.pcap`
    * 例如：`tcpdump -w capture.pcap`（將捕獲的流量儲存到 capture.pcap 檔案）
* **從檔案讀取捕獲的流量：**
    * `tcpdump -r <檔案名稱>.pcap`
    * 例如：`tcpdump -r capture.pcap`（從 capture.pcap 檔案讀取流量）

**2. 過濾流量：**

* **過濾主機：**
    * `tcpdump host <主機名稱或IP地址>`
    * 例如：`tcpdump host 192.168.1.100`（捕獲與 192.168.1.100 相關的流量）
* **過濾埠：**
    * `tcpdump port <埠號>`
    * 例如：`tcpdump port 80`（捕獲 80 埠的流量）
* **過濾協定：**
    * `tcpdump proto <協定名稱>`
    * 例如：`tcpdump proto tcp`（捕獲 TCP 流量）
    * 例如：`tcpdump proto udp` (捕獲 UDP 流量)
* **組合過濾條件：**
    * `tcpdump host <主機> and port <埠號>`
    * `tcpdump host <主機> or port <埠號>`
    * `tcpdump not port <埠號>`
    * 例如：`tcpdump host 192.168.1.100 and port 80`（捕獲與 192.168.1.100 相關的 80 埠流量）

**3. 進階選項：**

* **顯示詳細資訊：**
    * `tcpdump -v`（顯示更詳細的輸出）
    * `tcpdump -vv`（顯示非常詳細的輸出）
    * `tcpdump -vvv` (顯示極度詳細的輸出)
* **顯示 ASCII 碼：**
    * `tcpdump -A`（以 ASCII 碼顯示封包內容）
* **顯示十六進位碼：**
    * `tcpdump -x`（以十六進位碼顯示封包內容）
    * `tcpdump -X` (以十六進位與ASCII碼顯示封包內容)
* **顯示 TCP 序號：**
    * `tcpdump -S`（顯示絕對 TCP 序號）
* **設定封包長度：**
    * `tcpdump -s <長度>`（設定捕獲的封包長度）
    * 例如：`tcpdump -s 1500`
* **顯示時間戳記：**
    * `tcpdump -tttt` (顯示可讀時間戳記)

**4. 常見範例：**

* **捕獲與特定主機的 SSH 流量：**
    * `tcpdump host <主機IP> and port 22`
* **捕獲特定網路介面的 HTTP 流量：**
    * `tcpdump -i eth0 port 80`
* **捕獲並儲存特定子網路的流量：**
    * `tcpdump net 192.168.1.0/24 -w subnet_capture.pcap`
* **讀取並分析捕獲的流量檔案：**
    * `tcpdump -r capture.pcap`

**重要注意事項：**

* 使用 `tcpdump` 需要 root 權限。
* 捕獲大量流量可能會產生龐大的輸出。
* 在生產環境中使用 `tcpdump` 時，請務必小心，以免影響網路效能。
* 善用過濾條件，才能在龐大的封包流量中，找到您所需要的資訊。
