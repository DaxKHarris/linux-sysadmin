#!/bin/bash

# === Create group ===
sudo groupadd admin-team

# === Create users ===
sudo useradd -m alice
sudo useradd -m bob

# === Set passwords ===
sudo passwd alice
sudo passwd bob

# === Append user to group ===
sudo usermod -aG admin-team alice

# === Add group to sudo ===
sudo visudo

