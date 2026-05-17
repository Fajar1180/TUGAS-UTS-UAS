## Deployment & Current Status

Summary of current implementation and remaining actions for payout pipeline feature (branch: feature/payout-prod).

Completed
- Payout pipeline (service + queued job) implemented.
- Gateway adapters: Xendit adapter and Mock adapter available.
- Retry/backoff behavior implemented on `SendProviderPayoutJob`.
- Provider orchestration and idempotency handling implemented.
- Treasurer export endpoints (CSV / XLS) implemented on backend.
- Runbook, deploy playbooks, helper scripts, and CI workflow added.
- Mock e2e tests for payout flow pass locally.

Pending (high priority first)
- Obtain Xendit Sandbox Secret API Key with disbursement permission.
- Run sandbox end-to-end tests using the real Xendit sandbox key.
- Add GitHub Secrets required for deploy (`DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_KEY`, `DEPLOY_PATH`, `XENDIT_API_KEY`, `MIDTRANS_*`).
- Merge `feature/payout-prod` → `main` and enable deploy workflow.
- Start queue worker on staging (systemd / supervisor) and verify job processing.

Pending (medium/low)
- Verify and finalize Midtrans webhook verification handling.
- Treasurer UI: verify export/download UX and edge-case handling.
- Monitoring and alerting for failed payouts and retry metrics.
- Post-deploy smoke / canary checks and observability (logs/metrics).

How to proceed (recommended)
1. Provide Xendit sandbox secret (or enable disbursement permission) and run:

   php artisan config:clear
   php artisan payouts:test-gateway --to=08123456789

2. Add GitHub Secrets (use `deploy/set_github_secrets.sh` helper or via repository settings).
3. Merge PR and enable Actions; then deploy to staging and start queue worker.

Notes
- Avoid writing provider secrets into OS-level user env (Windows `setx`) — use repository secrets for CI and `.env` for local dev only.
- Mock gateway is available to validate full pipeline locally while waiting for sandbox permissions.

Contact
- If you want, I can: mark reviewers and/or perform the merge automatically (requires a GitHub token with `repo` scope).
