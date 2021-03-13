# Fun with Diffable Data Sources, MVVM, and the New York Times Best Sellers

## Overview

I wanted to do some experimentation with **UICollectionViewDiffableDataSource** and **UICollectionViewCompositionalLayouts**, so I decided to make a quick sample project with them!

The New York Times makes their best seller lists available via an API, so I decided to use that to make a simple visualization of the best seller lists through time.

I went with an **MVVM**-style architecture, and tried to keep my _View_ Layer completely separated from my _Model_ layer by my _ViewModel_ layer.

The first page of the app shows the top five books for all the lists. The initial **UICollectionViewCompositionalLayout** uses orthogonally scrolling sections to allow you to see the top 5 book covers for each list, and you can switch between this layout and a text-based layout using the nav bar button:

<img src="https://github.com/michael-kiley-verified/diffable_best_sellers/blob/main/README/demo1.gif" width="200" />

_(The gifs aren't as smooth as the real thing, I promise)_

Tapping **View** brings you to the full list. Swiping left and right allows you to navigate through time, taking advantage of **UICollectionViewDiffableDataSource** and its built-in animations to allow you to visualize how books are moving around on the lists over time:

<img src="https://github.com/michael-kiley-verified/diffable_best_sellers/blob/main/README/demo2.gif" width="200" />

And, of course, I wrote some tests, which have some of their own interesting things going on - take a look!

## Running the code

If you want to run this project yourself, you are going to need to provide your own NYT Books API api key in _Info.plist_, which you can get at https://developer.nytimes.com/.
Unfortunately, they aren't very generous with their rate limits, only allowing 6 calls per minute.

## Author

[Michael Kiley](https://harbourviewtechnologies.com)
