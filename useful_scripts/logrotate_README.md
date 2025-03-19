好的，以下是如何使用 `logrotate` 的詳細說明，以 Markdown 格式輸出：

# `logrotate` 使用說明

`logrotate` 是一個 Linux/Unix 系統中用於管理日誌檔案的工具，它可以自動化日誌檔案的輪替、壓縮、刪除等操作，有效管理日誌檔案，避免日誌檔案過大占用過多磁碟空間。

## 1. 安裝與設定

* 大多數 Linux 發行版都預設安裝了 `logrotate`。您可以使用以下命令檢查是否已安裝：

    ```bash
    which logrotate
    ```

* `logrotate` 的主要設定檔為 `/etc/logrotate.conf`，其中包含全域設定和預設的日誌輪替規則。
* 通常，您不需要直接修改 `/etc/logrotate.conf`，而是將個別應用程式的日誌輪替規則放在 `/etc/logrotate.d/` 目錄下。

## 2. 設定檔語法

* `logrotate` 的設定檔使用類似於 shell script 的語法，每個設定區塊用於定義一個或多個日誌檔案的輪替規則。
* 以下是一些常用的設定選項：
    * `daily`, `weekly`, `monthly`, `yearly`: 設定輪替週期。
    * `rotate <count>`: 設定保留的日誌檔案數量。
    * `size <size>`: 設定日誌檔案大小達到指定值時進行輪替。
    * `compress`: 壓縮輪替後的日誌檔案。
    * `delaycompress`: 延遲壓縮，在下次輪替時才壓縮。
    * `missingok`: 如果日誌檔案不存在，則忽略錯誤。
    * `notifempty`: 如果日誌檔案為空，則不進行輪替。
    * `create <mode> <owner> <group>`: 輪替後建立新的日誌檔案，並設定權限、擁有者和群組。
    * `dateext`: 使用日期作為輪替後日誌檔案的副檔名。
    * `maxage <count>`: 設定日誌檔案的最大保留天數。
    * `olddir <directory>`: 將輪替後的日誌檔案移動到指定目錄。
    * `postrotate`/`endscript`: 在輪替後執行的 shell script。
    * `prerotate`/`endscript`: 在輪替前執行的 shell script。

## 3. 設定範例

* **每天輪替 `/var/log/myapp.log`，保留 7 個日誌檔案，並壓縮：**

    在 `/etc/logrotate.d/` 目錄下建立一個名為 `myapp` 的設定檔，內容如下：

    ```
    /var/log/myapp.log {
        daily
        rotate 7
        compress
        missingok
        notifempty
    }
    ```

* **每月輪替 `/var/log/nginx/*.log`，保留 12 個日誌檔案，使用日期作為副檔名：**

    在 `/etc/logrotate.d/` 目錄下建立一個名為 `nginx` 的設定檔，內容如下：

    ```
    /var/log/nginx/*.log {
        monthly
        rotate 12
        dateext
        missingok
        notifempty
    }
    ```

* **輪替 `/var/log/database.log`，當檔案大小超過 10MB 時輪替，輪替後重新啟動資料庫服務：**

    在 `/etc/logrotate.d/` 目錄下建立一個名為 `database` 的設定檔，內容如下：

    ```
    /var/log/database.log {
        size 10M
        rotate 4
        missingok
        notifempty
        postrotate
            systemctl restart database
        endscript
    }
    ```

## 4. 執行 `logrotate`

* `logrotate` 通常由 cron 定期執行，預設設定在 `/etc/cron.daily/logrotate`。
* 您可以手動執行 `logrotate` 來測試設定：

    ```bash
    logrotate -v /etc/logrotate.conf
    ```

    * `-v` 選項用於顯示詳細輸出。

* 您可以使用 `-f` 選項強制執行輪替，即使不符合輪替條件：

    ```bash
    logrotate -f /etc/logrotate.conf
    ```

## 5. 常見問題

* **日誌檔案沒有輪替：**
    * 檢查 `/etc/logrotate.conf` 和 `/etc/logrotate.d/` 下的設定檔是否正確。
    * 檢查 cron 是否正常執行 `logrotate`。
    * 檢查日誌檔案的權限和擁有者是否正確。
* **輪替後的日誌檔案權限不正確：**
    * 使用 `create` 選項設定正確的權限、擁有者和群組。
* **輪替後的日誌檔案沒有壓縮：**
    * 檢查是否設定了 `compress` 選項。
    * 檢查是否設定了 `delaycompress` 選項。

## 6. 重要提示

* 在修改 `logrotate` 設定檔之前，建議先備份原始設定檔。
* 在生產環境中執行 `logrotate` 時，請務必小心，以免影響應用程式的正常運行。
* 如果應用程式在輪替期間持續寫入日誌檔案，可能會導致日誌檔案內容不完整。建議在輪替前暫停應用程式的日誌寫入，或使用 `copytruncate` 選項。
