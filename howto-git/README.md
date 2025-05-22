## git 常用指令

### git clone
``` bash
git clone https://github.com/username/repo_name.git
git clone git@github.com-sshkeys:username/repo_name.git

```

### git status
``` bash
git status

git add file/dir
git add .   # add all modification files

```

### git commit
``` bash
git commit
git commit -m "short message"

```

### git restore
``` bash
git add file.txt       # 誤將 file.txt 加入暫存區
git restore --staged file.txt  # 從暫存區移除，但保留修改

git restore <file> # 丟棄工作目錄中文件的修改（恢覆到暫存區或最近提交的狀態）

```

### 更新本地repo
``` bash
# fetch & merge branch main
git branch
git checkout main

git remote -v # check remote settings

git pull origin main
git fetch origin  # fetch without merge
```

### git branch
``` bash
git branch new_branch_name
git checkout new_branch_name
# or
git checkout -b new_branch_name

```

### git remote
``` bash
git remote add origin URL

```

### git stash
``` bash
git stash             # 暫存當前修改
git checkout 目標分支  # 切換分支
git stash pop         # 還原暫存的修改              # 暫存當前修改

```

### 更新本地main 分支
``` bash
git status  # 檢查狀態

# 如果有未提交的修改：
git stash   # 暫存當前修改（或先 commit）
git stash list

#  切換到 main 分支
git checkout main
# 從遠端拉取最新更新
git pull origin main
# 如果需要，切換回 bugfix 分支
git checkout bugfix
# 如果有暫存的修改，恢復它們
git stash pop  # 等同於 git stash apply + git stash drop

```

### 解決 git merge 後出現衝突的方法
``` bash
git status # check Unmerged paths:
```
``` js
# edit unmerged files, find lines like: 
<<<<<<< HEAD
your mmodifed code is here
=======
feature code is here
>>>>>>> feature-branch
```
``` bash
# afiter edited them.  git add them to staged
git add file1.txt file2.txt
git status # check staged files
git commit # commit the changes

# (optional) push to remote branch 
git push

```

### 解決 git stash pop 後出現衝突的方法
``` bash
git status
# 手動編輯衝突文件
## <<<<<<< Updated upstream
## 這是當前分支的內容
## =======
## 這是暫存區的修改內容
## >>>>>>> Stashed changes
git add conflicted files

git stash drop  # 刪除已應用的暫存（因為 pop 失敗時暫存仍存在）
git stash drop stash@{2}

```

### 查看暫存內容與當前差異
``` bash
git stash show -p stash@{0}
git stash apply --index  # 嘗試保留原來的暫存狀態

```

### 不切換分支直接更新 main
``` bash
# 1. 直接獲取遠端所有更新（不自動合併）
git fetch origin

# 2. 將本地 main 分支更新到與遠端 main 相同
git branch -f main origin/main
```

### 將最新的 main 合併到 bugfix 分支
``` bash
git checkout bugfix
git merge main

```

### 比較本地分支與遠端追蹤分支
``` bash
git diff main origin/main

git log main..origin/main  # 查看遠端有而本地沒有的提交
git log origin/main..main  # 查看本地有而遠端沒有的提交

```

### 修改commited author
``` bash
git commit --amend --author="kafka <kafka.lws@gmail.com>" --no-edit
git push origin uc_rtty --force-with-lease
```
