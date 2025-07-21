---
layout: post
title: A Brief Introduction to ECS Architecture in game development
date: 2025-07-21
categories: gamedev
---

Recently I decided to dip my toes into the ECS architecture for game development inside Unity. My first experience with ECS was during the development of a [custom game engine written in C++](https://github.com/chrisvblemos/jage) (now outdated and looking horrible to my eyes). Now, I wanted to see how this architecture could look like in bigger projects like Unity - this is where I found out about [Unity DOTS](https://unity.com/dots), which I'm playing with at the moment. It won't be a surprise that I use terms from the context of DOTS.

Anyways, in order to improve my knowledge on the subject of ECS, I decided to write a brief introduction to the subject as how I understand it.

# What is ECS?

ECS stands for [Entity-Component-System](https://en.wikipedia.org/wiki/Entity_component_system). It's just a name that will make sense later in this text. It's a different way to structure your data and logic so that you can make your software run faster, far different than Object Oriented Programming. 

The idea behind ECS is to leverage how CPUs work at the memory level. The core of the idea is to use [Structures of Arrays (SoA)](https://en.wikipedia.org/wiki/AoS_and_SoA) so that, when the CPU needs data to run some kind of logic, all data needed for the calculation is contiguous in memory, which in turn, reduces the amount of [cache misses](https://en.wikipedia.org/wiki/Cache_(computing)#CACHE-MISS) during iterations - when the CPU has to look up for data in the memory (think of RAM memory), this is slower than looking at memory that is already present in the CPU cache (the CPU cache is physically closer to the CPU).

<p align="center">
  <img src="/assets/images/9fg0p.png"/>
</p>

> In reality, CPUs have more than one cache. Each closer to the CPU, and thus, faster to read from - but at the same time, the faster and closer a cache is to the CPU, the smaller the data it is able to store at each cycle. [There is this great video on the matter that explains why having data stored in arrays helps the CPU.](https://www.youtube.com/watch?v=247cXLkYt2M)

In object oriented programming, you have [pointers](https://en.wikipedia.org/wiki/Pointer_(computer_programming)) to instances of classes. You then have to access the data that these pointers point to. But everytime the CPU needs to read memory that a pointer is pointing to, it has to spend time fetching the data from the main memory - this is the slowest task in terms of memory transfer if we exclude reading from hard drives.

Now, if instead of pointers, we send arrays of data structures to the CPU, we eliminate the need to look for the memory blocks through pointers and also we are able to leverage CPU cache. When the CPU fetches data, it does so in blocks, as it is optimistic that the data needed for the next iteration will be close to the data it last pulled. So if all data is in a array, the next iteration of a loop might use data that is already inside the CPU cache, which again, is very fast for the CPU to read from. 

So by structuring our data without pointers, only values, and organizing them into size-fixed arrays in a smart way, we can then define Systems (classes even) that read and write from/to these arrays inside loops.

As a bonus of all these decisions, ECS works betters with [multithreaded jobs](https://en.wikipedia.org/wiki/Thread_(computing)), since it is easier to delegate the data operations to a later stage and avoid race conditions when using pointers directly.

The cons of this approach is that we introduce a lot of complexity to our code. Structuring data in a way that you can query for it in a fast way and also iterate through it is the central problem to using ECS architecture in your code.

# How do we add components/behaviour to a game object (a Character for instance)?

In the context of OOP game development, we typically have a class for GameObjects and Component classes that introduce behaviour to our game objects (those who are used to Unity might be familiar with these terms). We then add the logic inside this behaviours and iterate through them calling an Update method each frame of our game.

```
public class GameObject
{
    public List<Components> components;

    public AddComponent<T>()
    {
        ...
    }
}

public class Component
{
    public float Update()
    {
        ...
    }
}
```

Now, in the context of ECS, one of many ways you might organize the data is the following way:

- You define game objects as pure integers and call them Entities;
- You define components attached to a game object as structs of values (they only store data that is relevant to a specific behavior - a health component will store float CurrentHealth and float MaxHealth, for instance);
- You add and remove components to an entity by storing component data in an array such that its index is the id of the entity (this is one way to do things)

```
using Entity as int;

public const int MAX_ENTITIES = 1000;

public int EntityCount;
public Entity[MAX_ENTITIES] entities;

public struct HealthComponent
{
    public float Value;
    public float Max;
}

public HealthComponent[MAX_ENTITIES] healthComponents;

public CreateEntity()
{
    if (EntityCount >= MAX_ENTITIES) throw exception;

    return EntityCount++;
}

public AddHealthComponent(Entity entity)
{
    healthComponents[i] = new HealthComponent
    {
        Value = 100,
        Max = 100
    };
}
```

# How do I run logic on entities?

Since our components are just data containers, where is the logic that acts on this data?
In ECS, Systems are responsible for running the logic of our entities.

A system like HealthSystem might be interested in all of the Health components that exist within our game world, so we need a way to query for this data. To do this, we just need to iterate over our array of health components!

```
public class HealthSystem
{
    public void Update()
    {
        for (Entity entity  = 0; entity < MAX_HEALTH_COMPONENTS; i++)
        {
            healthComponents[entity].Value = ...;
            healthComponents[entity].Max = ...;
        }
    }
}

```

Now, there will be instances where your System might work with entities that need more than one component. For instance, you might have a UseItemSystem that will iterate only through entities that have both the ActionsComponent and the InventoryComponent (the first is to check if the entity wishes to use an item, while the second tells you which items this entity has at the moment).

The trivial solution would be to iterate both arrays from start to end (in other words, check for all entities which have both components). Obviously, this being the trivial solution, we can do better.

# Archetypes

To handle this, people came up with [Archetypes](https://docs.unity3d.com/Packages/com.unity.entities@0.2/manual/ecs_core.html). Archetypes are just a combination of components that an entity might have. In practice, you build arrays that contains combinations of components, storing entities that have this combination of components.

With archetypes, you don't need to iterate through all entities and check if they have the required components. You just query the array of a given archetype and you get your entities.

```

public class HealthSystem
{
    public void Update(ActionComponent[] actionsComponents, InventoryComponent[] inventoryComponents)
    {
        var entities = Archetypes.Query(ActionsComponent, InventoryComponent).ToArray();
        foreach (Entity entity in entities)
        {
            ActionsComponent actions = actionsComponents[entity];
            InventoryComponent inv = inventoryComponents[entity];

            if (actions.WasUseCalled && inv.HasItem(actions.ItemCalledOn))
            {
                ...
            }
        }
    }
}
```



So, the complexity comes from having to build these archetypes (which needs to be done everytime you add and/or remove components from an entity). 

Once this is done, querying becomes a trivial task, just read the correct array.

# Summarizing

We can summarize the philosophy behind this giant task of organizing your data with the following quote from an old professor of mine:

> "Why build a car with hammers and nails if I can build complex machines that builds hundreds of cars a month?"

This quote was made when a student complained about the complexity of definitions, without realizing he could be in a worse position complaining about the complexity of some proofs. Definitions are ethereal, theorems are not.

Getting back to ECS, I end this article with the following TLDR:

- All things are entities;
- All components are data;
- Entities are linked to components through arrays;
- Systems read and modify components;
- Iterate!

Of course there is a lot more to the subject, and all code written here is a very simplified implementation of it in pseudocode.

One thing that I haven't gone into details is how we can implement parallel jobs within this framework in a way that we increase our performance, specially for game development. Maybe because I still haven't fully grasped it. Maybe some time in the future.
