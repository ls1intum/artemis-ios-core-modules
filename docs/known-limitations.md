# Known limitations

- Device deregistration during logout: a server rejection or network failure still permits local logout. There is no persisted retry after the session credentials are cleared, so server-side notification-device cleanup may remain pending.
- Assessment status: `noResult` after the assessment deadline distinguishes an elapsed deadline from pending grading before the deadline. It does not imply grading cannot happen later.
- External submissions: result presentation currently shares the late-submission status rather than exposing a separate external-submission status.

These notes preserve the existing follow-up work without emitting compiler-adjacent SwiftLint reminders on every consumer build. Runtime behavior is unchanged.
