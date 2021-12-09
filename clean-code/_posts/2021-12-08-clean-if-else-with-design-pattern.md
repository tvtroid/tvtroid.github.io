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

## Refactoring

### Factory method pattern

> Factory Method is a creational design pattern that provides an interface for creating objects in a superclass, but allows subclasses to alter the type of objects that will be created.

**Before**

```java
public interface FilterCondition {
}
```

```java
public class FilterFirstTimeCondition implements FilterCondition {
}
```

```java
public class FilterHourCondition implements FilterCondition {
}
```

```java
public class FilterPeriodCondition implements FilterCondition {
}
```

```java
public FilterCondition getFilterCodition(TypeEnum type) {
  if (type == TypeEnum.FirstTime) {
      return new FilterFirstTimeCondition();
  } else if (type == TypeEnum.Period) {
      return new FilterPeriodCondition();
  } else if (type == TypeEnum.Hour) {
      return new FilterHourCondition();
  }
  // Many other if-else
}
```

**After**

```java
public class FilterConditionFactory {
  private Map<TypeEnum, FilterCondition> conditionMap = new HashMap<>();
  public FilterConditionFactory {
      conditionMap.put(TypeEnum.FirstTime, new FilterFirstTimeCondition());
      conditionMap.put(TypeEnum.Period, new FilterPeriodCondition());
      conditionMap.put(TypeEnum.Hour, new FilterHourCondition());
      // more 
  }

  public FilterCondition getFilterCondition(TypeEnum type) {
      return conditionMap.get(type);
  }
}
```

```java
    FilterConditionFactory factory = new FilterConditionFactory();
    FilterCondition condition = factory.getFilterCondition(TypeEnum.period);
```

### Strategy + Factory Method pattern

>> Strategy is a behavioral design pattern that lets you define a family of algorithms, put each of them into a separate class, and make their objects interchangeable.

**Before**
```java
public int calculate(int a, int b, String operator) {
    if ("add".equals(operator)) {
        return a + b;
    } else if ("multiply".equals(operator)) {
        return a * b;
    } else if ("divide".equals(operator)) {
        return a / b;
    } else if ("subtract".equals(operator)) {
        return a - b;
    }
    return -1;
}
```

**After**

```java
public interface Strategy {
    int apply(int a, int b);
}
```

```java
public class Addition implements Strategy {
    @Override
    public int apply(int a, int b) {
        return a + b;
    }
}
```

```java
public class Subtraction implements Strategy {
    @Override
    public int apply(int a, int b) {
        return a - b;
    }
}
```

```java
public class Multiplication implements Strategy {
    @Override
    public int apply(int a, int b) {
        return a * b;
    }
}
```

```java
public class Division implements Strategy {
    @Override
    public int apply(int a, int b) {
        return a / b;
    }
}
```

```java
public class StrategyFactory {
    private Map<String, Strategy> strategyMap = new HashMap<>();
    public StrategyFactory {
        strategyMap.put("add", new Addition());
        strategyMap.put("subtract", new Subtraction());
        strategyMap.put("multiply", new Multiplication());
        strategyMap.put("divide", new Division());
    }

    public Strategy getStrategy(String operator) {
        return strategyMap.get(operator);
    }
}
```

```java
public class Calculator {
  public int calculateUsingStrategyFactory(int a, int b, String operator) {
      StrategyFactory factory = new StrategyFactory();
      Strategy targetStrategy = factory.getStrategy(operator);
      return targetStrategy.apply(a, b);
  }
}
```

_Main.java_
```java
    Calculator calculator = new Calculator();
    calculator.calculateUsingStrategyFactory(2, 1, "add"); // => 3
    calculator.calculateUsingStrategyFactory(2, 1, "divide"); // => 2
```

### Command pattern

>> Command is a behavioral design pattern that turns a request into a stand-alone object that contains all information about the request. This transformation lets you pass requests as a method arguments, delay or queue a request’s execution, and support undoable operations.

**Before**
```java
public class Main {
    private String lastOperator = "";
 
    public int calculate(int a, int b, String operator) {
        if ("add".equals(operator)) {
          lastOperator = "add";
          return a + b;
        } else if ("multiply".equals(operator)) {
          lastOperator = "multiply";
          return a * b;
        } else if ("divide".equals(operator)) {
          lastOperator = "divide";
          return a / b;
        } else if ("subtract".equals(operator)) {
          lastOperator = "subtract";
          return a - b;
        }
        return -1;
    }
  
    public String getLastOperator() {
        return this.lastOperator;
    }
      
    public void saveLastOperator(String operator) {
        this.lastOperator = operator;
    }
    
    public static void main(String[] args) {
        Main main = new Main();
        main.calculate(2, 1, "add"); // => 3
        System.out.println(main.getLastOperator()); // => add
    }
}
```

