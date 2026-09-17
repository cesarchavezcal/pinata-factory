# Service Layer Architecture Guide

## Overview

The service layer pattern establishes a clean two-layer boundary:
- **Actions (Orchestration):** Own business decisions, authorization checks, state transitions, failure classification, and retry strategies (the "why" and "when").
- **Services (Operational Mechanics):** Centralize reusable, low-level technical operations such as SDK integration, CLI execution, external API requests, and readiness health checks (the "how").

---

## Core Architecture

```text
Orchestration Layer (Actions)          Service Layer (Shared Mechanics)
├── owns business rules                ├── owns reusable operations
├── owns state transitions             ├── owns provider/SDK interactions
├── owns auth/ownership checks         ├── owns command execution details
├── owns failure classification        ├── owns health checks / readiness
├── owns retries / user-facing errors  └── returns structured results
└── calls service functions
```

### Separation Principle
- **What this product flow means** belongs in actions.
- **How to perform this operation reliably** belongs in services.

---

## Design Principles

1. **Composable Capability Blocks:** Design granular functions rather than monolithic procedures. Callers select only the capability blocks they require.
2. **Explicit Parameters & Structured Outputs:** Pass all inputs explicitly. Return typed result objects (e.g. `{ ready: boolean, previewUrl?: string }`).
3. **No Direct Database Access:** Never query or mutate application database state within service functions. Domain state belongs exclusively to actions.
4. **Explicit Failure Modes:** Return structured results or typed errors rather than catching and swallowing exceptions.

---

## Example: Reusable Email Service

### Service Layer (Shared Mechanics)
```typescript
// services/emailService.ts
export interface SendEmailParams {
  to: string;
  subject: string;
  html: string;
}

export interface SendEmailResult {
  success: boolean;
  messageId?: string;
  error?: string;
}

export async function sendEmail(params: SendEmailParams): Promise<SendEmailResult> {
  try {
    const response = await emailProviderClient.send({
      to: params.to,
      subject: params.subject,
      content: params.html,
    });
    return { success: true, messageId: response.id };
  } catch (err) {
    return { success: false, error: (err as Error).message };
  }
}
```

### Action Layer (Orchestration & Business Policy)
```typescript
// actions/userSignup.ts
export async function handleUserSignup(user: UserProfile): Promise<void> {
  // Business rule: verify marketing preferences before sending
  if (!user.marketingOptIn) {
    return;
  }
  const result = await sendEmail({
    to: user.email,
    subject: "Welcome to Pinata Factory",
    html: `<h1>Welcome, ${user.name}!</h1>`,
  });
  if (!result.success) {
    logger.warn("Welcome email failed", { userId: user.id, error: result.error });
  }
}

// actions/adminInvite.ts
export async function handleAdminInvite(invitee: Invitee): Promise<void> {
  // Business rule: invitations are mandatory regardless of marketing opt-in
  const result = await sendEmail({
    to: invitee.email,
    subject: "You've been invited",
    html: `<p>Click here to accept: ${invitee.link}</p>`,
  });
  if (!result.success) {
    throw new ActionError("INVITE_FAILED", result.error);
  }
}
```

---

## Anti-Patterns Catalog

| Anti-Pattern | Description | Consequence |
|---|---|---|
| **God Service** | Monolithic function encapsulating entire end-to-end user journeys | Obscures control flow, prevents code reuse, tightly couples unrelated features |
| **Leaky Service** | Service function directly querying or updating domain tables in the DB | Bypasses business validation, creates hidden side-effects |
| **Inconsistent API** | Mixed argument conventions, varying error shapes across service methods | Causes caller confusion and inconsistent exception handling |
| **Over-Abstraction** | Extracting single-use logic used by only one caller into a service | Premature complexity; overhead without reuse benefit |

---

## Migration Checklist

1. Implement new feature logic directly in the action first to validate product behavior.
2. Identify repeated operational blocks across two or more callers.
3. Extract only repeated, non-domain mechanics into a standalone service module.
4. Replace one caller, run typechecks, and verify tests pass.
5. Incrementally migrate remaining callers one at a time.
