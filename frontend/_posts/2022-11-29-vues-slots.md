---
layout: post
title: "Slots in Vue JS"
permalink: "/frontend/vues-slots"
date: 2022-11-29 20:00:00 +0700
category: frontend
---

## What and why?

In Vue, to pass value from parant to a child componnent, we can use **props**, which can be any type of JavaScript value.
In some cases, we want to pass a template, which can have custom styles or combination of multiple html elements. That's where Slots are useful.

For example, we may have a `<FancyButton>` component that supports usage like this:
```html
<FancyButton>
  Click me! <!-- slot content -->
</FancyButton>
```

The template of <FancyButton> looks like this:
```html
<button class="fancy-btn">
  <slot></slot> <!-- slot outlet -->
</button>
```
  
And the final rendered DOM:
```html
<button class="fancy-btn">Click me!</button>
```


