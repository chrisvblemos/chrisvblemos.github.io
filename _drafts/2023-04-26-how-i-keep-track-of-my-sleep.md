---
layout: post
title: How I've been keeping track of my Sleep
date: 2023-04-26
categories: health
usemathjax: true
---

Today I got the results from my sleep exam. It seems I have [Moderate Sleep Apnea/Hypopnea](https://en.wikipedia.org/wiki/Sleep_apnea). I plan on talking about this as soon as I get back to my doctor to discuss what are the next steps. Today I want to talk about how I've been keeping track of my sleep because, in the end, my spreadsheet looked beautiful and that's all that matters.

So lo and behold, the current state of the spreadsheet (click to enlarge it):

[![sleep-data-spreadsheet](/assets/images/sleep-data-spreadsheet.webp)](/assets/images/sleep-data-spreadsheet.webp){:.centered}


As you can see, not a lot of data. I've started to collect data on the 20th of March of 2023 but hopefully, I'll continue this for at least a year. I also think that's enough points to see the effects of any future treatment for my new condition. **Now allow me to explain what the data means.**

## the data

On the left, you got these cells of 1s and 0s. This "matrix" represents the sleep and awake states throughout the day, going from left to right, midnight (00:00) to eleven PM (23:00). If a cell is marked with a 0 (green), then it means I was awake at that time. If it's a 1 (blue) then I was asleep. The yellow and purple boxes around the cells indicate day and night along with the cute Sun and Moon emojis on the top.

You might notice some cells have a note added to them. I used notes to include moments where I took melatonin (0.41mg if you're curious) and see the effect of this on my sleep times. Since I lack discipline I failed to keep a consistent habit of taking it - oops,  might try again in the future.

The right side is where I calculate stuff using the data from the matrix of 1s and 0s. Below I explain the meaning behind each column from left to right:

- **Time Sleeping (h):** Total time spent sleeping on that day, in hours.
- **Time Awake (h):** Total time spent awake on that day, in hours.
- **Sleep to 24 Ratio (%):** The ratio of time sleeping versus 24 hours.
- **Wake to 24 Ratio (%):** The ratio of time awake versus 24 hours.
- **Avg Dur. Sleep (h):** Average duration of sleep since the beginning, in hours (I will change this to a rolling average when I have enough data).

And the last two most interesting ones, in my opinion:
- **Cumulative Sleep Lag (h):** This is a cumulative measure of deviation from Time Sleeping on that day to the current Avg Dur. Sleep, in hours. 

I call this lag because I use it to measure how much sleep I'm currently "behind or ahead" compared to the average. I want to experiment with the theory of [Sleep Debt](https://en.wikipedia.org/wiki/Sleep_debt).

I'm thinking of adding some qualitative data like the quality of sleep to better track a possible correlation with this metric.

- **Day/Night Cycle Desync:** This is my attempt at measuring how unsynchronized I am relative to the day and night cycle, calculated through the following expression:

    $$ \frac{(S_d + A_n)}{24} $$

    where $$ S_d $$ is the number of hours that I was asleep during the day and $$ A_n $$ is the number of hours that I was awake during the night.

This is a good number to keep track of how much daylight I'm missing. The higher the value, the more out of sync I am relative to the day cycle. As you can see I'm a night person. This is a very "personal" metric since a more natural reference would be your circadian cycle - which is hard to measure by itself. Since I'm interested in partaking in most human activities during the day and enjoying time with my family[^1] I want to keep this number as low as possible so I figured it makes sense to track it.

## why do this?

I've been suffering from bad sleep for the past 5 years. I constantly shift day and night and I always feel exhausted after sleeping for 9-10 hours. After reading about other people's experiences with similar symptoms I've decided to take a close look at my sleep habits and schedule a sleep exam. One of my first suspicions was that I might be suffering from [free-running sleep](https://en.wikipedia.org/wiki/Free-running_sleep) - a condition where the sleep cycle shifts every day. This is something that I haven't come to a conclusion on yet since I started to gather data only recently and I've been doing my best on keeping a fixed pattern over the last month. Since I got diagnosed with Sleep Apnea after the sleep exam I'm interested to see if treatment for this condition might fix the shift as well.

## the end

I've been having lots of fun doing this little research about my sleep habits and I'll surely be applying it to other instances of my daily life. I'm also planning on writing something about other past experiences with health problems. Until then, take care and sleep well.

[^1]: Also gotta get that Vitamin D.