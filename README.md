# Talents AddOn

## Brief

The purpose of this (WoW) AddOn is to be able to easily save and change between different talent profiles for each character spec.

## Content

* __Talents__: this folder contains the source code for the AddOn (and is the actual folder you need to put on your WoW AddOns folder).

## Install

Copy `Talents` folder to your WoW AddOns folder.

## Use

This is a command only AddOn, this mean no extra UI components aside from the game default ones.

Here you have a list of commands to use this AddOn:

* `/talents list` -- list all available profiles for current spec.
* `/talents save <profile-name>` -- save your current talents as 'profile-name'.
* `/talents use <profile-name>` -- change to profile's talents.
* `/talents delete <profile-name>` -- delete the profile.

You can also use the short version for each command

* `/ts ls` -- list all available profiles for current spec.
* `/ts s <profile-name>` -- save your current talents as 'profile-name'.
* `/ts u <profile-name>` -- change to profile's talents.
* `/ts del <profile-name>` -- delete the profile.

NOTE: `<profile-name>` is the name you want to give or gave to the profile. e.g. `pvp`

## FAQ

* __Does this save/load pvp talents too?__

yes, this addon save all talents including pvp ones for each profile.