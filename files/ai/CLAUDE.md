See @README for project overview.

## Development Workflow Rules

**IMPORTANT**: You MUST follow these rules for EVERY development task. Execute the workflow checklist at the start and end of each session.

Please adhere to the following rules when proceeding with development work.

### Workflow Checklist

#### At the Start of EVERY Task:
1. ✅ Check current branch with `git branch --show-current`
2. ✅ Check recent git history with `git log --oneline -10` to understand recent work
3. ✅ Check `./work-journal/` directory and read `.md` files to understand previous work context
4. ✅ If starting a NEW task (not continuing existing work), create a new branch
5. ✅ If `./work-journal` doesn't exist, create it with `.gitignore` containing `*`

#### At the End of EVERY Task:
1. ✅ Create a commit with a Japanese commit message describing the work done
2. ✅ Update or create a work journal entry in `./work-journal/YYYY-MM-DD.md`
3. ✅ Ensure all changes are tracked in git

### 1. Branch Creation

When starting a **new development session or task context**, you must create a **new branch**.

**Definition of "new task":**
- User explicitly requests a new feature or significant change
- Task is unrelated to current branch work
- Starting work after `/clear` command

**Exception:** Continue on current branch if:
- Directly related to current branch's purpose (check git log and branch name)
- Fixing/improving work already done in this branch
- User explicitly says to continue on current branch

Avoid committing directly to the main branch.

*Rationale: This ensures that the work done within a single logical conversation with Claude is isolated and easy to review/revert.*

### 2. Commit Timing

**MANDATORY**: Make a commit for **each completed turn or significant interaction** with Claude Code.

* **A "turn" or "interaction" is defined as a unit of work:** typically, a set of changes resulting from **one prompt/command from the user and the resulting output/modification by Claude.**
* The commit message should be concise and clearly describe the content of that specific interaction in **Japanese**.
* **When to commit:**
  - After completing user's request
  - After making significant changes (file edits, additions, deletions)
  - Before responding to user with "work completed"
  - Even if the change is just documentation updates

### 3. Handling Rollbacks (Reverting Work)

If a change of direction or a rollback becomes necessary during a task, you may revert the commit history *within that specific branch*. Take care not to affect other branches or the shared repository.

### 4. Work Journal Management

**MANDATORY**: To maintain continuity across work sessions, you must maintain a work journal in the project root directory.

#### At the Start of Work:

**YOU MUST ALWAYS DO THIS FIRST:**

1. Check for the `./work-journal` directory in the project root with `ls -la ./work-journal/`
2. If it exists, read ALL `.md` files inside to understand the context of previous work sessions
3. If the directory does not exist:
   * Create the `./work-journal` directory
   * Create a `.gitignore` file inside it with the content `*` to exclude all journal files from Git tracking

#### At the End of Work:

**YOU MUST ALWAYS DO THIS BEFORE SAYING "WORK COMPLETED":**

1. Create or update a .md file in `./work-journal/` with filename format `YYYY-MM-DD.md` (e.g., `2025-10-28.md`)
2. If the file for today already exists, append to it with a new section
3. Include the following information in your journal entry:
   * Date and time (HH:MM format)
   * Summary of tasks completed (bullet points)
   * Key decisions made and their rationale
   * Current state of the work (completed, in-progress, blocked)
   * Any important context needed for resuming or continuing the work
   * References to related branches, commits, or files
   * Any issues encountered and how they were resolved

**Journal Entry Template:**
```markdown
## YYYY-MM-DD HH:MM - [Task Title]

### 完了した作業
- [bullet points]

### 重要な決定事項
- [bullet points]

### 現在の状態
- [completed/in-progress/blocked]

### 次のステップ
- [what needs to be done next]

### 関連情報
- Branch: [branch-name]
- Commits: [commit hashes or messages]
- Files modified: [list of files]
```

*Rationale: The work journal provides continuity between sessions, allowing you (or future sessions) to understand the context and progress of ongoing work without having to re-examine the entire codebase.*
