---
name: gpt-writer
description: >-
  Claude gathers the facts, GPT (Codex) writes the prose. Use this skill WHENEVER
  the deliverable is a long piece of Chinese/English prose that will be read by
  people: README.md, project docs, 說明文件, 報告, 總結, PR/commit description
  paragraphs, a long explanation the user asked to have "寫好一點". Triggers on
  "寫 README", "寫文件", "幫我寫說明", "整理成報告", "用 GPT 寫", "讓 codex 寫".
  Do NOT use for chat replies, code comments, one-paragraph answers, or when the
  user asks Claude to write it directly. Requires the codex@openai-codex plugin.
---

# gpt-writer — Claude 出事實，GPT 寫文字

分工：Claude 理解專案、決定內容、核對事實。GPT（Codex）負責措辭與結構。
GPT 只看「事實稿」寫作，有疑問就寫「提問稿」問 Claude。這兩個詞在本 skill 內固定不變。

- 事實稿：`.gpt-writer/facts.md`，Claude 寫。
- 提問稿：`.gpt-writer/questions.md`，GPT 寫。
- 目標檔案：要產出的文件，路徑寫在事實稿的「目標檔案」段落。

工作目錄 `.gpt-writer/` 放在專案根目錄，流程結束後刪除。

## 流程

### 1. Claude 蒐集事實
- 讀程式碼、目錄、既有文件。需要的話問使用者「由來」與「時間」，不要猜。
- 用 `templates/facts.md` 建立 `.gpt-writer/facts.md`。每一格都要填；不知道的寫「未知」。
- 「風格規則」段落照模板保留，可以加、不要刪。
- 目標檔案已存在且是 git 追蹤檔時，先告訴使用者會整份重寫。

### 2. 第一輪：GPT 寫
- 複製 `templates/writer-prompt.md` 到 `.gpt-writer/prompt.md`。不用改內容。
- 執行（Bash timeout 設 600000）：
  ```bash
  bash ~/.claude/skills/gpt-writer/scripts/codex-write.sh .gpt-writer/prompt.md
  ```
- 腳本固定用 `--write --model gpt-5.6-sol --effort medium`。要換模型改 `scripts/codex-write.sh` 的 `exec` 那行。

### 3. 回答提問稿（最多兩輪）
- 若 `.gpt-writer/questions.md` 存在：Claude 逐題回答，寫進事實稿最後的「補充回答」段落，格式 `Q1: 答案`。
- Claude 答不出來的題目，問使用者，拿到答案再寫進去。
- 複製 `templates/resume-prompt.md` 到 `.gpt-writer/prompt.md`，執行：
  ```bash
  bash ~/.claude/skills/gpt-writer/scripts/codex-write.sh --resume .gpt-writer/prompt.md
  ```
- 第二輪後若仍有提問稿，Claude 自己把剩下的 `[[Qn]]` 補完，不再呼叫 GPT。

### 4. Claude 核對事實
- 讀目標檔案，逐段對照事實稿。
- 發現與事實稿不符、或事實稿沒有的內容：直接改掉，只改事實，不改措辭風格。
- 確認沒有殘留的 `[[Q` 標記。
- 確認風格規則有被遵守（繁中、不是日記、章節順序）。

### 5. 收尾
- 刪除 `.gpt-writer/`。
- 向使用者回報：寫了哪個檔案、跑了幾輪、GPT 問了什麼、Claude 改了哪些事實。

## 長篇說明模式
使用者要的是一段給人讀的長文，而不是專案檔案時（例如「把這個結果寫成報告」）：
- 目標檔案設為 `.gpt-writer/out.md`。
- 流程相同。步驟 5 時先把 `out.md` 內容原文交給使用者，再刪目錄。

## 注意
- 每次呼叫 GPT 要等數十秒到數分鐘。不要用在短回覆。
- GPT 文筆順，但會把不確定的事寫得很肯定。步驟 4 不可省略。
- 腳本從 `~/.claude/plugins/installed_plugins.json` 找 plugin 路徑，plugin 升版後不用改。
