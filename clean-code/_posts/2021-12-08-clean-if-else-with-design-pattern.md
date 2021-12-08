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

**router.ts**

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

**GetVisitsForUserAct.java**

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

## Refactoring

### Switch statements

**Before**
```java
public int calculate(int a, int b, String operator) {
    int result = Integer.MIN_VALUE;

    if ("add".equals(operator)) {
        result = a + b;
    } else if ("multiply".equals(operator)) {
        result = a * b;
    } else if ("divide".equals(operator)) {
        result = a / b;
    } else if ("subtract".equals(operator)) {
        result = a - b;
    }
    return result;
}
```

**After**
```java
public int calculateUsingSwitch(int a, int b, String operator) {
    int result = Integer.MIN_VALUE;
    
    switch (operator) {
      case "add":
          result = a + b;
          break;
      case "multiply":
          result = a * b;
          break;
      case "divide":
          result = a / b;
          break;
      case "subtract":
          result = a - b;
          break;
    }
    return result;
}
```
>> The switch statements do not fit well when there are complex conditions

### Strategy pattern

>> The Strategy pattern suggests that you take a class that does something specific in a lot of different ways and extract all of these algorithms into separate classes called strategies.

**Before**
```java
public int calculate(int spent, String type) {
  if(spent > 120){ 
    if("GOLD".equals(type)){ 
      return spent * 4; 
    } else { 
      return spent * 3; 
    } 
  } else if(spent > 50){ 
    return spent * 2; 
  } else if("SILVER".equals(type)){ 
    return 50; 
  } 
  // many more else if 
  else{ 
    return spent; 
  }
}
```

**After**
_Calculator.java_
```java
public interface Calculator {
    int calculate(int spent, String type);
    boolean matches(int spent, String type);
}
```

_HighSpentGoldCalculator.java_
```java
public class HighSpentGoldCalculator implements Calculator {
    @Override
    public int calculate(int spent) {
        return spent * 4;
    }
    
    @Override
    public boolean matches(int spent, String type) {
        return spent > 120 && "GOLD".equals(type);
    }
}
```

_HighSpentNonGoldCalculator.java_
```java
public class HighSpentNonGoldCalculator implements Calculator {
    @Override
    public int calculate(int spent) {
        return spent * 3;
    }
    
    @Override
    public boolean matches(int spent, String type) {
        return spent > 120 && !"GOLD".equals(type);
    }
}
```

_MediumSpentCalculator.java_
```java
public class MediumSpentCalculator implements Calculator {
    @Override
    public int calculate(int spent) {
        return spent * 2;
    }
    
    @Override
    public boolean matches(int spent, String type) {
        return spent <= 120 && spent > 50;
    }
}
```

_LowSpentSilverCalculator.java_
```java
public class LowSpentSilverCalculator implements Calculator {
    @Override
    public int calculate(int spent) {
        return 50;
    }
    
    @Override
    public boolean matches(int spent, String type) {
        return spent <= 50 && "SILVER".equals(type);
    }
}
```

_LowSpentNonSilverCalculator.java_
```java
public class LowSpentNonSilverCalculator implements Calculator {
    @Override
    public int calculate(int spent) {
        return spent;
    }
    
    @Override
    public boolean matches(int spent, String type) {
        return spent <= 50 && !"SILVER".equals(type);
    }
}
```

_PointCalculator.java_
```java
public class PointCalculator {
  static List<Calculator> calculators = new ArrayList();
  static {
      calculators.add(new HighSpentGoldCalculator());
      calculators.add(new HighSpentNonGoldCalculator());
      calculators.add(new MediumSpentCalculator());
      // more calculators
  }
}
```

```java
public int calculate(int spent, String type) {
  if(spent > 120){ 
    if("GOLD".equals(type)){ 
      return spent * 4; 
    } else { 
      return spent * 3; 
    } 
  } else if(spent > 50){ 
    return spent * 2; 
  } else if("SILVER".equals(type)){ 
    return 50; 
  } 
  // many more else if 
  else{ 
    return spent; 
  }
}
```
