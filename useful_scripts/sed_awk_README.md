`awk` 和 `sed` 是 Linux/Unix 系統中非常強大的文字處理工具，它們在 Shell Script 中經常被使用，用於處理文字檔案或串流資料。以下是它們的用法介紹：

**1. awk 用法：**

`awk` 是一種程式語言，專為文字處理而設計。它擅長於處理結構化的文字資料，例如以欄位分隔的檔案。

* **基本語法：**
    * `awk '條件 {動作}' 檔案名稱`
    * `awk` 會逐行讀取檔案，並對每一行執行條件判斷和動作。
* **欄位處理：**
    * `awk` 會將每一行分割成欄位，預設以空白或 Tab 字元分隔。
    * `$1` 表示第一個欄位，`$2` 表示第二個欄位，`$0` 表示整行。
* **常用選項：**
    * `-F`：指定欄位分隔符號。例如，`-F,` 表示以逗號分隔欄位。
    * `-v`：定義變數。
    * `-f`：從檔案讀取 `awk` 指令。
* **常用動作：**
    * `print`：列印欄位或字串。
    * `printf`：格式化輸出。
    * `if-else`：條件判斷。
    * `for`：迴圈。
* **範例：**
    * 列印檔案的第二個欄位：`awk '{print $2}' file.txt`
    * 列印檔案中包含 "error" 的行：`awk '/error/' file.txt`
    * 計算檔案中數字欄位的總和：`awk '{sum += $1} END {print sum}' file.txt`

**2. sed 用法：**

`sed` 是一種串流編輯器，它擅長於對文字進行替換、刪除、插入等編輯操作。

* **基本語法：**
    * `sed '指令' 檔案名稱`
    * `sed` 會逐行讀取檔案，並對每一行執行指令。
* **常用指令：**
    * `s`：替換字串。例如，`s/old/new/g` 將 "old" 替換為 "new"。
    * `d`：刪除行。
    * `a`：在行後新增文字。
    * `i`：在行前插入文字。
    * `p`：列印行。
* **常用選項：**
    * `-e`：允許多個指令。
    * `-f`：從檔案讀取 `sed` 指令。
    * `-i`：直接修改檔案內容（請小心使用）。
    * `-r`：使用擴充的正規表示式。
* **範例：**
    * 將檔案中的 "apple" 替換為 "orange"：`sed 's/apple/orange/g' file.txt`
    * 刪除檔案中的空行：`sed '/^$/d' file.txt`
    * 在檔案的每一行前加上 "# "：`sed 's/^/# /' file.txt`

**3. awk 和 sed 的比較：**

* `awk` 更適合處理結構化的文字資料，例如日誌檔案或 CSV 檔案。
* `sed` 更適合對文字進行簡單的替換、刪除、插入等編輯操作。
* `awk` 是一種程式語言，功能更強大，可以進行複雜的邏輯判斷和計算。
* `sed` 是一種串流編輯器，更輕量級，更適合快速的文字處理。

**4. 總結：**

`awk` 和 `sed` 是 Shell Script 中不可或缺的工具。熟練掌握它們的用法，可以大大提高文字處理的效率。

### 以下是一些在 Shell Script 中使用 `awk` 和 `sed` 的範例：

**1. 使用 `awk`：**

* **範例 1：從 CSV 檔案中提取特定欄位**

    假設您有一個名為 `data.csv` 的 CSV 檔案，內容如下：

    ```csv
    Name,Age,City
    John,30,New York
    Alice,25,London
    Bob,35,Paris
    ```

    您可以使用 `awk` 提取第二個和第三個欄位（年齡和城市）：

    ```bash
    awk -F, '{print $2, $3}' data.csv
    ```

    輸出：

    ```
    Age City
    30 New York
    25 London
    35 Paris
    ```

* **範例 2：計算檔案中數字欄位的平均值**

    假設您有一個名為 `numbers.txt` 的檔案，內容如下：

    ```
    10
    20
    30
    40
    50
    ```

    您可以使用 `awk` 計算這些數字的平均值：

    ```bash
    awk '{sum += $1; count++} END {if (count > 0) print sum / count}' numbers.txt
    ```

    輸出：

    ```
    30
    ```

* **範例 3：篩選日誌檔案中的錯誤訊息**

    假設您有一個名為 `logfile.txt` 的日誌檔案，您可以使用 `awk` 篩選包含 "ERROR" 的行：

    ```bash
    awk '/ERROR/' logfile.txt
    ```

**2. 使用 `sed`：**

* **範例 1：替換檔案中的字串**

    假設您有一個名為 `text.txt` 的檔案，內容如下：

    ```
    This is an apple.
    I like apples.
    ```

    您可以使用 `sed` 將 "apple" 替換為 "orange"：

    ```bash
    sed 's/apple/orange/g' text.txt
    ```

    輸出：

    ```
    This is an orange.
    I like oranges.
    ```

* **範例 2：刪除檔案中的空行**

    假設您有一個名為 `empty_lines.txt` 的檔案，其中包含一些空行。您可以使用 `sed` 刪除這些空行：

    ```bash
    sed '/^$/d' empty_lines.txt
    ```

* **範例 3：在檔案的每一行前加上註解符號**

    假設您有一個名為 `config.txt` 的檔案，您可以使用 `sed` 在每一行前加上 "# "：

    ```bash
    sed 's/^/# /' config.txt
    ```

* **範例 4: 修改檔案內容**

    如果想直接修改檔案內容，可以使用 `-i` 選項。

    ```bash
    sed -i 's/apple/orange/g' text.txt
    ```

    這個指令會直接修改 `text.txt` 檔案，將其中的 "apple" 替換為 "orange"。

**3. 在 Shell Script 中組合使用 `awk` 和 `sed`：**

* **範例：從日誌檔案中提取錯誤訊息，並將其中的特定字串替換為其他字串**

    ```bash
    #!/bin/bash

    logfile="logfile.txt"

    awk '/ERROR/' "$logfile" | sed 's/old_string/new_string/g'
    ```

    這個腳本會先使用 `awk` 提取日誌檔案中的錯誤訊息，然後使用 `sed` 將這些訊息中的 "old\_string" 替換為 "new\_string"。

**注意事項：**

* `awk` 和 `sed` 的功能非常強大，這裡只介紹了一些基本用法。
* 建議您查閱相關文件，以更深入地了解它們的用法。
* 使用 `sed -i` 選項時，請務必小心，以免意外修改檔案內容。
