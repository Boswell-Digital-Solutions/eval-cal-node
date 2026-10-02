# Known issues

## 2026-10-02: `ci.yml` runs twice on a pull request branch

- What is wrong: `ci.yml` triggers on `push` to every branch (`**`) and on `pull_request`. A push to a pull request branch runs the tests twice.
- Root cause: both triggers are broad. Not caused by the path filter.
- Fix: not made. Limit `push` to the default branch.
- Status: open.
