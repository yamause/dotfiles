See @README for project overview.

## Development Workflow Rules

Please adhere to the following rules when proceeding with development work.

### 1. Branch Creation

When starting a **new development session or task context** (i.e., when you start a task and before executing `/clear`), you must always create a **new branch**. Avoid committing directly to the main branch or other in-progress development branches.

*Rationale: This ensures that the work done within a single logical conversation with Claude is isolated and easy to review/revert.*

### 2. Commit Timing

Make a commit for **each completed turn or significant interaction** with Claude Code.

* **A "turn" or "interaction" is defined as a unit of work:** typically, a set of changes resulting from **one prompt/command from the user and the resulting output/modification by Claude.**
* The commit message should be concise and clearly describe the content of that specific interaction in **Japanese**.

### 3. Handling Rollbacks (Reverting Work)

If a change of direction or a rollback becomes necessary during a task, you may revert the commit history *within that specific branch*. Take care not to affect other branches or the shared repository.

### 4. Work Journal Management

To maintain continuity across work sessions, you must maintain a work journal in the project root directory.

#### At the Start of Work:

1. Check for the `./work-journal` directory in the project root
2. If it exists, read the .md files inside to understand the context of previous work sessions
3. If the directory does not exist:
   * Create the `./work-journal` directory
   * Create a `.gitignore` file inside it with the content `*` to exclude all journal files from Git tracking

#### At the End of Work:

1. Create or update a .md file in `./work-journal` documenting your work session
2. Include the following information in your journal entry:
   * Date and summary of tasks completed
   * Key decisions made and their rationale
   * Current state of the work (completed, in-progress, blocked)
   * Any important context needed for resuming or continuing the work
   * References to related branches, commits, or files

*Rationale: The work journal provides continuity between sessions, allowing you (or future sessions) to understand the context and progress of ongoing work without having to re-examine the entire codebase.*
