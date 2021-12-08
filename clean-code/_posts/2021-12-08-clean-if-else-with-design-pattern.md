---
layout: post
title: "Avoid if else by using design pattern"
permalink: "/clean-code/avoid-if-else-by-using-design-pattern"
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

### Factory method pattern

> Factory Method is a creational design pattern that provides an interface for creating objects in a superclass, but allows subclasses to alter the type of objects that will be created.

>> When we encounter decision constructs which end up doing the similar operation in each branch. There is an opporunity to **extract a factory method which returns an object of a given type and performs the operation based on the concrete object behavior**

_Operation.java_
```java
public interface Operation {
    int apply(int a, int b);
}
```

_Addition.java_
```
public class Addition implements Operation {
    @Override
    public int apply(int a, int b) {
        return a + b;
    }
}
```

_OperatorFactory.java_
```
public class OperatorFactory {
    static Map<String, Operation> operationMap = new HashMap<>();
    static {
        operationMap.put("add", new Addition());
        operationMap.put("divide", new Division());
        // more operators
    }

    public static Optional<Operation> getOperation(String operator) {
        return Optional.ofNullable(operationMap.get(operator));
    }
}
```

```
public class Calculator {
  public int calculateUsingFactory(int a, int b, String operator) {
      Operation targetOperation = OperatorFactory
        .getOperation(operator);
      return targetOperation.apply(a, b);
  }
}
```

_Main.java_
```java
Calculator calculator = new Calculator();
calculator.calculateUsingFactory(2, 1, "add"); // => 3
calculator.calculateUsingStrategy(2, 1, "divide"); // => 2
```

### Strategy pattern

>> The Strategy pattern suggests that you take a class that does something specific in a lot of different ways and extract all of these algorithms into separate classes called strategies.

_Operation.java_
```java
public interface Operation {
    int apply(int a, int b);
}
```

_Addition.java_
```java
public class Addition implements Operation {
    @Override
    public int apply(int a, int b) {
        return a + b;
    }
}
```

_Subtraction.java_
```java
public class Subtraction implements Operation {
    @Override
    public int apply(int a, int b) {
        return a - b;
    }
}
```

_Multiplication.java_
```java
public class Multiplication implements Operation {
    @Override
    public int apply(int a, int b) {
        return a * b;
    }
}
```

_Division.java_
```java
public class Division implements Operation {
    @Override
    public int apply(int a, int b) {
        return a / b;
    }
}
```

_Calculator.java_
```java
public class Calculator {
    private Operation operation; // our strategy
    
    void setOperation(Operation operation) {
        this.operation = operation
    }
    
    public int calculateUsingStrategy(int a, int b) {
        return this.operation.apply(a, b);
    }
}
```

_Main.java_
```java
Calculator calculator = new Calculator();

calculator.setOperation(new Addition());
calculator.calculateUsingStrategy(2, 1); // => 3

calculator.setOperation(new Subtraction());
calculator.calculateUsingStrategy(2, 1); // => 1
```

### Rules pattern

>> When we end up writing a large number of nested if statements, each of the conditions is a business rule which has to be evaluated for the correct logic to be processed. A rule engine takes such complexity out of the main code.

**Before**
```java
// Calculate membership points based on type of the member and how much they spent
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

_Rule.java_
```java
public interface Rule {
    int getResult(int spent);
    boolean evaluate(int spent, String type);
}
```

_HighSpentGoldRule.java_
```java
public class HighSpentGoldRule implements Rule {
    @Override
    public int getResult(int spent) {
        return spent * 4;
    }
    
    @Override
    public boolean evaluate(int spent, String type) {
        return spent > 120 && "GOLD".equals(type);
    }
}
```

_HighSpentNonGoldRule.java_
```java
public class HighSpentNonGoldRule implements Rule {
    @Override
    public int getResult(int spent) {
        return spent * 3;
    }
    
    @Override
    public boolean evaluate(int spent, String type) {
        return spent > 120 && !"GOLD".equals(type);
    }
}
```

_MediumSpentRule.java_
```java
public class MediumSpentRule implements Rule {
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

_LowSpentSilverRule.java_
```java
public class LowSpentSilverRule implements Rule {
    @Override
    public int getResult(int spent) {
        return 50;
    }
    
    @Override
    public boolean evaluate(int spent, String type) {
        return spent <= 50 && "SILVER".equals(type);
    }
}
```

_LowSpentNonSilverRule.java_
```java
public class LowSpentNonSilverRule implements Rule {
    @Override
    public int getResult(int spent) {
        return spent;
    }
    
    @Override
    public boolean evaluate(int spent, String type) {
        return spent <= 50 && !"SILVER".equals(type);
    }
}
```

_Calculator.java_
```java
public class Calculator {
  // A variable holds all the exsiting rules
  static List<Rule> rules = new ArrayList();
  
  // Innit all the rules
  static {
      calculators.add(new HighSpentGoldCalculator());
      calculators.add(new HighSpentNonGoldCalculator());
      calculators.add(new MediumSpentCalculator());
      // more calculators
  }
  
  // I am using normal for loop to be easy to understand for other developers who are not familiar with Java. Java Stream is better here!
  public static int calculate(int spent, String type) {
      for(Rule rule : rules){ 
        if(rule.evaluate(spent, type)){ 
          return rule.getResult(spent); 
        } 
      }
  }
}
```

_Main.java_

```java
PointCalculator.calculate(130, "SILVER"); // => 130 * 4
PointCalculator.calculate(51, "GOLD"); // => 130 * 2
```

## Command pattern


