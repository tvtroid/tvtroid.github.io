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



```ts
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
```

<details>
<summary>GetVisitsForUserAct.java</summary>

```java
if (jsGram.platform_category == AC.PlatformCategory.WEBSITE.getTypeId()
    || jsGram.platform_category == AC.PlatformCategory.MOBILE_APP.getTypeId()) {

  jsGram.cv_attrs = parseCvAttr(gram.getConversionAttrs());

    if (jsGram.gram_type == AC.GramType.CV || jsGram.gram_type == AC.GramType.NCV) {

      setCvInfo(gram, jsGram);
    } else if (jsGram.gram_type == AC.GramType.PV) {

      setPvInfo(gram, jsGram);
    } else if (jsGram.gram_type == AC.GramType.Event) {

      setEventInfo(gram, jsGram);
    } else if (jsGram.gram_type == AC.GramType.Launch) {

      setLaunchInfo(gram, jsGram);
    } else {

      throw new AppException(securityParam.uuid,
          GAC.ErrorCode.InvalidGramType, "invalid gram_type.[" + gram + "]");
    }
  } else if (jsGram.platform_category == AC.PlatformCategory.BE.getTypeId()) {

  setBeInfo(gram, jsGram);
  } else if (jsGram.platform_category == AC.PlatformCategory.CLDB.getTypeId()) {

  setCldbInfo(gram, jsGram);
  } else if (jsGram.platform_category == AC.PlatformCategory.CONTACT.getTypeId()) {

  setContactInfo(gram, jsGram);
  } else if (jsGram.platform_category == AC.PlatformCategory.BIZ_INDEX.getTypeId()) {

  setBizIndexInfo(gram, jsGram);
  } else {

  throw new AppException(securityParam.uuid,
      GAC.ErrorCode.InvalidPlatformCategory,
      "invalid platform_category.[" + gram.toString() + "]");
  }
```

</details>

## Solution