**After**
```java
public interface Command {
    int execute();
}
```

```java
public class AddCommand implements Command {
    // Command will hold state
    private Main mainState;
    private int a, b;

    public AddCommand(Main mainState, int a, int b) {
        this.mainState = mainState;
        this.a = a;
        this.b = b;
    }

    @Override
    public int execute() {
        mainState.saveLastOperator("add");
        return a + b;
    }
}
```

```java
public class Calculator {
    public int calculateUsingCommand(Command command) {
        return command.execute();
    }
}
```

```java
public class Main {
    private String lastOperator = "";
    
    public String getLastOperator() {
        return this.lastOperator;
    }
      
    public void saveLastOperator(String operator) {
        this.lastOperator = operator;
    }
    
    public static void main(String[] args) {
        Calculator calculator = new Calculator();
        Main main = new Main();
        calculator.calculateUsingCommand(new AddCommand(main, 2, 1)); // => 3
        System.out.println(main.getLastOperator()); // => add
    }
}
```

>>> Use Command pattern when you want to pass the state to the commands

## Chain of Responsibility pattern

**After**

```
public abstract class Link {
    private Link nextLink;

    public void setNextLink(Link next) {
        nextLink = next;
    }

    public virtual int execute(int spent, String type) {
        if (nextLink != null) {
            return nextLink.execute(spent);
        }
        return spent;
    }
}
```

```java
public class HighSpentGoldLink extends Link {
    @Override
    public int execute(int spent, String type) {
        if (spent > 120 && "GOLD".equals(type)) {
          return spent * 4;
        }
        return base.execute(spent, type);
    }
}
```

```java
public class HighSpentNonGoldLink extends Link {
    @Override
    public int execute(int spent, String type) {
      if (spent > 120 && !"GOLD".equals(type)) {
        return spent * 3;
      }
      return base.execute(spent, type);
    }
}
```

```java
Link chain = new HighSpentGoldLink();
Link secondLink = new HighSpentNonGoldLink();
// other links

chain.setNextLink(secondLink);
// other links

chain.execute(130, "SILVER"); // => 130 * 4
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

```java
public interface Rule {
    int getResult(int spent);
    boolean isApplicable(int spent, String type);
}
```

```java
public class HighSpentGoldRule implements Rule {
    @Override
    public int getResult(int spent) {
        return spent * 4;
    }
    
    @Override
    public boolean isApplicable(int spent, String type) {
        return spent > 120 && "GOLD".equals(type);
    }
}
```

```java
public class HighSpentNonGoldRule implements Rule {
    @Override
    public int getResult(int spent) {
        return spent * 3;
    }
    
    @Override
    public boolean isApplicable(int spent, String type) {
        return spent > 120 && !"GOLD".equals(type);
    }
}
```

```java
public class MediumSpentRule implements Rule {
    @Override
    public int getResult(int spent) {
        return spent * 2;
    }
    
    @Override
    public boolean isApplicable(int spent, String type) {
        return spent <= 120 && spent > 50;
    }
}
```

```java
public class LowSpentSilverRule implements Rule {
    @Override
    public int getResult(int spent) {
        return 50;
    }
    
    @Override
    public boolean isApplicable(int spent, String type) {
        return spent <= 50 && "SILVER".equals(type);
    }
}
```

```java
public class LowSpentNonSilverRule implements Rule {
    @Override
    public int getResult(int spent) {
        return spent;
    }
    
    @Override
    public boolean isApplicable(int spent, String type) {
        return spent <= 50 && !"SILVER".equals(type);
    }
}
```

```java
public class Calculator {
  static List<Rule> rules = new ArrayList();
  
  static {
      calculators.add(new HighSpentGoldRule());
      calculators.add(new HighSpentNonGoldRule());
      calculators.add(new MediumSpentRule());
      // more rules
  }
  
  public static int calculate(int spent, String type) {
      for(Rule rule : rules){ 
        if(rule.isApplicable(spent, type)){ 
          return rule.getResult(spent); 
        } 
      }
  }
}
```

```java
PointCalculator.calculate(130, "SILVER"); // => 130 * 4
PointCalculator.calculate(51, "GOLD"); // => 130 * 2
```

## Conclusion
There's always a better design to replace nested if-else. We can combine design patterns if possible to resolve our real case.
- When conditions are simple such as string or enum, there is an oppotunity to replace them with _Factory Method_
- When conditions are more complicated, lets think about _Strategy_
- When we need to modify the state, _Command_ may be a better choice compare to _Strategy_
- When there are many nested if-else statements, lets consider using _Rules_ or _Chain of Responsibility_. We shouldn't use them for simple designs.
- _Rules_ and _Chain of Responsibility_ are similar and can be applied to the same situation. However, _Chain of Responsibility_ lets us define the order of conditions at runtime but _Rules_ does not allow us to modify the execution order of rules 
