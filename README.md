<p align="center">
  <img width="460" height="300" src="https://cdn.givingcompass.org/wp-content/uploads/2019/07/25081720/The-Plastic-Problem-in-Organic-Farming1.jpg">
</p>

# GardenSimulator


## Summary

This application is a game that allows to you plant, care for, and harvest fruits and vegetables in a garden. It is a multiplayer game, and users can interact by buying and selling plants and seeds in a marketplace.

## Gameplay

### Objective
The objective of the game is to eat as many crops as possible. The more crops you eat, the higher your score.

You also have money and a number of grow boxes that can be used to grow crops. You can use money to purchase crops or seeds, and conversely can sell seeds or crops to earn money.

### Features

#### Garden

In your garden view, you can see all your grow boxes and their current state. You can also plant seeds or harvest crops that are ready.

In the garden you may also choose to water your plants.

#### Inventory

Your inventory shows all the crops and seeds that you currently own. In this view you can also choose to list any of your inventory for sale in the marketplace.

#### Marketplace

The marketplace is a listing of all available crops and seeds that have been listed by other players. You can visit the marketplace to buy crops and seeds for the purpose of planting or eating.

### Actions

#### View Garden

To plant a seed, select a seed type from your inventory and drag the image to the desired spot in the grow box. The user inventory of the planted seed will decrease by one. To harvest a crop that is ready, click on the image and it will disappear. The user inventory of the crop will increase by one. The user points, money, and day passed is shown. 

#### Select Seeds

A display of the user seed inventory will appear that lists the id, name, and quantity. Input the seed id, quantity, and price you would like to sell for. The seed inventory will be reflected with the sell and a marketplace listing will be created. 

#### View Crops

A display of the user crop inventory will appear that lists the id, name, amount, and points for eating. Input the crop id, quantity, and price you would like to sell for. The crop inventory will be reflected with the sell and a marketplace listing will be created. Input the crop id and quantity you would like to eat. Your point increase will be reflected in the amount. 

#### Visit Marketplace 

A display of the marketplace will appear that lists the listing id, seller id, plant name, listing type (seed or crop), price, and quantity. Input the listing id you would like to purchase. Your inventory will increase by the quantity in the listing bought. Your money will decrease and the seller's money increases. 

#### Logout

Logging out of your account will return you to the homepage to sign in or create a new account.

#### Advance One Day

Advancing the day will increase the plant progess towards harvesting at the cost of one point. 


## ER Diagram

![ER Diagram for Garden Simulator](ER-Diagam.dio.png?raw=true "Title")
