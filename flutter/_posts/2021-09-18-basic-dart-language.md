---
layout: post
title: "Basic Dart language"
permalink: "/kubernetes/basic-dart-language"
date: 2021-09-18 11:24:45 +0700
category: flutter
---
## A basic Dart program
```
void main() {
  for (int i = 0; i < 5; i++) {
    printInteger(i);
  }
}

void printInteger(int myNumber) {
  print("My number is $myNumber");
}
```
![image](https://user-images.githubusercontent.com/26586150/133914368-bdafb2f9-08c8-484c-9583-1e0371186de6.png)

## Variables
**Type inference**
```
void main() {
  var name = 'Truong'; // Type inference to String
  var age = 18; // Type inference to int
  print(name.runtimeType);
  print(age.runtimeType);
}
```
![image](https://user-images.githubusercontent.com/26586150/133914491-9594acc8-be7b-415e-acf4-a5f241e23f5a.png)

**Null Safety**
```
void main() {
  print(guessGender("Truong"));
  print(guessGender("Unknown"));
  print(guessGender(null));
}

String? guessGender(String? name) {
  print("Input name is ${name!}");
  if (name == "Truong") {
    return "Male";
  }
}
```
![image](https://user-images.githubusercontent.com/26586150/133914682-f3cc6ca2-c6d0-4f8e-bb8d-bb2ee382abb2.png)

**Late variables**
1. Declaring a non-nullable variable that’s initialized after its declaration.
2. Lazily initializing a variable.

```
late String name; // 1. a non-nullable variable that’s initialized after its declaration.

void main() {
  late String temperature = _readThermometer(); // 2. Lazily initialized. If temperature is never used, _readThermometer() is never called
}

String _readThermometer() {
  // E.g. the function is very costly
  return "";
}
```

**When to use lazily initializing variable?**
- The variable might not be needed, and initializing it is costly.
- You’re initializing an instance variable, and its initializer needs access to this.

**static, final and const**
- "static" means a member is available on the class itself instead of on instances of the class. That's all it means, and it isn't used for anything else. static modifies *members*.

- "final" means single-assignment: a final variable or field *must* have an initializer. Once assigned a value, a final variable's value cannot be changed. final modifies *variables*.

- "const" has a meaning that's a bit more complex and subtle in Dart. const modifies *values*. You can use it when creating collections, like const [1, 2, 3], and when constructing objects (instead of new) like const Point(2, 3). Here, const means that the object's entire deep state can be determined entirely at compile time and that the object will be frozen and completely immutable.




