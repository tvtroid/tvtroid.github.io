---
layout: post
title: "Draw a custom shape with radial-gradient in CSS"
permalink: "/frontend/radial-gradient"
date: 2022-03-08 16:24:45 +0700
category: frontend
---

## Gradients

In CSS, we can set multiple backgrounds to a DOM element by using CSS Gradients.
There are 3 types of gradients:
- Linear Gradients (goes down/up/left/right/diagonally)
- Radial Gradients (defined by their center)
- Conic Gradients (rotated around a center point)

<img width="477" alt="image" src="https://user-images.githubusercontent.com/26586150/192479692-5136675d-0621-41cb-833a-7e6c1775783b.png">

_Example 1: Linear Gradients_ [Demo](https://jsfiddle.net/tvtroid/6hg5zx0b/112/)


<img width="478" alt="image" src="https://user-images.githubusercontent.com/26586150/192480661-d969423e-43f9-41cc-bf50-d29fa0edb219.png">

_Example 2: Radial Gradients_ [Demo](https://jsfiddle.net/tvtroid/6hg5zx0b/115/)


<img width="464" alt="image" src="https://user-images.githubusercontent.com/26586150/192480802-d86b8fd9-8ff0-47ec-bf6c-149f0558bf29.png">

_Example 3: Conic Gradients_ [Demo](https://jsfiddle.net/tvtroid/6hg5zx0b/116/)


<img width="665" alt="image" src="https://user-images.githubusercontent.com/26586150/192478991-016f5dab-1040-4789-a644-eb397b747ef5.png">

_Example 4: Multiple layers of background_ [Demo](https://jsfiddle.net/tvtroid/6hg5zx0b/108/)


## Radial Gradients

**Syntax:**

```
background-image: radial-gradient(shape size at position, start-color, ..., last-color);
```
- shape: `circle`/`ellipse` (default is `ellipse`)
- size: `closest-side`/`farthest-side`/`closest-corner`/`farthest-corner` (default is `farthest-corner`)
- position: default is `center`
- color: is a color value (red, #fff, rgba(0,0,0,0.5), etc.) followed by one or two top positions.

<img width="751" alt="image" src="https://user-images.githubusercontent.com/26586150/192675871-dec45887-2066-466d-84a5-9a22b7b1ccff.png">

<img width="616" alt="image" src="https://user-images.githubusercontent.com/26586150/192679137-0b8c13f1-1c44-4587-ab9a-dbb620e37d7c.png">

_Example 5: Ellipse shape_ [Demo](https://jsfiddle.net/tvtroid/6hg5zx0b/140/)


<img width="702" alt="image" src="https://user-images.githubusercontent.com/26586150/192678857-5182d848-a5b8-4186-9c9e-98aa3ad113e7.png">

_Example 6: Custom position_ [Demo](https://jsfiddle.net/tvtroid/6hg5zx0b/138/)


<img width="734" alt="image" src="https://user-images.githubusercontent.com/26586150/192682541-381d52cc-ee80-4698-b7a7-16ceabe1af0a.png">

_Example 7: Color_ [Demo](https://jsfiddle.net/tvtroid/6hg5zx0b/188/)


### Draw a custom shape

#### Issue
We have a white sticky header with border radius and the body part is scrollable. If scrolling down, we can see the background of the body is displayed at the corders of the header:

<img width="414" alt="image" src="https://user-images.githubusercontent.com/26586150/223032557-50e2e003-2890-4602-8a21-49620994f5d4.png">

[Demo](https://jsfiddle.net/tvtroid/6hg5zx0b/394/)

#### Solution
I will draw 2 custom shapes on top the the header to hide the red background at the corners.

[Demo](https://jsfiddle.net/tvtroid/6hg5zx0b/414/)

