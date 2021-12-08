---
layout: post
title: "Clean if else with design pattern"
permalink: "/clean-code/clean-if-else-with-design-pattern"
date: 2021-12-08 11:24:45 +0700
category: clean-code
---
<div style="text-align:center">
  <img src="https://user-images.githubusercontent.com/26586150/145139563-93a1c91c-8dec-47c9-9c3b-f34cb8b0e7e7.png" />
</div>

## Disadvantages of (nested) if-else

Nested if statements make our code more complex and difficult to maintain
- When the number of conditions increases in the nested if-else block, the complexity of the code gets increased, maintenance of code is also increased
- Using lots of if statement makes the testing process difficult
- It's difficult for debugging because a programmer faces difficulty associate statement to related block.
- Every time we want to add a new condition, we have to read and understand the old logics to make sure the new conndition is added into the correct position.

## Examples

<details>
<summary>router.ts</summary>
<p>

```ts
router.beforeEach(async (to, from, next) => {
  // Redirect to client-settings page when the user has already logged in with owner permission
  redirectToClientSettings(to.path);

  // Refresh search navigation not to keep previous conditions
  clearSelectCondition(to, from);

  // ブラウザのバックボタン対応、観察画面からユーザ一覧に行った場合は観察画面を消す
  if (
    from.name === "user" &&
    (to.name === "attribute" || to.name === "overview" || to.name === "memo")
  ) {
    store.commit("user/setShowUserDetail", false);
  }

  if (store.state.auth.isAuthenticated) {
    // ログイン済みで、ログインページを開こうとした場合はホーム
    if (to.name === "login") {
      next({ name: "home" });
      return;
    }
    next();
    return;
  }

  if (store.state.auth.isInitialized) {
    if (to.matched.some(record => record.meta.allowPublicAccess)) {
      next();
      return;
    }
    next({ name: "login" });
    return;
  }

  try {
    await store.dispatch("auth/initialize");

    // Redirect to client-settings page when the user tried to login and the user has owner permission
    redirectToClientSettings(to.path);

    const loginUser: LoginUser | null = store.state.auth.user;
    if (loginUser) {
      if (
        to.path.startsWith("/user-trend") &&
        !loginUser.permission.isAvailableUserTrend
      ) {
        next({ name: "home" });
        return;
      }

      if (to.name === "users" && !loginUser.permission.isAvailableUserList) {
        next({ name: "home" });
        return;
      }

      if (
        to.name == "funnel-analysis" ||
        to.name == "funnel-analysis-create" ||
        to.name == "funnel-analysis-detail"
      ) {
        const loginClient: Client | null = store.state.client.client;
        if (
          !(
            loginUser.permission.isAvailableUserList &&
            loginClient != null &&
            loginClient.hasFunnelAnalysisContract
          )
        ) {
          next({ name: "home" });
          return;
        }
      }
    }

    if (store.state.auth.isAuthenticated) {
      if (to.name === "login") {
        next({ name: "home" });
        return;
      }
      next();
      return;
    } else if (to.meta && to.meta.allowPublicAccess) {
      next();
      return;
    } else {
      if (to.name !== "login" && to.name !== "home") {
        next({ name: "login", query: { redirect: to.fullPath } });
      } else {
        next({ name: "login" });
      }
      return;
    }
  } catch (e) {
    showAlert(i18n.t("util.errorUtil.common-error-message") as string);
  }
});
\```

</p>
</details>
```
## Solution
