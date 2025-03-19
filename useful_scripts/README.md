## useful shell scripts


#### 用於刪除 30 天之前的日誌檔案
``` bash
#!/bin/bash

# 設定要清理的日誌目錄
log_dir="/path/to/your/logs"

# 設定保留天數
retention_days=30

# 使用 find 命令尋找並刪除 30 天之前的 .log 檔案
find "$log_dir" -type f -name "*.log" -mtime +"$retention_days" -delete

# 顯示刪除的檔案（可選）
# find "$log_dir" -type f -name "*.log" -mtime +"$retention_days" -print -delete

# 日誌記錄（可選）
# timestamp=$(date "+%Y-%m-%d %H:%M:%S")
# echo "$timestamp: Deleted log files older than $retention_days days in $log_dir" >> /var/log/cleanup_logs.log

# 第二種寫法
# 使用 find 命令尋找 30 天之前的 .log 檔案，並使用 xargs rm 刪除
find "$log_dir" -type f -name "*.log" -mtime +"$retention_days" -print0 | xargs -0 rm -f

```

### 刪除指定檔名的log
``` bash
#!/bin/sh
#
YYYY_MM="2019-11"
rm mylog_*__${YYYY_MM}-*.log.gz

```

#### 取得今天日期
``` bash
today=$(date +%Y-%m-%d) # 格式化為 YYYY-MM-DD
echo "今天的日期：$today"

#其他格式
#today=$(date +%Y%m%d) #YYYYMMDD
#today=$(date +%d-%m-%Y) #DD-MM-YYYY
```

#### 取得檔案字數, 行數, 特定字串數
``` bash
file="your_file.txt" # 替換為您的檔案名稱
word_count=$(wc -w < "$file")
echo "檔案 '$file' 的字數：$word_count"

line_count=$(wc -l < "$file")
echo "檔案 '$file' 的行數：$line_count"

string="your_string" # 替換為您要搜尋的字串
string_count=$(grep -c "$string" "$file")
echo "檔案 '$file' 中字串 '$string' 的計數：$string_count"

#不區分大小寫
#string_count=$(grep -ci "$string" "$file")
```

#### 字串比較
* =  : 等於
* != : 不等於
* -z : 字串為空
* -n : 字串不為空

``` bash
name="John"
if [ "$name" = "John" ]; then
  echo "Hello, John!"
else
  echo "Hello, stranger!"
fi
```

#### 數字比較
* -eq : 等於
* -ne : 不等於
* -gt : 大於
* -ge : 大於等於
* -lt : 小於
* -le : 小於等於

``` bash
score=85

if [ "$score" -ge 90 ]; then
  echo "A"
elif [ "$score" -ge 80 ]; then
  echo "B"
elif [ "$score" -ge 70 ]; then
  echo "C"
else
  echo "D"
fi

```

#### 檔案判斷
* -f : 檔案存在且為普通檔案
* -d : 目錄存在
* -e : 檔案或目錄存在
* -r : 檔案可讀
* -w : 檔案可寫
* -x : 檔案可執行
``` bash
file="test.txt"
if [ -f "$file" ]; then
  echo "File exists"
else
  echo "File does not exist"
fi
```
``` bash
#!/bin/bash

file="my_file.txt"

if [ -f "$file" ] && [ -r "$file" ]; then
  echo "檔案 '$file' 存在且可讀。"
else
  echo "檔案 '$file' 不存在或不可讀。"
fi

path="my_path"

if [ -f "$path" ] || [ -d "$path" ]; then
  echo "'$path' 是一個檔案或目錄。"
else
  echo "'$path' 不是檔案也不是目錄。"
fi

# 檢查檔案是否可讀且大小大於 100 位元組, 檢查檔案是否可寫
if ([ -r "$file" ] && [ -s "$file" -gt 100 ]) || [ -w "$file" ]; then
  echo "檔案 '$file' 符合條件。"
else
  echo "檔案 '$file' 不符合條件。"
fi
```

#### 邏輯運算
* !  : 邏輯非
* -a : 邏輯與 (and)
* -o : 邏輯或 (or)
``` bash
#!/bin/bash

file="test.txt"

if ! [ -f "$file" ]; then
  echo "檔案 '$file' 不存在。"
else
  echo "檔案 '$file' 存在。"
fi

num=15
# 檢查變數 num 是否大於 10 且小於 20
if [ "$num" -gt 10 -a "$num" -lt 20 ]; then
  echo "變數 '$num' 在 10 到 20 之間。"
else
  echo "變數 '$num' 不在 10 到 20 之間。"
fi

user="guest"

if [ "$user" = "admin" -o "$user" = "root" ]; then
  echo "使用者 '$user' 具有管理員權限。"
else
  echo "使用者 '$user' 沒有管理員權限。"
fi
```